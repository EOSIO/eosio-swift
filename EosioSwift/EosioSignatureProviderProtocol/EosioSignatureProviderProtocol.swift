//
//  EosioSignatureProviderProtocol.swift
//
//  Created by Todd Bowden on 7/15/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation




public struct EosioTransactionSignatureRequest: Codable {
    public var transaction = EosioTransactionRequest()
    public var chainId = ""
    public var endpoints: [String]?
    public var publicKeys: [String]?
    public var abis = [BinaryAbi]()
    
    public struct BinaryAbi: Codable {
        public var accountName = ""
        public var abi = ""
        public init() { }
    }
    
    public init() { }
}


public struct EosioTransactionSignatureResponse: Codable {
    public var signedTransaction: EosioTransactionRequest?
    public var error: EosioError?
    
    public init() { }
    
    public init(error: EosioError) {
        self.error = error
    }
    
    public init(signedTransaction: EosioTransactionRequest) {
        self.signedTransaction = signedTransaction
    }
}


public struct EosioAvailableKeysResponse: Codable {
    public var keys: [String]?
    public var error: EosioError?
    
    public init() { }
}


public protocol EosioSignatureProviderProtocol {
    
    // Sign transaction
    func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse)->Void)
    
    // Get available keys
    func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse)->Void)
    
}


