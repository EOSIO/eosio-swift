//
//  EosioError.swift
//  EosioSwift
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public enum EosioErrorCode : String, Codable {
    
    case eosioTransactionError = "Error was encountered while preparing the Transaction."
    case rpcProviderError = "Error was was encountered in RpcProvider."
    case getInfoError = "Error was returned by getInfo() method."
    case getBlockError = "Error was encountered from getBlock() method of RPCProvider."
    case getRequiredKeysError = "Error was returned by getRequiredKeys() method."
    case getRawAbiError = "Error was returned by getRawAbi() method."
    case pushTransactionError = "Error was encountered while pushing the transaction."
    case signatureProviderError = "Error was was encountered in SignatureProvider"
    case getAvailableKeysError = "Error was returned by getAvailableKeys() method."
    case signTransactionError = "Error was encountered while signing the transaction."
    case abiProviderError = "Error was was encountered in AbiProviderError."
    case getAbiError = "Error was returned by getAbi() method."
    case serializationProviderError = "Error was was encountered in SerializationProvider."
    case serializeError = "Error was encountered while serializing the transaction."
    case deserializeError = "Error was encountered while deserializing transaction."
    
    //non provider errors (added as these are encoundered in Eosio Extensions and Foundation
    case eosioNameError = "Error was encountered in EosioName."

    //general catch all
    case unexpectedError = "UnexpectedError"
}

open class EosioError: Error, CustomStringConvertible, Codable {
    
    public var errorCode: EosioErrorCode
    public var reason: String
    public var originalError: NSError?
    
    enum CodingKeys: String, CodingKey {
        case errorCode
        case reason
    }
    /**
        Returns a JSON string representation of the error object.
    */
    var errorAsJsonString: String {
        let jsonDict = [
            "errorType" : "EosioError",
            "errorInfo" : [
                "errorCode": self.errorCode.rawValue,
                "reason": self.reason
            ]
            ] as [String : Any]
        
        if JSONSerialization.isValidJSONObject(jsonDict), let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted), let jsonString = String(data: data, encoding: .utf8) {
            
            return jsonString
            
        }
        
        return "{}"

    }
    
    public var description: String {
        return self.localizedDescription
    }
    
    public init (_ errorCode: EosioErrorCode, reason: String, originalError: NSError? = nil) {
        self.errorCode = errorCode
        self.reason = reason
        self.originalError = originalError
    }
}

extension EosioError: LocalizedError {
    
    public var errorDescription: String? {
        return "\(self.errorCode.rawValue): \(self.reason)"
        
    }
}

public extension Error {
    
    public var eosioError: EosioError {
        
        if let eosioError = self as? EosioError {
            return eosioError
        }
        
        return EosioError(EosioErrorCode.unexpectedError, reason: self.localizedDescription)
    }
    
}
    
    
    
    

