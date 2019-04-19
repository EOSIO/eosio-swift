//
//  EosioRpcProviderTests.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/3/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import XCTest
@testable import EosioSwift
import OHHTTPStubs

class EosioRpcProviderTests: XCTestCase {

    var rpcProvider: EosioRpcProviderProtocol?
    let numberOfRetries: UInt = 7
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://localhost")!
        let url2 = URL(string: "https://endpoint2example")!
        let url3 = URL(string: "https://endpoint3example")!
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: numberOfRetries)

        OHHTTPStubs.onStubActivation { (request, stub, _) in
            print("\(request.url!) stubbed by \(stub.name!).")
        }
    }

    override func tearDown() {
        super.tearDown()

        //remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }

    func test_rpcProvider_whenEndpointsReturnBusyResponseStatusCode_shouldTryOtherAvailableEndpoints() {
        var firstEndpointTried = false
        var secondEndpointTried = false
         var thirdEndpointTried = false
        let json = RpcTestConstants.infoResponseJson
        let data = json.data(using: .utf8)
        (stub(condition: isHost("localhost") || isHost("endpoint2example") || isHost("endpoint3example")) { request in
            let host = request.url?.host
            switch host {
            case "localhost" :
                firstEndpointTried = true
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            case "endpoint2example" :
                secondEndpointTried = true
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            case "endpoint3example":
                thirdEndpointTried = true
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }
        }).name = "EndpointsReturnBusyResponseStatusCode_shouldTryOtherAvailableEndpoints stub"
        let expect = expectation(description: "Failover test stub")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { _ in

            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)

        XCTAssertTrue(firstEndpointTried && secondEndpointTried && thirdEndpointTried)
    }

    func test_rpcProvider_shouldCheckForMatchingChainIdsWhenExecutingRequests() {
        var firstEndpointTried = false
        let json = RpcTestConstants.infoResponseJson
        let data = json.data(using: .utf8)
        (stub(condition: isHost("localhost") || isHost("endpoint2example") || isHost("endpoint3example")) { request in
            let host = request.url?.host
            switch host {
            case "localhost" :
                if !firstEndpointTried {
                    firstEndpointTried = true
                    return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
                } else {
                    return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
                }
            case "endpoint2example" :
                let json = RpcTestConstants.infoResponseEndpoint2Json
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            case "endpoint3example":
                let json = RpcTestConstants.infoResponseEndpoint3Json
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }
        }).name = "RemoveEndpointsWithInvalidChainIds stub"

        let expect = expectation(description: "Match chain id test")
        rpcProvider?.getInfo { _ in
            self.rpcProvider?.getInfo { result in
                switch result {
                case .success(let response):
                    XCTAssertEqual(response.headBlockNum, 25260039)
                    XCTAssertTrue(firstEndpointTried)
                case .failure:
                    XCTFail("Returned failure instead of success")
                }
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    func test_rpcProvider_shouldRemoveEndpointsWithInvalidChainIds() {
        var endpoint1Tried = 0
        var numberOfTimesEndpoint2Called = 0
        var endpoint3Called = false
        let json = RpcTestConstants.infoResponseJson
        let data = json.data(using: .utf8)
        (stub(condition: isHost("localhost") || isHost("endpoint2example") || isHost("endpoint3example")) { request in
            let host = request.url?.host
            switch host {
            case "localhost" :
                endpoint1Tried += 1
                if endpoint1Tried < 3 {
                    return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
                }
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            case "endpoint2example" :
                numberOfTimesEndpoint2Called += 1
                let json = RpcTestConstants.infoResponseEndpoint2Json
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            case "endpoint3example":
                if !endpoint3Called {
                    endpoint3Called = true
                    return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
                }
                endpoint1Tried = 0
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }
        }).name = "RemoveEndpointsWithInvalidChainIds stub"

        let expect = expectation(description: "first call")

        self.rpcProvider?.getInfo { _ in
            self.rpcProvider?.getInfo { _ in
                self.rpcProvider?.getInfo { _ in
                    self.rpcProvider?.getInfo { _ in
                        XCTAssertEqual(numberOfTimesEndpoint2Called, 1)
                        expect.fulfill()
                    }
                }
            }
        }
        self.wait(for: [expect], timeout: 30)

    }

    func test_rpcProvider_shouldRetryRequestsUpToNumberOfRetriesBeforeReturningError() {
        var numberOfTimesTried: UInt = 0
        (stub(condition: isHost("localhost")) { _ in
            numberOfTimesTried += 1
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            return OHHTTPStubsResponse(error: error)
        }).name = "Failover test stub"

        let expect = expectation(description: "Request retry test stub")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { _ in

            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
        XCTAssertEqual(numberOfTimesTried, numberOfRetries)
    }

    func test_rpcProvider_shouldReturnCorrectResponseAfterFailover() {
        let json = RpcTestConstants.infoResponseJson
        let data = json.data(using: .utf8)
        (stub(condition: isHost("localhost") || isHost("endpoint2example") || isHost("endpoint3example")) { request in
            let host = request.url?.host
            switch host {
            case "localhost" :
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            case "endpoint2example" :
                return OHHTTPStubsResponse(data: data!, statusCode: 503, headers: nil)
            case "endpoint3example":
                return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }
        }).name = "Failover test stub"
        let expect = expectation(description: "Failover test stub")

        rpcProvider?.getInfo { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.chainId, "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17")
            case .failure (let error):
                XCTFail("Returned failure \(error)")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /**
     * Test RPC protocol provider implementation error handling for Non 200 server http status codes.
     *
     */
    func testInvalidValidHttpStatusHandled() {
        (stub(condition: isHost("localhost")) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            return OHHTTPStubsResponse(error: error)
        }).name = "Invalid HTTP Status Code stub"

        let expect = expectation(description: "testInvalidValidHttpStatus")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success:
                XCTFail("Succeeded get_block call despite being malformed")
            case .failure(let err):
                XCTAssertTrue(err.description == "Error was was encountered in RpcProvider.")
                XCTAssertNotNil(err.originalError)
                XCTAssertTrue(err.originalError!.code == NSURLErrorNotConnectedToInternet)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test RPC protocol provider implementation error handling for bad response data.
    func testBadResponseDataHandled() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Bad Response stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"
        let expect = expectation(description: "testBadResponseData")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("testBadResponseDataHandled should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason == "Error occurred in decoding/serializing returned data.")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test RPC protocol provider implementation error handling for bad server response.
    func testBadServerResponseHandled() {
        (stub(condition: isHost("localhost") || isHost("endpoint2example") || isHost("endpoint3example")) { request in
            let absoluteUrl = request.url?.absoluteString
            switch absoluteUrl {
            case "https://localhost/v1/chain/get_info" :
                let badServerResponseError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
                return OHHTTPStubsResponse(error: badServerResponseError)
            case "https://endpoint2example/v1/chain/get_info" :
                let badServerResponseError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
                return OHHTTPStubsResponse(error: badServerResponseError)
            case "https://endpoint3example/v1/chain/get_info":
                let badServerResponseError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
                return OHHTTPStubsResponse(error: badServerResponseError)
            default:
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }
        }).name = "BadServerResponseHandled stub"
        let expect = expectation(description: "testBadServerResponse")
        rpcProvider?.getInfo { response in
            switch response {
            case .success(let infoResponse):
                print("\(infoResponse)")
                XCTFail("testBadServerResponse should have not returned a successful completion.")
            case .failure(let err):
                if let origError = err.originalError {
                    XCTAssertTrue(origError.code == URLError.badServerResponse.rawValue)
                } else {
                    XCTFail("testBadServerResponse should have an originial error returned.")
                }
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    ///Test RPC protocol provider implementation error handling for no network connection.
    func testNoNetworkHandled() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let noConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
            return OHHTTPStubsResponse(error: noConnectedError)
        }).name = "No Network stub"
        let expect = expectation(description: "testNoNetwork")
        rpcProvider?.getInfo { response in
            switch response {
            case .success(let infoResponse):
                print("\(infoResponse)")
                XCTFail("testNoNetwork should have not returned a successful completion.")
            case .failure(let err):
                if let origError = err.originalError {
                     XCTAssertTrue(origError.code == URLError.notConnectedToInternet.rawValue)
                } else {
                   XCTFail("testNoNetwork should have an originial error returned.")
                }
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getBlock() protocol implementation.
    func testGetInfo() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Info stub"

        let expect = expectation(description: "testGetInfo")
        rpcProvider?.getInfo { response in
            switch response {
            case .success(let infoResponse):
                guard let rpcInfoResponse = infoResponse as? EosioRpcInfoResponse else {
                    return XCTFail("No valid get_info response")
                }
                XCTAssertTrue(rpcInfoResponse.serverVersion == "0f6695cb")
                XCTAssertTrue(rpcInfoResponse.headBlockNum == 25260035)
                XCTAssertTrue(rpcInfoResponse.headBlockId == "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05")
            case .failure(let err):
                print(err.description)
                XCTFail("Failed to complete get_info request")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getBlock() protocol implementation.
    func testGetBlock() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block")) { _ in
            let json = RpcTestConstants.blockResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Block stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetBlock")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum == 25260032)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix == 2249927103)
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getBlock() extended structure implementation.
    func testGetExtendedBlock() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block")) { _ in
            let json = RpcTestConstants.blockResponseWithTransactionJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Block stub"

        let expect = expectation(description: "testGetBlockExtended")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum == 21098575)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix == 2809448984)
                XCTAssertTrue(rpcBlockResponse.id == "0141f04f881cbe5018ca74a75953abf11a3d5a888c41ceee0cf5014c88ac0def")
                if let transactionDict = rpcBlockResponse.transactions[0] as? [String: Any],
                    let status = transactionDict["status"] as? String {
                        XCTAssert(status == "executed")
                } else {
                    XCTFail("Should be able to access transactions array, find transaction status and match.")
                }
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getRawAbi() protocol implementation with name.
    func testGetRawAbiEosio() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_abi")) { _ in
            let name = try? EosioName("eosio")
            let json = RpcTestConstants.createRawApiResponseJson(account: name!)
            let data = json!.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get RawAbi Name stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio")
            let requestParameters = EosioRpcRawAbiRequest(accountName: name)
            rpcProvider?.getRawAbi(requestParameters: requestParameters) { response in
                switch response {
                case .success(let rawAbiResponse):
                    guard let rpcRawAbiResponse = rawAbiResponse as? EosioRpcRawAbiResponse else {
                        return XCTFail("Failed to parse raw abi response")
                    }
                    XCTAssertTrue(rpcRawAbiResponse.accountName == "eosio")
                    XCTAssertTrue(rpcRawAbiResponse.codeHash == "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096")
                    XCTAssertTrue(rpcRawAbiResponse.abiHash == "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
                case .failure(let err):
                    print(err.description)
                    XCTFail("Failed to get raw abi")
                }
                expect.fulfill()
            }
            wait(for: [expect], timeout: 30)
        } catch {
            XCTFail("\(error)")
        }
    }
    /// Test getRawAbi() protocol implementation with token.
    func testGetRawAbiToken() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_abi")) { _ in
            let token = try? EosioName("eosio.token")
            let json = RpcTestConstants.createRawApiResponseJson(account: token!)
            let data = json!.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get RawAbi Token stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio.token")
            let requestParameters = EosioRpcRawAbiRequest(accountName: name)
            rpcProvider?.getRawAbi(requestParameters: requestParameters) { response in
                switch response {
                case .success(let rawAbiResponse):
                    guard let rpcRawAbiResponse = rawAbiResponse as? EosioRpcRawAbiResponse else {
                        return XCTFail("Failed to parse raw abi response")
                    }
                    XCTAssertTrue(rpcRawAbiResponse.accountName == "eosio.token")
                    XCTAssertTrue(rpcRawAbiResponse.codeHash == "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348")
                    XCTAssertTrue(rpcRawAbiResponse.abiHash == "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                case .failure(let err):
                    print(err.description)
                    XCTFail("Failed to get raw abi")
                }
                expect.fulfill()
            }
            wait(for: [expect], timeout: 30)
        } catch {
            XCTFail("\(error)")
        }
    }
    /// Test getRequiredKeys() protocol implementation.
    func testGetRequiredKeys() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_required_keys")) { _ in
            let json = RpcTestConstants.requiredKeysResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Required Keys stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetRequiredKeys")

        let transaction = EosioTransaction()
        let requestParameters = EosioRpcRequiredKeysRequest(availableKeys: ["PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG"], transaction: transaction)

        rpcProvider?.getRequiredKeys(requestParameters: requestParameters) { response in
            switch response {
            case .success(let requiredKeysResponse):
                guard let rpcRequiredKeysResponse = requiredKeysResponse as? EosioRpcRequiredKeysResponse else {
                    return XCTFail("Failed to parse rpc required key response")
                }
                XCTAssertTrue(rpcRequiredKeysResponse.requiredKeys.count == 1)
                XCTAssertTrue(rpcRequiredKeysResponse.requiredKeys[0] == "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba")

            case .failure(let err):
                XCTFail("\(err.description)")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test pushTransaction() protocol implementation.
    func testPushTransaction() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/push_transaction")) { _ in
            let json = RpcTestConstants.pushTransActionResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Push Transaction stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testPushTransaction")
        // swiftlint:disable line_length
        let requestParameters = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"], compression: 0, packedContextFreeData: "", packedTrx: "C62A4F5C1CEF3D6D71BD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        // swiftlint:enable line_length
        rpcProvider?.pushTransaction(requestParameters: requestParameters) { response in
            switch response {
            case .success(let pushedTransactionResponse):
                XCTAssertTrue(pushedTransactionResponse.transactionId == "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a")
            case .failure(let err):
                XCTFail("\(err.description)")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
}
