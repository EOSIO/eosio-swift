//
//  EosioSignatureProviderProtocol.swift
//  EosioSwift

//  Created by Todd Bowden on 7/15/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation



public struct EosioTransactionSignatureRequest: Codable {
    public var serializedTransaction = Data()
    public var chainId = ""
    public var publicKeys = [String]()
    public var abis = [BinaryAbi]()
    public var isModificationAllowed = true
    
    public struct BinaryAbi: Codable {
        public var accountName = ""
        public var abi = ""
        public init() { }
    }
    
    public init() { }
}


public struct EosioTransactionSignatureResponse: Codable {
    public var signedTransaction: SignedTransaction?
    public var error: EosioError?
    
    public struct SignedTransaction: Codable {
        public var serializedTransaction = Data()
        public var signatures = [String]()
        public init() { }
    }
    
    public init() { }
    
    public init(error: EosioError) {
        self.error = error
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


