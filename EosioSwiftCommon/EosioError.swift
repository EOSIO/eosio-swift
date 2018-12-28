//
//  EosioError.swift
//  EosioVault
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation


public enum EosioErrorCode : String {
    
    case biometricsDisabled = "biometricsDisabled"
    case keychainError = "keychainError"
    case manifestError = "manifestError"
    case metadataError = "metadataError"
    case networkError = "networkError"
    case parsingError = "parsingError"
    case resourceIntegrityError = "resourceIntegrityError"
    case resourceRetrievalError = "resourceRetrievalError"
    case signingError = "signingError"
    case transactionError = "transactionError"
    case vaultError = "vaultError"
    case whitelistingError = "whitelistingError"
    case malformedRequestError = "malformedRequestError"
    case domainError = "domainError"
    //general catch all
    case unexpectedError = "unexpectedError"
}

open class EosioError: Error, CustomStringConvertible {
    
    public var errorCode: EosioErrorCode
    public var reason: String
    public var context: String
    public var originalError: NSError?
    
    var errorAsJsonString: String {
        let jsonDict = [
            "errorType" : "EosioError",
            "errorInfo" : [
                "errorCode": self.errorCode.rawValue,
                "reason": self.reason,
                "contextualInfo": context
            ]
            ] as [String : Any]
        
        if JSONSerialization.isValidJSONObject(jsonDict) {
            if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted) {
                return String(data: data, encoding: String.Encoding.utf8) ?? "{}"
            } else {
                print("unable to create Json for error")
                return "{}"
            }
        }
        return "{}"
    }
    
    public var description: String {
        return self.localizedDescription
    }
    
    public init(_ errorCode: EosioErrorCode, reason: String, context: String = "") {
        self.context = context
        self.errorCode = errorCode
        self.reason = reason
    }
    
    public convenience init (_ errorCode: EosioErrorCode, reason: String, context: String = "", originalError: NSError? = nil) {
        self.init(errorCode, reason: reason, context: context)
        self.originalError = originalError
    }
}

extension EosioError: LocalizedError {
    
    public var errorDescription: String? {
        
        if context.count > 0 {
            return String("\(self.errorCode.rawValue): \(self.reason)\n context: \(self.context)")
        } else {
            return String("\(self.errorCode.rawValue): \(self.reason)")
        }
    }
}

public extension Error {
    
    public var eosioError: EosioError {
        
        if let eosioError = self as? EosioError {
            return eosioError
        } else {
            return EosioError(EosioErrorCode.unexpectedError, reason: self.localizedDescription)
        }
    }
    
}
    
    
    
    

