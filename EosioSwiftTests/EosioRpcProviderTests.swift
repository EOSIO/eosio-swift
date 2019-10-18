//
//  EosioRpcProviderTests.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/3/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import XCTest
@testable import EosioSwift
import OHHTTPStubs

class EosioRpcProviderTests: XCTestCase {

    let url = URL(string: "https://localhost")!
    let url2 = URL(string: "https://endpoint2example")!
    let url3 = URL(string: "https://endpoint3example")!
    var rpcProvider: EosioRpcProviderProtocol!

    override func setUp() {
        super.setUp()
        rpcProvider  = EosioRpcProvider(endpoint: url)
        OHHTTPStubs.onStubActivation { (request, stub, _) in
            print("\(request.url!) stubbed by \(stub.name!).")
        }
    }

    override func tearDown() {
        super.tearDown()

        //remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }

    // MARK: Retry tests
    func test_rpcProvider_shouldNotRetryFor418HttpStatusError() {
        var numberOfTimesTried: UInt = 0
        var call = 1
        (stub(condition: isHost("localhost")) { request in
            if call == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                print("CALL \(call)")
                let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: call, urlRelativePath: request.url?.relativePath)
                call += 1
                return retVal
            } else {
                print("CALL \(call)")
                call += 1
                numberOfTimesTried += 1
                let json = RpcTestConstants.infoResponseJson
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 418, headers: nil)
            }
        }).name = "Retry Http Status 418 Error stub"
        let expect = expectation(description: "test_rpcProvider_shouldNotRetryFor418HttpStatusError")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("test should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason.contains("Invalid HTTP response (418) for"))
                XCTAssertEqual(numberOfTimesTried, 1)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }

    func test_rpcProvider_shouldNotRetryFor401HttpStatusError() {
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: 3)
        var numberOfTimesTried: UInt = 0
        var call = 1
        (stub(condition: isHost("localhost")) { request in
            if call == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                print("CALL \(call)")
                let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: call, urlRelativePath: request.url?.relativePath)
                call += 1
                return retVal
            } else {
                print("CALL \(call)")
                call += 1
                numberOfTimesTried += 1
                let json = RpcTestConstants.infoResponseJson
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 401, headers: nil)
            }
        }).name = "Retry Http Status 401 Error stub"
        let expect = expectation(description: "test_rpcProvider_shouldNotRetryFor401HttpStatusError")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("test should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason.contains("Unauthorized (https://localhost/v1/chain/get_block"))
                XCTAssertEqual(numberOfTimesTried, 1)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }

    func test_rpcProvider_shouldNotRetryFor500HttpStatusError() {
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: 3)
        var numberOfTimesTried: UInt = 0
        var call = 1
        (stub(condition: isHost("localhost")) { request in
            if call == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                print("CALL \(call)")
                let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: call, urlRelativePath: request.url?.relativePath)
                call += 1
                return retVal
            } else {
                print("CALL \(call)")
                call += 1
                numberOfTimesTried += 1
                let json = RpcTestConstants.infoResponseJson
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 500, headers: nil)
            }
        }).name = "Retry Http Status 500 Error stub"
        let expect = expectation(description: "test_rpcProvider_shouldNotRetryFor500HttpStatusError")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("test should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason.contains("Invalid HTTP response (500) for"))
                XCTAssertEqual(numberOfTimesTried, 1)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }

    func test_rpcProvider_shouldRetryBeforeReturningHttpStatusError() {
        rpcProvider = EosioRpcProvider(endpoint: url, retries: 3)
        var numberOfTimesTried: UInt = 0
        var call = 1
        (stub(condition: isHost("localhost")) { request in
            if call == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                print("CALL \(call)")
                let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: call, urlRelativePath: request.url?.relativePath)
                call += 1
                return retVal
            } else {
                print("CALL \(call)")
                call += 1
                numberOfTimesTried += 1
                let json = RpcTestConstants.infoResponseJson
                let data = json.data(using: .utf8)
                return OHHTTPStubsResponse(data: data!, statusCode: 501, headers: nil)
            }
        }).name = "Retry Http Status Error stub"
        let expect = expectation(description: "test_rpcProvider_shouldRetryBeforeReturningHttpStatusError")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("test should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason.contains("Invalid HTTP response (501) for"))
                XCTAssertEqual(numberOfTimesTried, 3)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }

    // MARK: Other tests
    /// Test RPC protocol provider implementation error handling for bad response data.
    func testBadResponseDataHandled() {
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            if let relativePath = request.url?.relativePath {
                if callCount == 1 {
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: relativePath)
                    callCount += 1
                    return retVal
                } else {
                    let json = RpcTestConstants.infoResponseJson
                    let data = json.data(using: .utf8)
                    return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
                }
            } else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No valid url string in request in stub")
            }
        }).name = "Bad Response Handled stub"
        let expect = expectation(description: "testBadResponseDataHandled")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("testBadResponseDataHandled should have not returned a successful completion.")
            case .failure(let err):
                print("Bad Response stub error: \(err)")
                XCTAssertTrue(err.reason.contains("Error occurred in decoding/serializing returned data."))
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)
    }

    ///Test RPC protocol provider implementation error handling for no network connection.
    func testNoNetworkHandled() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorNotConnectedToInternet, reason: "Not connected to the internet.")
        }).name = "No Network stub"
        let expect = expectation(description: "testNoNetwork")
        rpcProvider.getInfo { response in
            switch response {
            case .success(let infoResponse):
                print("\(infoResponse)")
                XCTFail("testNoNetwork should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason == "Not connected to the internet.")
                if let origError = err.originalError {
                     print(origError)
                     XCTAssertTrue(origError.code == NSURLErrorNotConnectedToInternet)
                } else {
                   XCTFail("testNoNetwork should have an originial error returned.")
                }
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /// Test getInfo() protocol implementation.
    func testGetInfo() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            return RpcTestConstants.getInfoOHHTTPStubsResponse()
        }).name = "Get Info stub"

        let expect = expectation(description: "testGetInfo")
        rpcProvider.getInfo { response in
            switch response {
            case .success(let infoResponse):
                guard let rpcInfoResponse = infoResponse as? EosioRpcInfoResponse else {
                    return XCTFail("No valid get_info response")
                }
                XCTAssertTrue(rpcInfoResponse.chainId == "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17")
                let concreteRpcProvider = self.rpcProvider as? EosioRpcProvider
                XCTAssertTrue(rpcInfoResponse.chainId == concreteRpcProvider?.chainId)
                XCTAssertTrue(rpcInfoResponse.serverVersion == "0f6695cb")
                XCTAssertTrue(rpcInfoResponse.headBlockNum.value == 25260035)
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath)
            callCount += 1
            return retVal
        }).name = "Get Block stub"
        let expect = expectation(description: "testGetBlock")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum.value == 25260032)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix.value == 2249927103)
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /// Test getBlock() protocol implementation with using an UInt64 block num.
    func testGetBlockByNum() {
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath)
            callCount += 1
            return retVal
        }).name = "Get Block stub"
        let expect = expectation(description: "testGetBlock")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum.value == 25260032)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix.value == 2249927103)
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /// Test getBlock() protocol implementation with using a block id.
    func testGetBlockById() {
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath)
            callCount += 1
            return retVal
        }).name = "Get Block stub"
        let expect = expectation(description: "testGetBlock")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum.value == 25260032)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix.value == 2249927103)
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            if let urlString = request.url?.absoluteString {
                if callCount == 1 && urlString == "https://localhost/v1/chain/get_info" {
                    callCount += 1
                    return RpcTestConstants.getInfoOHHTTPStubsResponse()
                } else if callCount == 2 && urlString == "https://localhost/v1/chain/get_block" {
                    return RpcTestConstants.getOHHTTPStubsResponseForJson(json: RpcTestConstants.blockResponseWithTransactionJson)
                } else {
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorUnknown, reason: "Unexpected call count in stub: \(callCount)")
                }
            } else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No valid url string in request in stub")
            }
        }).name = "Get Extended Block stub"

        let expect = expectation(description: "testGetBlockExtended")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.blockNum.value == 21098575)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix.value == 2809448984)
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let name = try? EosioName("eosio")
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath, name: name!)
            callCount += 1
            return retVal
        }).name = "Get RawAbi Name stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio")
            let requestParameters = EosioRpcRawAbiRequest(accountName: name)
            rpcProvider.getRawAbi(requestParameters: requestParameters) { response in
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let token = try? EosioName("eosio.token")
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath, name: token!)
            callCount += 1
            return retVal
        }).name = "Get RawAbi Token stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio.token")
            let requestParameters = EosioRpcRawAbiRequest(accountName: name)
            rpcProvider.getRawAbi(requestParameters: requestParameters) { response in
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath)
            callCount += 1
            return retVal
        }).name = "Get Required Keys stub"
        let expect = expectation(description: "testGetRequiredKeys")
        let transaction = EosioTransaction()
        let requestParameters = EosioRpcRequiredKeysRequest(availableKeys: ["PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG"], transaction: transaction)

        rpcProvider.getRequiredKeys(requestParameters: requestParameters) { response in
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
        var callCount = 1
        (stub(condition: isHost("localhost")) { request in
            let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: callCount, urlRelativePath: request.url?.relativePath)
            callCount += 1
            return retVal
        }).name = "Push Transaction stub"
        let expect = expectation(description: "testPushTransaction")
        // swiftlint:disable line_length
        let requestParameters = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"], compression: 0, packedContextFreeData: "", packedTrx: "C62A4F5C1CEF3D6D71BD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        // swiftlint:enable line_length
        rpcProvider.pushTransaction(requestParameters: requestParameters) { response in
            switch response {
            case .success(let pushedTransactionResponse):
                XCTAssertTrue(pushedTransactionResponse.transactionId == "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a")
                if let resp = pushedTransactionResponse as? EosioRpcTransactionResponse,
                    let processed = resp.processed as [String: Any]?,
                    let receipt = processed["receipt"] as? [String: Any],
                    let status = receipt["status"] as? String {
                    XCTAssert(status == "executed")
                } else {
                    XCTFail("Should be able to find processed.receipt.status and verify its value.")
                }
            case .failure(let err):
                XCTFail("\(err.description)")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    // MARK: Failover tests
    /// Tests that full failover with retries over all endpoints will return proper error information.
    // swiftlint:disable function_body_length
    func testFullFailoverWithRetries() {
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: 3)
        var numberOfTimesTried = 0
        var numberOfFailovers = 0
        var localHostCall = 1
        var endpoint2exampleCall = 1
        var endpoint3exampleCall = 1
        (stub(condition: isScheme("https")) { request in

            guard let host = request.url?.host else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No valid URL host in request in stub")
            }
            switch host {
            case "localhost":
                if localHostCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("localhost CALL \(localHostCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: localHostCall, urlRelativePath: request.url?.relativePath)
                    localHostCall += 1
                    return retVal
                } else {
                    print("localhost CALL \(localHostCall)")
                    numberOfTimesTried += 1
                    localHostCall += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorNetworkConnectionLost, reason: "connection lost")
                }
            case "endpoint2example":
                if endpoint2exampleCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("endpoint2example CALL \(endpoint2exampleCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint2exampleCall, urlRelativePath: request.url?.relativePath)
                    endpoint2exampleCall += 1
                    numberOfFailovers += 1
                    return retVal
                } else {
                    print("endpoint2example CALL \(endpoint2exampleCall)")
                    endpoint2exampleCall += 1
                    numberOfTimesTried += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorNetworkConnectionLost, reason: "connection lost")
                }
            case "endpoint3example":
                if endpoint3exampleCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("endpoint3example CALL \(endpoint3exampleCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint3exampleCall, urlRelativePath: request.url?.relativePath)
                    endpoint3exampleCall += 1
                    numberOfFailovers += 1
                    return retVal
                } else {
                    print("endpoint3example CALL \(endpoint3exampleCall)")
                    numberOfTimesTried += 1
                    endpoint3exampleCall += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorNetworkConnectionLost, reason: "connection lost")
                }

            default:
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "Unexpected host: \(host)")
            }

        }).name = "testFullFailoverFatalError"
        let expect = expectation(description: "testFullFailoverFatalError")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                print("\(blockResponse)")
                XCTFail("test should have not returned a successful completion.")
            case .failure(let err):
                XCTAssertTrue(err.reason.contains("connection lost"))
                XCTAssertEqual(numberOfTimesTried, 9)
                XCTAssertEqual(numberOfFailovers, 2)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 30)

    }

    /// Tests that failover with success at second endpoint will show proper results and retries.
    func testFailoverNextEndpointSuccess() {
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: 3)
        var numberOfFailovers = 0
        var localHostCall = 1
        var localHostTimesTried = 0
        var endpoint2exampleCall = 1
        var endpoint2exampleTimesTried = 0
        (stub(condition: isScheme("https")) { request in

            guard let host = request.url?.host else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No valid URL host in request in stub")
            }
            switch host {
            case "localhost":
                if localHostCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("localhost CALL \(localHostCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: localHostCall, urlRelativePath: request.url?.relativePath)
                    localHostCall += 1
                    return retVal
                } else {
                    print("localhost CALL \(localHostCall)")
                    localHostTimesTried += 1
                    localHostCall += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorDNSLookupFailed, reason: "Too many redirects.")
                }
            case "endpoint2example":
                if endpoint2exampleCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("endpoint2example CALL \(endpoint2exampleCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint2exampleCall, urlRelativePath: request.url?.relativePath)
                    endpoint2exampleCall += 1
                    return retVal
                } else {
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint2exampleCall, urlRelativePath: request.url?.relativePath)
                    endpoint2exampleCall += 1
                    numberOfFailovers += 1
                    endpoint2exampleTimesTried += 1
                    return retVal
                }
            default:
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "Unexpected! Should not have reached here in the stub!")
            }
        }).name = "testFailoverNextEndpointSuccess stub"
        let expect = expectation(description: "testFailoverNextEndpointSuccess")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
                XCTAssertEqual(localHostTimesTried, 3)
                XCTAssertEqual(numberOfFailovers, 1)
                XCTAssertEqual(endpoint2exampleTimesTried, 1)
                expect.fulfill()
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
        }
        wait(for: [expect], timeout: 30)
    }

    /// Tests that failover moves to next if chain ID is not the same as previously successful endpoint
    // swiftlint:disable cyclomatic_complexity
    func testFailoverWithBadChainId() {
        rpcProvider = EosioRpcProvider(endpoints: [url, url2, url3], retries: 3)
        var numberOfFailovers = 0
        var localHostCall = 0
        var localHostTimesTried = 0
        var endpoint2exampleCall = 0
        var endpoint2exampleTimesTried = 0
        var endpoint3exampleCall = 0
        var endpoint3exampleTimesTried = 0
        (stub(condition: isScheme("https")) { request in

            guard let host = request.url?.host else {
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "No valid URL host in request in stub")
            }
            switch host {
            case "localhost":
                localHostCall += 1
                if localHostCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("localhost CALL \(localHostCall)")
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: localHostCall, urlRelativePath: request.url?.relativePath)
                    return retVal
                } else {
                    print("localhost CALL \(localHostCall)")
                    localHostTimesTried += 1
                    localHostCall += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(code: NSURLErrorDNSLookupFailed, reason: "Too many redirects.")
                }
            case "endpoint2example":
                endpoint2exampleCall += 1
                if endpoint2exampleCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("endpoint2example CALL \(endpoint2exampleCall)")
                    numberOfFailovers += 1
                    // bad chain id that doesnt match "normal" chain id.
                    let json = RpcTestConstants.infoResponseBadChainIdJson
                    let data = json.data(using: .utf8)
                    return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
                } else {
                    print("endpoint2example CALL \(endpoint2exampleCall)")
                    endpoint2exampleTimesTried += 1
                    return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "Unexpected! Should not have reached here in the stub! Chain ID should have been bad")
                }
            case "endpoint3example":
                endpoint3exampleCall += 1
                if endpoint3exampleCall == 1 && request.url?.relativePath == "/v1/chain/get_info" {
                    print("endpoint3example CALL \(endpoint3exampleCall)")
                    numberOfFailovers += 1
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint3exampleCall, urlRelativePath: request.url?.relativePath)

                    return retVal
                } else {
                    let retVal = RpcTestConstants.getHHTTPStubsResponse(callCount: endpoint3exampleCall, urlRelativePath: request.url?.relativePath)
                    endpoint3exampleTimesTried += 1
                    return retVal
                }
            default:
                return RpcTestConstants.getErrorOHHTTPStubsResponse(reason: "Unexpected! Should not have reached here in the stub!")
            }
        }).name = "testFailoverWithBadChainId stub"
        let expect = expectation(description: "testFailoverWithBadChainId")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: "25260032")
        rpcProvider.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    return XCTFail("Failed to convert rpc response")
                }

                // expected a valid block response and values
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")

                // orig localhost should have been successfull for first required getInfo call to set the chainId but fails with retries for actual call.
                XCTAssertEqual(localHostTimesTried, 3)

                // failover to endpoint2example should have returned improper chain id and hence no try calls for actual rpc request
                XCTAssertEqual(endpoint2exampleCall, 1)

                // 2 failovers expected; 1 for call to endpoint2example that had bad chain id, second for failover to endpoint3example that completed the request successfully.
                XCTAssertEqual(numberOfFailovers, 2)

                // endpoint3example should have worked correctly.
                XCTAssertEqual(endpoint3exampleTimesTried, 1)
                expect.fulfill()
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block attempt")
            }
        }
        wait(for: [expect], timeout: 30)
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
}
