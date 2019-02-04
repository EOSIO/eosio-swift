//
//  SignatureProviderProtocol.swift
//
//  Created by Todd Bowden on 7/15/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation

// TODO (This struct will be eventually replaced by EosioError)
public struct SignatureProviderError: Error, Codable {
    public var errorCode: String = "signatureProviderError"
    public var reason: String
    public var contextualInfo: String = ""
    public lazy var originalError: NSError? = nil
    public lazy var isReturnable = true
    
    public var localizedDescription: String {
        return errorCode + ": " + reason
    }
    public init(_ errorCode: String? = nil, reason: String, context: String = "", originalError: NSError? = nil, isReturnable: Bool = true) {
        if let errorCode = errorCode {
            self.errorCode = errorCode
        }
        self.reason = reason
        self.contextualInfo = context
        self.originalError = originalError
        self.isReturnable = true
    }
}


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
    public var error: SignatureProviderError?
    
    public init() { }
    
    public init(error: SignatureProviderError) {
        self.error = error
    }
    
    public init(signedTransaction: SignatureProviderTransaction) {
        self.signedTransaction = signedTransaction
    }
}


public struct AvailableKeysResponse: Codable {
    public var keys: [String]?
    public var error: SignatureProviderError?
    
    public init() { }
}


public protocol SignatureProviderProtocol {
    
    // Sign transaction
    func signTransaction(request: TransactionSignatureRequest, completion: @escaping (TransactionSignatureResponse)->Void)
    
    // Get available keys
    func getAvailableKeys(completion: @escaping (AvailableKeysResponse)->Void)
    
}


