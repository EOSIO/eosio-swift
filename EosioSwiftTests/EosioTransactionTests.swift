//
//  EosioTransactionTests.swift
//  EosioSwiftTests
//
//  Created by Farid Rahmani on 3/8/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest
@testable import EosioSwift
@testable import PromiseKit

class EosioTransactionTests: XCTestCase {
    var transaction = EosioTransaction()
    var rpcProvider: RPCProviderMock!
    override func setUp() {
        transaction = EosioTransaction()
        let url = URL(string: "http://example.com")
        rpcProvider = RPCProviderMock(endpoint: url!)
        rpcProvider.getInfoCalled = false
        rpcProvider.getInfoReturnsfailure = false
        rpcProvider.getRequiredKeysReturnsfailure = false
        transaction.rpcProvider = rpcProvider
        transaction.serializationProvider = SerializationProviderMock()
        transaction.signatureProvider = SignatureProviderMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_prepare_shouldSetExpirationDateCorrectly() {
        transaction.prepare { (_) in
            XCTAssert(self.transaction.expiration >= Date(timeIntervalSince1970: 0))
        }
    }

    func test_prepare_withRPCProviderNotSet_shouldReturnError() {
        transaction.rpcProvider = nil
        transaction.prepare { (result) in
            if case .success = result {
                XCTFail("Succeeded to prepare transaction despite rpc provider not being set")
            }
        }
    }

    func test_prepare_shouldCallGetInfoFunctionOnRPCProvider() {
        transaction.prepare { (_) in
            XCTAssertTrue(self.rpcProvider.getInfoCalled)
        }

    }

    func test_prepare_whenGetInfoMethodOfRPCProviderReturnsSuccess_shouldReturnSuccess() {
        transaction.prepare { (result) in
            guard case .success = result else {
                XCTFail("Succeeded to prepare get_info transaction despite being malformed")
                return
            }
        }

    }

    func test_prepare_whenGetInfoMethodOfRPCProviderReturnsFailure_shouldReturnFailure() {
        rpcProvider.getInfoReturnsfailure = true
        transaction.prepare { (result) in
            guard case .failure = result else {
                XCTFail("Succeeded to prepare get_info transaction despite being malformed")
                return
            }
        }
    }

    func test_prepare_shouldSetChainIdProperty() {
        transaction.prepare { (_) in
            XCTAssertEqual(self.transaction.chainId, self.rpcProvider.rpcInfo.chainId)
        }
    }

    func test_prepare_shouldCallGetBlockFunctionOfRPCProvider() {
        transaction.prepare { (_) in
            XCTAssertTrue(self.rpcProvider.getBlockCalled)
        }
    }

    func test_prepare_shouldCallGetBlockFunctionOfRPCProviderWithCorrectBlockNumber() {
        var blockNum = rpcProvider.rpcInfo.headBlockNum.value - UInt64(transaction.config.blocksBehind)
        if blockNum <= 0 {
            blockNum = 1
        }

        transaction.prepare { (_) in
            XCTAssertEqual(self.rpcProvider.blockNumberRequested, String(blockNum))
        }

    }

    func test_getBlockAndSetTapos_shouldCallGetBlockFunctionOfRPCProvider() {
        transaction.getBlockAndSetTapos(blockNum: 324) { (_) in
            XCTAssertTrue(self.rpcProvider.getBlockCalled)
        }
    }

    func test_getBlockAndSetTapos_shouldCallGetBlockFunctionOfRPCProviderWithCorrectBlockNumber() {
        let blockNumber: UInt64 = 234
        transaction.getBlockAndSetTapos(blockNum: blockNumber) { (_) in
            XCTAssertEqual(self.rpcProvider.blockNumberRequested, String(blockNumber))
        }
    }

    func test_getBlockAndSetTapos_shouldSetRefBlockNum() {
        transaction.getBlockAndSetTapos(blockNum: 345) { (_) in
            XCTAssertEqual(self.transaction.refBlockNum, UInt16(self.rpcProvider.block.blockNum.value & 0xffff))
        }
    }

    func test_getBlockAndSetTapos_shouldSetRefBlockPrefix() {
        transaction.getBlockAndSetTapos(blockNum: 345) { (_) in
            XCTAssertEqual(self.transaction.refBlockPrefix, self.rpcProvider.block.refBlockPrefix.value)
        }
    }

    func test_getBlockAndSetTapos_whenRefBlockPrefixAndRefBlockNumAreNotZero_shouldNotCallGetBlockOnRPCProvider() {
        transaction.refBlockNum = 9879
        transaction.refBlockPrefix = 213
        transaction.getBlockAndSetTapos(blockNum: 879) { (_) in
            XCTAssertFalse(self.rpcProvider.getBlockCalled)
        }

    }

    func test_getBlockAndSetTapos_whenGetBlockMethodOfRPCProviderReturnsFailure_shouldReturnFailure() {
        rpcProvider.getBlockReturnsFailure = true
        transaction.getBlockAndSetTapos(blockNum: 8678) { (result) in
            guard case .failure = result else {
                XCTFail("Failed get_block")
                return
            }
        }
    }

    func test_sign_publicKeys_shouldSucceed() {
        transaction.sign(publicKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]) { (_) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }

    func test_sign_publicKeys_shouldFail() {
        transaction.sign(publicKeys: ["PUB_K1_badkey"]) { (result) in
            guard case .failure = result else {
                return XCTFail("Succeeded to sign transaction with K1 public key despite having a bad key")
            }
        }
    }

    func test_sign_availableKeys_shouldSucceed() {
        transaction.sign(availableKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]) { (_) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }

    func test_sign_availableKeys_shouldFail() {
        rpcProvider.getRequiredKeysReturnsfailure = true
        transaction.sign(availableKeys: ["PUB_K1_badkey"]) { (result) in
            guard case .failure = result else {
                return XCTFail("Succeeded to sign transaction despite having a bad key")
            }
        }
    }

    func test_sign_shouldSucceed() {
        transaction.sign { (_) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }

    func test_signAndbroadcast_shouldSucceed() {
        transaction.signAndBroadcast { (_) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
            XCTAssertEqual(self.transaction.transactionId, "mocktransactionid")
        }
    }
    // MARK: - EosioTransaction extension tests using Promises
    func test_signAndbroadcastPromise_shouldSucceed() {
        let expect = expectation(description: "signAndbroadcastPromise_shouldSucceed")
        let promise = self.transaction.signAndBroadcast(.promise)
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_signAndbroadcastPromise_shouldFail() {
        let expect = expectation(description: "test_signAndbroadcastPromise_shouldFail")
        let signatureProvider = SignatureProviderMock()
        signatureProvider.getAvailableKeysShouldReturnFailure = true
        self.transaction.signatureProvider = signatureProvider
        let promise = self.transaction.signAndBroadcast(.promise)
        promise.done { (value) in
            print(value)
            XCTFail("Should have throw error!")
            }.catch { (error) in
                print(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_signPromise_shouldSucceed() {
        let expect = expectation(description: "signPromise_shouldSucceed")
        let promise = self.transaction.sign(.promise)
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_signPromise_shouldFail() {
        let expect = expectation(description: "signPromise_shouldFail")
        self.transaction.signatureProvider = nil
        self.transaction.sign(.promise).done { (value) in
            print(value)
            XCTFail("Should have throw error!")
            }.catch { _ in
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_broadcastPromise_shouldSucceed() {
        let expect = expectation(description: "broadcastPromise_shouldSucceed")
        firstly {
            self.transaction.sign(.promise)
            }.then { (value: Bool) -> Promise<Bool> in
                print(value)
                return self.transaction.broadcast(.promise)
            }.done { (value) in
                print(value)
                expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_broadcastPromise_shouldFail() {
        let expect = expectation(description: "test_broadcastPromise_shouldFail")
        //broadcast should fail as transaction needs to be signed first
        firstly {
            self.transaction.broadcast(.promise)
            }.done { (value) in
                print(value)
                XCTFail("Should have throw error!")
            }.catch { _ in
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_signWithAvailableKeys_shouldSucceed() {
        let expect = expectation(description: "test_signWithAvailableKeys_shouldSucceed")
        let promise = self.transaction.sign(.promise, availableKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"])
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_signWithAvailableKeys_shouldFail() {
        let expect = expectation(description: "test_signWithAvailableKeys_shouldFail")
        rpcProvider.getRequiredKeysReturnsfailure = true
        let promise = self.transaction.sign(.promise, availableKeys: ["bad_key"])
        promise.done { (value) in
            print(value)
            XCTFail("Should have throw error!)")
            }.catch { (error) in
                print(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_signWithPublicKeys_shouldSucceed() {
        let expect = expectation(description: "test_signWithPublicKeys_shouldSucceed")
        let promise = self.transaction.sign(.promise, publicKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"])
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_signWithPublicKeys_shouldFail() {
        let expect = expectation(description: "test_signWithPublicKeys_shouldFail")
        let promise = self.transaction.sign(.promise, publicKeys: ["bad_key"])
        promise.done { (value) in
            print(value)
            XCTFail("Should have throw error!)")
            }.catch { (error) in
                print(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_serializeTransaction_shouldSucceed() {
        let expect = expectation(description: "test_serializeTransaction_shouldSucceed")
        let promise = self.transaction.serializeTransaction(.promise)
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_serializeTransaction_shouldFail() {
        let expect = expectation(description: "test_serializeTransaction_shouldFail")
        let serializationProvider = SerializationProviderMock()
        serializationProvider.serializeTransactionReturnsfailure = true
        self.transaction.serializationProvider = serializationProvider
        let promise = self.transaction.serializeTransaction(.promise)
        promise.done { (value) in
            print(value)
            XCTFail("Should have throw error!)")
            }.catch { (error) in
                print(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func test_prepare_shouldSucceed() {
        let expect = expectation(description: "test_prepare_shouldSucceed")
        let promise = self.transaction.prepare(.promise)
        promise.done { (value) in
            print(value)
            expect.fulfill()
            }.catch { (error) in
                XCTFail("Should not have throw error: \(error.localizedDescription)")
        }
        waitForExpectations(timeout: 10)
    }
    func test_prepare_shouldFail() {
        let expect = expectation(description: "test_prepare_shouldFail")
        rpcProvider.getInfoReturnsfailure = true
        let promise = self.transaction.prepare(.promise)
        promise.done { (value) in
            print(value)
            XCTFail("Should have throw error!)")
            }.catch { (error) in
                print(error)
                expect.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

    func test_add_action_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        transaction.add(action: action)
        XCTAssertEqual(transaction.actions.count, 1)
        XCTAssertEqual(transaction.actions[0].data["from"] as? String, "todd")
    }

    func test_add_actions_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        guard let action2 = try? makeTransferAction(from: EosioName("brandon"), to: EosioName("todd")) else { return XCTFail("Invalid Action") }
        transaction.add(actions: [action1, action2])
        XCTAssertEqual(transaction.actions.count, 2)
        XCTAssertEqual(transaction.actions[0].data["from"] as? String, "todd")
        XCTAssertEqual(transaction.actions[1].data["from"] as? String, "brandon")
    }

    func test_add_action_at_index_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        guard let action2 = try? makeTransferAction(from: EosioName("brandon"), to: EosioName("todd")) else { return XCTFail("Invalid Action") }
        transaction.add(action: action1)
        transaction.add(action: action2, at: 0)
        XCTAssertEqual(transaction.actions.count, 2)
        XCTAssertEqual(transaction.actions[0].data["from"] as? String, "brandon")
    }

    func test_add_context_free_action_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        transaction.add(contextFreeAction: action)
        XCTAssertEqual(transaction.contextFreeActions.count, 1)
        XCTAssertEqual(transaction.contextFreeActions[0].data["from"] as? String, "todd")
    }

    func test_add_context_free_actions_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        guard let action2 = try? makeTransferAction(from: EosioName("brandon"), to: EosioName("todd")) else { return XCTFail("Invalid Action") }
        transaction.add(contextFreeActions: [action1, action2])
        XCTAssertEqual(transaction.contextFreeActions.count, 2)
        XCTAssertEqual(transaction.contextFreeActions[0].data["from"] as? String, "todd")
        XCTAssertEqual(transaction.contextFreeActions[1].data["from"] as? String, "brandon")
    }

    func test_add_context_free_action_at_index_shouldSucceed() {
        let transaction = EosioTransaction()
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else { return XCTFail("Invalid Action") }
        guard let action2 = try? makeTransferAction(from: EosioName("brandon"), to: EosioName("todd")) else { return XCTFail("Invalid Action") }
        transaction.add(contextFreeAction: action1)
        transaction.add(contextFreeAction: action2, at: 0)
        XCTAssertEqual(transaction.contextFreeActions.count, 2)
        XCTAssertEqual(transaction.contextFreeActions[0].data["from"] as? String, "brandon")
    }
}

class RPCProviderMock: EosioRpcProviderProtocol {

    var url: URL
    required init(endpoint: URL) {
        self.url = endpoint
    }

    var getInfoCalled = false
    var getInfoReturnsfailure = false
    var getRequiredKeysReturnsfailure = false
    var getRawAbiReturnsfailure = false
    let rpcInfo = EosioRpcInfoResponse(
        serverVersion: "verion",
        chainId: "chainId",
        headBlockNum: EosioUInt64.uint64(234),
        lastIrreversibleBlockNum: EosioUInt64.uint64(2342),
        lastIrreversibleBlockId: "lastIrversible",
        headBlockId: "headBlockId",
        headBlockTime: "2009-01-03T18:15:05.000",
        headBlockProducer: "producer",
        virtualBlockCpuLimit: EosioUInt64.uint64(234),
        virtualBlockNetLimit: EosioUInt64.uint64(234),
        blockCpuLimit: EosioUInt64.uint64(334),
        blockNetLimit: EosioUInt64.uint64(897),
        serverVersionString: "server version")

    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getInfoCalled = true
        if getInfoReturnsfailure {
            let error = EosioError(.getInfoError, reason: "Failed for test propose")
            completion(.failure(error))

        } else {
            completion(.success(rpcInfo))
        }
    }

    var getBlockCalled = false
    var getBlockReturnsFailure = false
    var blockNumberRequested: String!
    let block = EosioRpcBlockResponse(
        timestamp: "timestatmp",
        producer: "producer",
        confirmed: 8,
        previous: "prev",
        transactionMroot: "root",
        actionMroot: "action",
        scheduleVersion: 9,
        newProducers: nil,
        headerExtensions: ["extension"],
        producerSignature: "signature",
        id: "klj",
        blockNum: EosioUInt64.uint64(89),
        refBlockPrefix: EosioUInt64.uint64(0980)
    )

    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getBlockCalled = true
        blockNumberRequested = requestParameters.blockNumberOrId
        let result: EosioResult<EosioRpcBlockResponseProtocol, EosioError>
        if getBlockReturnsFailure {
            result = EosioResult.failure(EosioError(.getBlockError, reason: "Some reason"))
        } else {
            result = EosioResult.success(block)
        }

        completion(result)

    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping
        (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        var result: EosioResult<EosioRpcRawAbiResponseProtocol, EosioError> =
            EosioResult.failure(EosioError(.rpcProviderError, reason: "Abi response conversion error."))
        if getRawAbiReturnsfailure {
            result = EosioResult.failure(EosioError(.rpcProviderError, reason: "No abis found."))
        } else {
            let decoder = JSONDecoder()
            if let rawAbiResponse = RpcTestConstants.createRawApiResponseJson(account: requestParameters.accountName),
                let resp = try? decoder.decode(EosioRpcRawAbiResponse.self, from: rawAbiResponse.data(using: .utf8)!) {
                    result = EosioResult.success(resp)
            }
        }
        completion(result)
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        let result: EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>
        if getRequiredKeysReturnsfailure {
            result = EosioResult.failure(EosioError(.rpcProviderError, reason: "No required keys found."))
        } else {
            let requredKeysResponse = EosioRpcRequiredKeysResponse(requiredKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"])
            result = EosioResult.success(requredKeysResponse)
        }
        completion(result)
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        let pushTransactionResponse = EosioRpcTransactionResponse(transactionId: "mocktransactionid")
        let result: EosioResult<EosioRpcTransactionResponseProtocol, EosioError>  = EosioResult.success(pushTransactionResponse)
        completion(result)
    }
}

final class SerializationProviderMock: EosioSerializationProviderProtocol {
    var error: String?
    var serializeTransactionReturnsfailure = false

    func serializeAbi(json: String) throws -> String {
        return ""
    }

    func serializeTransaction(json: String) throws -> String {
        if serializeTransactionReturnsfailure {
            throw EosioError(EosioErrorCode.serializeError, reason: "Test should have expected this failure.")
        } else {
           return ""
        }
    }

    func serialize(contract: String?, name: String, type: String?, json: String, abi: String) throws -> String {
        return ""
    }

    func deserializeAbi(hex: String) throws -> String {
        return ""
    }

    func deserializeTransaction(hex: String) throws -> String {
        return ""
    }

    func deserialize(contract: String?, name: String, type: String?, hex: String, abi: String) throws -> String {
        return ""
    }

}

class AbiProviderMockup: EosioAbiProviderProtocol {
    var getAbisCalled = false
    func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName: Data], EosioError>) -> Void) {
        getAbisCalled = true
    }
    var getAbiCalled = false
    func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data, EosioError>) -> Void) {
        getAbiCalled = true
    }

}

class SignatureProviderMock: EosioSignatureProviderProtocol {

    var getAvailableKeysShouldReturnFailure = false

    func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var transactionSignatureResponse = EosioTransactionSignatureResponse()

        if request.publicKeys.contains("PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y") {
            var signedTransaction = EosioTransactionSignatureResponse.SignedTransaction()
            signedTransaction.signatures = ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"]
            transactionSignatureResponse.signedTransaction = signedTransaction
        } else {
            transactionSignatureResponse.signedTransaction = nil
            transactionSignatureResponse.error = EosioError(EosioErrorCode.signatureProviderError, reason: "Key not available")
        }

        completion(transactionSignatureResponse)
    }

    func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void) {
        var availableKeysResponse = EosioAvailableKeysResponse()

        if getAvailableKeysShouldReturnFailure == true {
            availableKeysResponse.error = EosioError(EosioErrorCode.signatureProviderError, reason: "Expected error for testing.")

        } else {
            availableKeysResponse.keys = ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]
        }
        completion(availableKeysResponse)
    }
}

struct Transfer: Codable {
    var from: EosioName
    var to: EosioName // swiftlint:disable:this identifier_name
    var quantity: String
    var memo: String
}

func makeTransferAction(from: EosioName, to: EosioName) throws -> EosioTransaction.Action { // swiftlint:disable:this identifier_name

    let action = try EosioTransaction.Action(
        account: EosioName("eosio.token"),
        name: EosioName("transfer"),
        authorization: [EosioTransaction.Action.Authorization(
            actor: from,
            permission: EosioName("active"))
        ],
        data: Transfer(
            from: from,
            to: to,
            quantity: "42.0000 SYS",
            memo: "Grasshopper Rocks")
    )
    return action
}
