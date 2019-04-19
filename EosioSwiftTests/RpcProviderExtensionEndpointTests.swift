//
//  RpcProviderExtensionEndpointTests.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/15/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift
import OHHTTPStubs

class RpcProviderExtensionEndpointTests: XCTestCase {

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
    /// Test pushTransactions implementation.
    func testPushTransactions() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/push_transactions")) { _ in
            let json = RpcTestConstants.pushTransactionsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "PushTransactions stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testPushTransactions")
        // swiftlint:disable line_length
        let transOne = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_KfFAcqhHTSzabsxGRLpK8KQonqLEXXzMkVQXoj4XGhqNNEzdjSfsGuDVsKFtMPs2NAit8h9LpVDkm2NoAGBaZAUzSmLpVR"], compression: 0, packedContextFreeData: "", packedTrx: "2D324F5CEBFDD0C60CDD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        let transTwo = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_K2mRrB7aknJPquDXJRsVy5xA9wyYrHEw7bkoc8vX4mHrww5UWLV25J3ZHb5kpMnfR3LF3Z2cJk3ydULkXx4vuet7cwYYa8"], compression: 0, packedContextFreeData: "", packedTrx: "8B324F5CA8FE7CC54C3A000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")
        // swiftlint:enable line_length
        let requestParameters = EosioRpcPushTransactionsRequest(transactions: [transOne, transTwo])
        rpcProvider?.pushTransactions(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcPushTransactionsResponse):
                XCTAssertNotNil(eosioRpcPushTransactionsResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed push_transactions")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test testGetBlockHeaderState() implementation.
    func testGetBlockHeaderState() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block_header_state")) { _ in
            let json = RpcTestConstants.blockHeaderStateJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetBlockHeaderState stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetBlockHeaderState")
        let requestParameters = EosioRpcBlockHeaderStateRequest(blockNumOrId: 25260035)
        rpcProvider?.getBlockHeaderState(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcBlockHeaderStateResponse):
                XCTAssertNotNil(eosioRpcBlockHeaderStateResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_block_header_state")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test testGetAbi() implementation.
    func testGetAbi() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_abi")) { _ in
            let json = RpcTestConstants.abiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetAbi stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetAbi")
        let requestParameters = EosioRpcAbiRequest(accountName: "eosio.token")
        rpcProvider?.getAbi(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcAbiResponse):
                XCTAssertNotNil(eosioRpcAbiResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_abi \(String(describing: err.originalError))")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test testGetAccount() implementation.
    func testGetAccount() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_account")) { _ in
            let json = RpcTestConstants.accountJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetAccount stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetAccount")
        let requestParameters = EosioRpcAccountRequest(accountName: "cryptkeeper")
        rpcProvider?.getAccount(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcAccountResponse):
                XCTAssertNotNil(eosioRpcAccountResponse)
                XCTAssert(eosioRpcAccountResponse.accountName == "cryptkeeper")
                XCTAssert(eosioRpcAccountResponse.ramQuota == 13639863)
                XCTAssertNotNil(eosioRpcAccountResponse.totalResources)
                if let dict = eosioRpcAccountResponse.totalResources {
                    if let owner = dict["owner"] as? String {
                        XCTAssert(owner == "cryptkeeper")
                    } else {
                        XCTFail("Should be able to get total_resources owner as String and should equal cryptkeeper.")
                    }
                    if let rambytes = dict["ram_bytes"] as? UInt64 {
                        XCTAssert(rambytes == 13639863)
                    } else {
                        XCTFail("Should be able to get total_resources ram_bytes as UIn64 and should equal 13639863.")
                    }
                } else {
                    XCTFail("Should be able to get total_resources as [String : Any].")
                }
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_account")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test testGetCurrencyBalance() implementation.
    func testGetCurrencyBalance() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_currency_balance")) { _ in
            let json = RpcTestConstants.currencyBalanceJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetCurrencyBalance stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetCurrencyBalance")
        let requestParameters = EosioRpcCurrencyBalanceRequest(code: "eosio.token", account: "cryptkeeper", symbol: "EOS")
        rpcProvider?.getCurrencyBalance(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcCurrencyBalanceResponse):
                XCTAssertNotNil(eosioRpcCurrencyBalanceResponse._rawResponse)
                XCTAssert(eosioRpcCurrencyBalanceResponse.currencyBalance != nil)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_currency_balance")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getCurrencyStats() implementation.
    func testGetCurrencyStats() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_currency_stats")) { _ in
            let json = RpcTestConstants.currencyStats
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetCurrencyStats stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "getCurrencyStats")
        let requestParameters = EosioRpcCurrencyStatsRequest(code: "eosio.token", symbol: "EOS")
        rpcProvider?.getCurrencyStats(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcCurrencyStatsResponse):
                XCTAssertNotNil(eosioRpcCurrencyStatsResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_currency_stats")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getRawCodeAndAbi() implementation.
    func testGetRawCodeAndAbi() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_code_and_abi")) { _ in
            let json = RpcTestConstants.rawCodeAndAbiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetRawCodeAndAbis stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "getRawCodeAndAbi")
        let requestParameters = EosioRpcRawCodeAndAbiRequest(accountName: "eosio.token")
        rpcProvider?.getRawCodeAndAbi(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcRawCodeAndAbiResponse):
                XCTAssertNotNil(eosioRpcRawCodeAndAbiResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_raw_code_and_abi")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getRawCodeAndAbi() with String signature implementation.
    func testGetRawCodeAndAbiWithStringSignature() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_code_and_abi")) { _ in
            let json = RpcTestConstants.rawCodeAndAbiJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetRawCodeAndAbis w String stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetRawCodeAndAbiWithStringSignature")
        rpcProvider?.getRawCodeAndAbi(accountName: "eosio.token" ) { response in
            switch response {
            case .success(let eosioRpcRawCodeAndAbiResponse):
                XCTAssertNotNil(eosioRpcRawCodeAndAbiResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_raw_code_and_abi")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getCode() implementation.
    func testgetCode() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_code")) { _ in
            let json = RpcTestConstants.codeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetCode stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetCode")
        let requestParameters = EosioRpcCodeRequest(accountName: "cryptkeeper")
        rpcProvider?.getCode(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcCodeResponse):
                XCTAssertNotNil(eosioRpcCodeResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_code")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getCode() with String signature implementation.
    func testGetCodeWithStringSignature() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_code")) { _ in
            let json = RpcTestConstants.codeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetCodeWithStringSignature stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetCodeWithStringSignature")
        rpcProvider?.getCode(accountName: "cryptkeeper" ) { response in
            switch response {
            case .success(let eosioRpcCodeResponse):
                XCTAssertNotNil(eosioRpcCodeResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_code")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getTableRows() implementation.
    func testGetTableRows() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_table_rows")) { _ in
            let json = RpcTestConstants.tableRowsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetTableRows stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetTableRows")
        let requestParameters = EosioRpcTableRowsRequest(scope: "cryptkeeper", code: "eosio.token", table: "accounts")
        rpcProvider?.getTableRows(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcTableRowsResponse):
                XCTAssertNotNil(eosioRpcTableRowsResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_table_rows")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getTableByScope() implementation.
    func testGetTableByScope() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_table_by_scope")) { _ in
            let json = RpcTestConstants.tableScopeJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetTableByScope stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetTableByScope")
        let requestParameters = EosioRpcTableByScopeRequest(code: "eosio.token")
        rpcProvider?.getTableByScope(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcTableByScopeResponse):
                XCTAssertNotNil(eosioRpcTableByScopeResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_table_by_scope")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getProducers implementation.
    func testGetProducers() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_producers")) { _ in
            let json = RpcTestConstants.producersJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetProducers stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetProducers")
        let requestParameters = EosioRpcProducersRequest(limit: 10, lowerBound: "blkproducer2", json: true)
        rpcProvider?.getProducers(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcProducersResponse):
                XCTAssertNotNil(eosioRpcProducersResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_producers")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getActions implementation.
    func testGetActions() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_actions")) { _ in
            let json = RpcTestConstants.actionsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetAction stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetActions")
        let requestParameters = EosioRpcHistoryActionsRequest(position: -1, offset: -20, accountName: "cryptkeeper")
        rpcProvider?.getActions(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcActionsResponse):
                XCTAssertNotNil(eosioRpcActionsResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_actions")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getControlledAccounts implementation.
    func testGetControlledAccounts() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_controlled_accounts")) { _ in
            let json = RpcTestConstants.controlledAccountsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetControlledAccounts stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetControlledAccounts")
        let requestParameters = EosioRpcHistoryControlledAccountsRequest(controllingAccount: "cryptkeeper")
        rpcProvider?.getControlledAccounts(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcControlledAccountsResponse):
                XCTAssertNotNil(eosioRpcControlledAccountsResponse._rawResponse)
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_controlled_accounts")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getTransaction implementation.
    func testGetTransaction() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_transaction")) { _ in
            let json = RpcTestConstants.transactionJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetTransaction stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetTransaction")
        let requestParameters = EosioRpcHistoryTransactionRequest(transactionId: "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a", blockNumHint: 21098575)
        rpcProvider?.getTransaction(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcGetTransactionResponse):
                XCTAssert(eosioRpcGetTransactionResponse.id == "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a")
                XCTAssert(eosioRpcGetTransactionResponse.blockNum == 21098575)
                guard let dict = eosioRpcGetTransactionResponse.trx["trx"] as? [String: Any] else {
                    XCTFail("Should find trx.trx dictionary.")
                    return
                }
                if let refBlockNum = dict["ref_block_num"] as? UInt64 {
                    XCTAssert(refBlockNum == 61212)
                } else {
                    XCTFail("Should find trx ref_block_num and it should match.")
                }
                if let signatures = dict["signatures"] as? [String] {
                    XCTAssert(signatures[0] == "SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68")
                } else {
                    XCTFail("Should find trx signatures and it should match.")
                }
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_transaction")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    /// Test getKeyAccounts implementation.
    func testGetKeyAccounts() {
        (stub(condition: isAbsoluteURLString("https://localhost/v1/history/get_key_accounts")) { _ in
            let json = RpcTestConstants.keyAccountsJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "GetKeyAccounts stub"

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = RpcTestConstants.infoResponseJson
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get info stub"

        let expect = expectation(description: "testGetKeyAccounts")
        let requestParameters = EosioRpcHistoryKeyAccountsRequest(publicKey: "PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG")
        rpcProvider?.getKeyAccounts(requestParameters: requestParameters) { response in
            switch response {
            case .success(let eosioRpcKeyAccountsResponse):
                XCTAssertNotNil(eosioRpcKeyAccountsResponse.accountNames)
                XCTAssert(eosioRpcKeyAccountsResponse.accountNames.count == 2)
                XCTAssert(eosioRpcKeyAccountsResponse.accountNames[0] == "cryptkeeper")
            case .failure(let err):
                print(err.description)
                XCTFail("Failed get_key_accounts")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
}
