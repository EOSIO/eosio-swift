//
//  RpcProviderEndpointPromiseTests.swift
//  EosioSwiftTests
//
//  Created by Brandon Fancher on 4/18/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift
import PromiseKit
import OHHTTPStubs

class RpcProviderEndpointPromiseTests: XCTestCase {

    var rpcProvider: EosioRpcProvider?
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://localhost")
        rpcProvider = EosioRpcProvider(endpoint: url!)
        OHHTTPStubs.onStubActivation { (request, stub, _) in
            print("\(request.url!) stubbed by \(stub.name!).")
        }
    }
    override func tearDown() {
        super.tearDown()
        //remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }

    /// Test getInfo promise implementation.
    func testGetInfo(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "Get Info stub"
        let expect = expectation(description: "testGetInfo")

        firstly {
            (rpcProvider?.getInfo(.promise))!
        }.done {
            if unhappy {
                XCTFail("testGetInfo unhappy path should not fulfill promise!")
            }
            XCTAssertTrue($0.serverVersion == "0f6695cb")
            XCTAssertTrue($0.headBlockNum == 25260035)
            XCTAssertTrue($0.headBlockId == "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05")
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed push_transactions")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getInfo promise happy path.
    func testGetInfoSuccess() {
        testGetInfo()
    }

    /// Test getInfo promise unhappy path.
    func testGetInfoFail() {
        testGetInfo(unhappy: true)
    }

    /// Test getBlock() promise implementation.
    func testGetBlock(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block")) { _ in
            let json = RpcTestConstants.blockResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "Get Block Stub"
        let expect = expectation(description: "testGetBlock")
        let requestParameters = EosioRpcBlockRequest(blockNumOrId: 25260032)

        firstly {
            (rpcProvider?.getBlock(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetBlock unhappy path should not fulfill promise!")
            }
            XCTAssertTrue($0.blockNum == 25260032)
            XCTAssertTrue($0.refBlockPrefix == 2249927103)
            XCTAssertTrue($0.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_block")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getBlock promise happy path.
    func testGetBlockSuccess() {
        testGetBlock()
    }

    /// Test getBlock promise unhappy path.
    func testGetBlockFail() {
        testGetBlock(unhappy: true)
    }

    /// Test getRawAbi() promise implementation.
    func testGetRawAbi(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_abi")) { _ in
            let name = try? EosioName("eosio")
            let json = RpcTestConstants.createRawApiResponseJson(account: name!)
            let data = json!.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "Get RawAbi Name stub"
        let expect = expectation(description: "testGetRawAbi")

        let name = try? EosioName("eosio")
        let requestParameters = EosioRpcRawAbiRequest(accountName: name!)

        firstly {
            (rpcProvider?.getRawAbi(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetRawAbi unhappy path should not fulfill promise!")
            }
            XCTAssertTrue($0.accountName == "eosio")
            XCTAssertTrue($0.codeHash == "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096")
            XCTAssertTrue($0.abiHash == "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_raw_abi")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getRawAbi promise happy path.
    func testGetRawAbiSuccess() {
        testGetRawAbi()
    }

    /// Test getRawAbi promise unhappy path.
    func testGetRawAbiFail() {
        testGetRawAbi(unhappy: true)
    }

    /// Test getRequiredKeys() promise implementation.
    func testGetRequiredKeys(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_required_keys")) { _ in
            let json = RpcTestConstants.requiredKeysResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "Get Required Keys stub"
        let expect = expectation(description: "testGetRequiredKeys")

        let transaction = EosioTransaction()
        let requestParameters = EosioRpcRequiredKeysRequest(availableKeys: ["PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG"], transaction: transaction)

        firstly {
            (rpcProvider?.getRequiredKeys(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetRequiredKeys unhappy path should not fulfill promise!")
            }
            XCTAssertTrue($0.requiredKeys.count == 1)
            XCTAssertTrue($0.requiredKeys[0] == "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba")
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_required_keys")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getRequiredKeys promise happy path.
    func testGetRequiredKeysSuccess() {
        testGetRequiredKeys()
    }

    /// Test getRequiredKeys promise unhappy path.
    func testGetRequiredKeysFail() {
        testGetRequiredKeys(unhappy: true)
    }

    /// Test pushTransaction() promise implementation.
    func testPushTransaction(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/push_transaction")) { _ in
            let json = RpcTestConstants.pushTransActionResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "Push Transaction stub"
        let expect = expectation(description: "testPushTransaction")

        // swiftlint:disable:next line_length
        let requestParameters = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"], compression: 0, packedContextFreeData: "", packedTrx: "C62A4F5C1CEF3D6D71BD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")

        firstly {
            (rpcProvider?.pushTransaction(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testPushTransaction unhappy path should not fulfill promise!")
            }
            XCTAssertTrue($0.transactionId == "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a")
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed push_transaction")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test pushTransaction promise happy path.
    func testPushTransactionSuccess() {
        testPushTransaction()
    }

    /// Test pushTransaction promise unhappy path.
    func testPushTransactionFail() {
        testPushTransaction(unhappy: true)
    }

    /// Test pushTransactions promise implementation.
    func testPushTransactions(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/push_transactions")) { _ in
            let json = RpcTestConstants.pushTransactionsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "PushTransactions stub"
        let expect = expectation(description: "testPushTransactions")
        // swiftlint:disable line_length
        let transOne = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_KfFAcqhHTSzabsxGRLpK8KQonqLEXXzMkVQXoj4XGhqNNEzdjSfsGuDVsKFtMPs2NAit8h9LpVDkm2NoAGBaZAUzSmLpVR"], compression: 0, packedContextFreeData: "", packedTrx: "2D324F5CEBFDD0C60CDD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        let transTwo = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_K2mRrB7aknJPquDXJRsVy5xA9wyYrHEw7bkoc8vX4mHrww5UWLV25J3ZHb5kpMnfR3LF3Z2cJk3ydULkXx4vuet7cwYYa8"], compression: 0, packedContextFreeData: "", packedTrx: "8B324F5CA8FE7CC54C3A000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        // swiftlint:enable line_length
        let requestParameters = EosioRpcPushTransactionsRequest(transactions: [transOne, transTwo])

        firstly {
            (rpcProvider?.pushTransactions(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testPushTransactions unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed push_transactions")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test pushTransactions promise happy path.
    func testPushTransactionsSuccess() {
        testPushTransactions()
    }

    /// Test pushTransactions promise unhappy path.
    func testPushTransactionsFail() {
        testPushTransactions(unhappy: true)
    }

    /// Test getBlockHeaderState() promise implementation.
    func testGetBlockHeaderState(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block_header_state")) { _ in
            let json = RpcTestConstants.blockHeaderStateJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetBlockHeaderState stub"
        let expect = expectation(description: "testGetBlockHeaderState")
        let requestParameters = EosioRpcBlockHeaderStateRequest(blockNumOrId: 25260035)

        firstly {
            (rpcProvider?.getBlockHeaderState(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetBlockHeaderState unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_block_header_state")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getBlockHeaderState promise happy path.
    func testGetBlockHeaderStateSuccess() {
        testGetBlockHeaderState()
    }

    /// Test getBlockHeaderState promise unhappy path.
    func testGetBlockHeaderStateFail() {
        testGetBlockHeaderState(unhappy: true)
    }

    /// Test getAbi() promise implementation.
    func testGetAbi(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_abi")) { _ in
            let json = RpcTestConstants.abiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetAbi stub"
        let expect = expectation(description: "testGetAbi")
        let requestParameters = EosioRpcAbiRequest(accountName: "eosio.token")

        firstly {
            (rpcProvider?.getAbi(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetAbi unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_abi")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getAbi promise happy path.
    func testGetAbiSuccess() {
        testGetAbi()
    }

    /// Test getAbi promise unhappy path.
    func testGetAbiFail() {
        testGetAbi(unhappy: true)
    }

    /// Test getAccount() promise implementation.
    func testGetAccount(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_account")) { _ in
            let json = RpcTestConstants.accountJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetAccount stub"
        let expect = expectation(description: "testGetAccount")
        let requestParameters = EosioRpcAccountRequest(accountName: "cryptkeeper")

        firstly {
            (rpcProvider?.getAccount(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetAccount unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_account")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getAccount promise happy path.
    func testGetAccountSuccess() {
        testGetAccount()
    }

    /// Test getAccount promise unhappy path.
    func testGetAccountFail() {
        testGetAccount(unhappy: true)
    }

    /// Test getCurrencyBalance() promise implementation.
    func testGetCurrencyBalance(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_currency_balance")) { _ in
            let json = RpcTestConstants.currencyBalanceJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetCurrencyBalance stub"
        let expect = expectation(description: "testGetCurrencyBalance")
        let requestParameters = EosioRpcCurrencyBalanceRequest(code: "eosio.token", account: "cryptkeeper", symbol: "EOS")

        firstly {
            (rpcProvider?.getCurrencyBalance(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetCurrencyBalance unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_currency_balance")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getCurrencyBalance promise happy path.
    func testGetCurrencyBalanceSuccess() {
        testGetCurrencyBalance()
    }

    /// Test getCurrencyBalance promise unhappy path.
    func testGetCurrencyBalanceFail() {
        testGetCurrencyBalance(unhappy: true)
    }

    /// Test getCurrencyStats() promise implementation.
    func testGetCurrencyStats(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_currency_stats")) { _ in
            let json = RpcTestConstants.currencyStats
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetCurrencyStats stub"
        let expect = expectation(description: "getCurrencyStats")
        let requestParameters = EosioRpcCurrencyStatsRequest(code: "eosio.token", symbol: "EOS")

        firstly {
            (rpcProvider?.getCurrencyStats(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetCurrencyStats unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_currency_stats")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getCurrencyStats promise happy path.
    func testGetCurrencyStatsSuccess() {
        testGetCurrencyStats()
    }

    /// Test getCurrencyStats promise unhappy path.
    func testGetCurrencyStatsFail() {
        testGetCurrencyStats(unhappy: true)
    }

    /// Test getRawCodeAndAbi() promise implementation.
    func testGetRawCodeAndAbi(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_code_and_abi")) { _ in
            let json = RpcTestConstants.rawCodeAndAbiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetRawCodeAndAbis stub"
        let expect = expectation(description: "getRawCodeAndAbi")
        let requestParameters = EosioRpcRawCodeAndAbiRequest(accountName: "eosio.token")

        firstly {
            (rpcProvider?.getRawCodeAndAbi(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetRawCodeAndAbi unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_raw_code_and_abi")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getRawCodeAndAbi promise happy path.
    func testGetRawCodeAndAbiSuccess() {
        testGetRawCodeAndAbi()
    }

    /// Test getRawCodeAndAbi promise unhappy path.
    func testGetRawCodeAndAbiFail() {
        testGetRawCodeAndAbi(unhappy: true)
    }

    /// Test getRawCodeAndAbi() with String signature promise implementation.
    func testGetRawCodeAndAbiWithStringSignature(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_code_and_abi")) { _ in
            let json = RpcTestConstants.rawCodeAndAbiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetRawCodeAndAbis w String stub"
        let expect = expectation(description: "testGetRawCodeAndAbiWithStringSignature")

        firstly {
            (rpcProvider?.getRawCodeAndAbi(.promise, accountName: "eosio.token"))!
        }.done {
            if unhappy {
                XCTFail("testGetRawCodeAndAbiWithStringSignature unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_raw_code_and_abi with string")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getRawCodeAndAbi promise happy path.
    func testGetRawCodeAndAbiWithStringSignatureSuccess() {
        testGetRawCodeAndAbiWithStringSignature()
    }

    /// Test getRawCodeAndAbi promise unhappy path.
    func testGetRawCodeAndAbiWithStringSignatureFail() {
        testGetRawCodeAndAbiWithStringSignature(unhappy: true)
    }

    /// Test getCode() promise implementation.
    func testGetCode(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_code")) { _ in
            let json = RpcTestConstants.codeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetCode stub"
        let expect = expectation(description: "testGetCode")
        let requestParameters = EosioRpcCodeRequest(accountName: "cryptkeeper")

        firstly {
            (rpcProvider?.getCode(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetCode unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_code")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getCode promise happy path.
    func testGetCodeSuccess() {
        testGetCode()
    }

    /// Test getCode promise unhappy path.
    func testGetCodeFail() {
        testGetCode(unhappy: true)
    }

    /// Test getCode() with String signature promise implementation.
    func testGetCodeWithStringSignature(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_code")) { _ in
            let json = RpcTestConstants.codeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetCodeWithStringSignature stub"
        let expect = expectation(description: "testGetCodeWithStringSignature")

        firstly {
            (rpcProvider?.getCode(.promise, accountName: "cryptkeeper"))!
        }.done {
            if unhappy {
                XCTFail("testGetCodeWithStringSignature unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_code with string")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getCode with String promise happy path.
    func testGetCodeWithStringSignatureSuccess() {
        testGetCodeWithStringSignature()
    }

    /// Test getCode with String promise unhappy path.
    func testGetCodeWithStringSignatureFail() {
        testGetCodeWithStringSignature(unhappy: true)
    }

    /// Test getTableRows() promise implementation.
    func testGetTableRows(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_table_rows")) { _ in
            let json = RpcTestConstants.tableRowsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetTableRows stub"
        let expect = expectation(description: "testGetTableRows")
        let requestParameters = EosioRpcTableRowsRequest(scope: "cryptkeeper", code: "eosio.token", table: "accounts")

        firstly {
            (rpcProvider?.getTableRows(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetTableRows unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_table_rows")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getTableRows promise happy path.
    func testGetTableRowsSuccess() {
        testGetTableRows()
    }

    /// Test getTableRows promise unhappy path.
    func testGetTableRowsFail() {
        testGetTableRows(unhappy: true)
    }

    /// Test getTableByScope() promise implementation.
    func testGetTableByScope(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_table_by_scope")) { _ in
            let json = RpcTestConstants.tableScopeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetTableByScope stub"
        let expect = expectation(description: "testGetTableByScope")
        let requestParameters = EosioRpcTableByScopeRequest(code: "eosio.token")

        firstly {
            (rpcProvider?.getTableByScope(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetTableByScope unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_table_by_scope")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getTableByScope promise happy path.
    func testGetTableByScopeSuccess() {
        testGetTableByScope()
    }

    /// Test getTableByScope promise unhappy path.
    func testGetTableByScopeFail() {
        testGetTableByScope(unhappy: true)
    }

    /// Test getProducers promise implementation.
    func testGetProducers(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_producers")) { _ in
            let json = RpcTestConstants.producersJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetProducers stub"
        let expect = expectation(description: "testGetProducers")
        let requestParameters = EosioRpcProducersRequest(limit: 10, lowerBound: "blkproducer2", json: true)

        firstly {
            (rpcProvider?.getProducers(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetProducers unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_producers")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getProducers promise happy path.
    func testGetProducersSuccess() {
        testGetProducers()
    }

    /// Test getProducers promise unhappy path.
    func testGetProducersFail() {
        testGetProducers(unhappy: true)
    }

    /// Test getActions promise implementation.
    func testGetActions(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_actions")) { _ in
            let json = RpcTestConstants.actionsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetAction stub"
        let expect = expectation(description: "testGetActions")
        let requestParameters = EosioRpcHistoryActionsRequest(position: -1, offset: -20, accountName: "cryptkeeper")

        firstly {
            (rpcProvider?.getActions(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetActions unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_actions")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getActions promise happy path.
    func testGetActionsSuccess() {
        testGetActions()
    }

    /// Test getActions promise unhappy path.
    func testGetActionsFail() {
        testGetActions(unhappy: true)
    }

    /// Test getControlledAccounts promise implementation.
    func testGetControlledAccounts(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_controlled_accounts")) { _ in
            let json = RpcTestConstants.controlledAccountsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetControlledAccounts stub"
        let expect = expectation(description: "testGetControlledAccounts")
        let requestParameters = EosioRpcHistoryControlledAccountsRequest(controllingAccount: "cryptkeeper")

        firstly {
            (rpcProvider?.getControlledAccounts(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetControlledAccounts unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_controlled_accounts")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getControlledAccounts promise happy path.
    func testGetControlledAccountsSuccess() {
        testGetControlledAccounts()
    }

    /// Test getControlledAccounts promise unhappy path.
    func testGetControlledAccountsFail() {
        testGetControlledAccounts(unhappy: true)
    }

    /// Test getTransaction promise implementation.
    func testGetTransaction(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_transaction")) { _ in
            let json = RpcTestConstants.transactionJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetTransaction stub"
        let expect = expectation(description: "testGetTransaction")
        let requestParameters = EosioRpcHistoryTransactionRequest(transactionId: "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a", blockNumHint: 21098575)

        firstly {
            (rpcProvider?.getTransaction(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetTransaction unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_transaction")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getTransaction promise happy path.
    func testGetTransactionSuccess() {
        testGetTransaction()
    }

    /// Test getTransaction promise unhappy path.
    func testGetTransactionFail() {
        testGetTransaction(unhappy: true)
    }

    /// Test getKeyAccounts promise implementation.
    func testGetKeyAccounts(unhappy: Bool = false) {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_key_accounts")) { _ in
            let json = RpcTestConstants.keyAccountsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: unhappy ? 500 : 200, headers: nil)
        }).name = "GetKeyAccounts stub"
        let expect = expectation(description: "testGetKeyAccounts")
        let requestParameters = EosioRpcHistoryKeyAccountsRequest(publicKey: "PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG")

        firstly {
            (rpcProvider?.getKeyAccounts(.promise, requestParameters: requestParameters))!
        }.done {
            if unhappy {
                XCTFail("testGetKeyAccounts unhappy path should not fulfill promise!")
            }
            XCTAssertNotNil($0._rawResponse)
        }.catch {
            print($0)
            if unhappy {
                XCTAssertTrue($0.eosioError.errorCode == EosioErrorCode.rpcProviderError)
            } else {
                XCTFail("Failed get_key_accounts")
            }
        }.finally {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 30)
    }

    /// Test getKeyAccounts promise happy path.
    func testGetKeyAccountsSuccess() {
        testGetKeyAccounts()
    }

    /// Test getKeyAccounts promise unhappy path.
    func testGetKeyAccountsFail() {
        testGetKeyAccounts(unhappy: true)
    }
}
