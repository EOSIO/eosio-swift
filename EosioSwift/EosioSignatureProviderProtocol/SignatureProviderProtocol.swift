//
//  SignatureProviderProtocol.swift
//
//  Created by Todd Bowden on 7/15/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation
import EosioSwiftFoundation


public struct SignatureProviderTransaction: Codable {
    public var signatures = [String]()
    public var compression = 0
    public var packedContextFreeData = ""
    public var packedTrx = ""
    
    public init() { }
}


public struct TransactionSignatureRequest: Codable {
    public var transaction = SignatureProviderTransaction()
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


public struct TransactionSignatureResponse: Codable {
    public var signedTransaction: SignatureProviderTransaction?
    public var error: EosioError?
    
    public init() { }
    
    public init(error: EosioError) {
        self.error = error
    }
    
    public init(signedTransaction: SignatureProviderTransaction) {
        self.signedTransaction = signedTransaction
    }
}


public struct AvailableKeysResponse: Codable {
    public var keys: [String]?
    public var error: EosioError?
    
    public init() { }
}


public protocol SignatureProviderProtocol {
    
    // Sign transaction
    func signTransaction(request: TransactionSignatureRequest, completion: @escaping (TransactionSignatureResponse)->Void)
    
    // Get available keys
    func getAvailableKeys(completion: @escaping (AvailableKeysResponse)->Void)
    
}


