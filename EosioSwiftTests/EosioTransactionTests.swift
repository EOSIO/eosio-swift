//
//  EosioTransactionTests.swift
//  EosioSwiftTests
//
//  Created by Farid Rahmani on 3/8/19.
//  Copyright © 2018-2019 block.one.
//

import XCTest
@testable import EosioSwift

class EosioTransactionTests: XCTestCase {
    var transaction:EosioTransaction!
    var rpcProvider = RPCProviderMock(endpoints: [EosioEndpoint("http://example.com")!], failoverRetries: 4)
    
    override func setUp() {
        transaction = EosioTransaction()
        transaction.rpcProvider = rpcProvider
        transaction.serializationProvider = SerializationProviderMock()
        transaction.signatureProvider = SignatureProviderMock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func test_prepare_shouldSetExpirationDateCorrectly() {
        transaction.prepare { (result) in
            XCTAssert(self.transaction.expiration >= Date(timeIntervalSince1970: 0))
        }
    }
    
    func test_prepare_withRPCProviderNotSet_shouldReturnError() {
        transaction.rpcProvider = nil
        transaction.prepare { (result) in
            if case .success = result{
                XCTFail()
            }
        }
    }
    
    func test_prepare_shouldCallGetInfoFunctionOnRPCProvider() {
        transaction.prepare { (result) in
            XCTAssertTrue(self.rpcProvider.getInfoCalled)
        }
        
    }
    
    func test_prepare_whenGetInfoMethodOfRPCProviderReturnsSuccess_shouldReturnSuccess() {
        transaction.prepare { (result) in
            guard case .success = result else{
                XCTFail()
                return
            }
        }
        
    }
    
    func test_prepare_whenGetInfoMethodOfRPCProviderReturnsFailure_shouldReturnFailure() {
        rpcProvider.getInfoReturnsfailure = true
        transaction.prepare { (result) in
            guard case .failure = result else{
                XCTFail()
                return
            }
        }
    }
    
    func test_prepare_shouldSetChainIdProperty() {
        transaction.prepare { (result) in
            XCTAssertEqual(self.transaction.chainId, self.rpcProvider.rpcInfo.chainId)
        }
    }
    
    func test_prepare_shouldCallGetBlockFunctionOfRPCProvider() {
        transaction.prepare { (result) in
            XCTAssertTrue(self.rpcProvider.getBlockCalled)
        }
    }
    
    func test_prepare_shouldCallGetBlockFunctionOfRPCProviderWithCorrectBlockNumber() {
        var blockNum = rpcProvider.rpcInfo.headBlockNum - UInt64(transaction.config.blocksBehind)
        if blockNum <= 0 {
            blockNum = 1
        }
        
        transaction.prepare { (result) in
            XCTAssertEqual(self.rpcProvider.blockNumberRequested, blockNum)
        }
        
        
    }
    
    func test_getBlockAndSetTapos_shouldCallGetBlockFunctionOfRPCProvider() {
        transaction.getBlockAndSetTapos(blockNum: 324) { (result) in
            XCTAssertTrue(self.rpcProvider.getBlockCalled)
        }
    }
    
    func test_getBlockAndSetTapos_shouldCallGetBlockFunctionOfRPCProviderWithCorrectBlockNumber() {
        let blockNumber:UInt64 = 234
        transaction.getBlockAndSetTapos(blockNum: blockNumber) { (result) in
            XCTAssertEqual(self.rpcProvider.blockNumberRequested, blockNumber)
        }
    }
    
    func test_getBlockAndSetTapos_shouldSetRefBlockNum() {
        transaction.getBlockAndSetTapos(blockNum: 345) { (result) in
            XCTAssertEqual(self.transaction.refBlockNum, UInt16(self.rpcProvider.block.blockNum & 0xffff))
        }
    }
    
    func test_getBlockAndSetTapos_shouldSetRefBlockPrefix() {
        transaction.getBlockAndSetTapos(blockNum: 345) { (result) in
            XCTAssertEqual(self.transaction.refBlockPrefix, self.rpcProvider.block.refBlockPrefix)
        }
    }
    
    func test_getBlockAndSetTapos_whenRefBlockPrefixAndRefBlockNumAreNotZero_shouldNotCallGetBlockOnRPCProvider() {
        transaction.refBlockNum = 9879
        transaction.refBlockPrefix = 213
        transaction.getBlockAndSetTapos(blockNum: 879) { (result) in
            XCTAssertFalse(self.rpcProvider.getBlockCalled)
        }
        
    }
    
    func test_getBlockAndSetTapos_whenGetBlockMethodOfRPCProviderReturnsFailure_shouldReturnFailure() {
        rpcProvider.getBlockReturnsFailure = true
        transaction.getBlockAndSetTapos(blockNum: 8678) { (result) in
            guard case .failure = result else{
                XCTFail()
                return
            }
        }
    }
    
    
    func test_sign_publicKeys_shouldSucceed() {
        transaction.sign(publicKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]) { (result) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }
    
    func test_sign_publicKeys_shouldFail() {
        transaction.sign(publicKeys: ["PUB_K1_badkey"]) { (result) in
            guard case .failure = result else {
                return XCTFail()
            }
        }
    }
    
    func test_sign_availableKeys_shouldSucceed() {
        transaction.sign(availableKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]) { (result) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }
    
    func test_sign_availableKeys_shouldFail() {
        transaction.sign(availableKeys: ["PUB_K1_badkey"]) { (result) in
            guard case .failure = result else {
                return XCTFail()
            }
        }
    }
    
    func test_sign_shouldSucceed() {
        transaction.sign() { (result) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }
    
    func test_signAndbroadcast_shouldSucceed() {
        transaction.signAndBroadcast { (result) in
            XCTAssertEqual(self.transaction.signatures, ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
            XCTAssertEqual(self.transaction.transactionId, "mocktransactionid")
        }
    }
    
}


class RPCProviderMock: EosioRpcProviderProtocol {

    
    var endpoints: [EosioEndpoint]
    
    var failoverRetries: Int
    
    var primaryEndpoint: EosioEndpoint = EosioEndpoint("https://example.com")!
    
    required init(endpoints: [EosioEndpoint], failoverRetries: Int) {
        self.endpoints = endpoints
        self.failoverRetries = failoverRetries
    }
    
    func rpcRequest(request: URLRequest, completion: @escaping (EosioResult<EosioResponse, EosioError>) -> Void) {
        
        
    }
    
    var getInfoCalled = false
    var getInfoReturnsfailure = false
    let rpcInfo = EosioRpcInfoResponse(
        serverVersion: "verion",
        chainId: "chainId",
        headBlockNum: 234,
        lastIrreversibleBlockNum: 2342,
        lastIrreversibleBlockId: "lastIrversible",
        headBlockId: "headBlockId",
        headBlockTime: "2009-01-03T18:15:05.000",
        headBlockProducer: "producer",
        virtualBlockCpuLimit: 234,
        virtualBlockNetLimit: 234,
        blockCpuLimit: 334,
        blockNetLimit: 897,
        serverVersionString: "server version")
    
    func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getInfoCalled = true
        if getInfoReturnsfailure{
            let error = EosioError(.getInfoError, reason: "Failed for test propose")
            completion(.failure(error))
            
            
        }else{
            completion(.success(rpcInfo))
        }
    }
    
    var getBlockCalled = false
    var getBlockReturnsFailure = false
    var blockNumberRequested:UInt64!
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
        blockNum: 89,
        refBlockPrefix: 0980
    )
    
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getBlockCalled = true
        blockNumberRequested = requestParameters.blockNumOrId
        let result:EosioResult<EosioRpcBlockResponseProtocol, EosioError> = getBlockReturnsFailure == false ? EosioResult.success(block) : EosioResult.failure(EosioError(.getBlockError, reason: "Some reason"))
        completion(result)
        
    }
    
     public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        
    }


    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        
    }
}

final class SerializationProviderMock: EosioSerializationProviderProtocol {
    var error: String?
  
    func serializeAbi(json: String) throws -> String {
        return ""
    }
    
    func serializeTransaction(json: String) throws -> String {
        return ""
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

class AbiProviderMockup:EosioAbiProviderProtocol{
    var getAbisCalled = false
    func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName : Data], EosioError>) -> Void) {
        getAbisCalled = true
    }
    var getAbiCalled = false
    func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data, EosioError>) -> Void) {
        getAbiCalled = true
    }
    
    
}


class SignatureProviderMock: EosioSignatureProviderProtocol {
    
    func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var transactionSignatureResponse = EosioTransactionSignatureResponse()
        
        if request.publicKeys.contains("PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y") {
            var signedTransaction = EosioTransactionSignatureResponse.SignedTransaction()
            signedTransaction.signatures = ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"]
            transactionSignatureResponse.signedTransaction = signedTransaction
        } else {
            transactionSignatureResponse.error = EosioError(EosioErrorCode.signatureProviderError, reason: "Key not available")
        }

        completion(transactionSignatureResponse)
    }

    
    func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void) {
        var availableKeysResponse = EosioAvailableKeysResponse()
        availableKeysResponse.keys = ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]
        completion(availableKeysResponse)
    }
    
    
}
