//
//  EosioError.swift
//  EosioSwift
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public enum EosioErrorCode : String, Codable {
    
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
    case eosioNameError = "eosioNameError"
    case signatureProviderError = "signatureProviderError"
    case serializationError = "serializationError"
    case deserializationError = "deserializationError"
    case dataCodingError = "dataCodingError"
    case missingDataError = "missingDataError"
    case eosioKeyError = "eosioKeyError"
    case eosioSignatureError = "eosioSignatureError"

    //general catch all
    case unexpectedError = "unexpectedError"
}

open class EosioError: Error, CustomStringConvertible, Codable {
    
    public var errorCode: EosioErrorCode
    public var reason: String
    public var context: String
    public var originalError: NSError?
    public var isReturnable = true // can this error be returned to a requesting app?
    
    enum CodingKeys: String, CodingKey {
        case errorCode
        case reason
        case context
    }
    /**
        Returns a JSON string representation of the error object.
    */
    var errorAsJsonString: String {
        let jsonDict = [
            "errorType" : "EosioError",
            "errorInfo" : [
                "errorCode": self.errorCode.rawValue,
                "reason": self.reason,
                "contextualInfo": context
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
    
    public init (_ errorCode: EosioErrorCode, reason: String, context: String = "", originalError: NSError? = nil, isReturnable: Bool = true) {
        self.context = context
        self.errorCode = errorCode
        self.reason = reason
        self.isReturnable = isReturnable
        self.originalError = originalError
    }
}

extension EosioError: LocalizedError {
    
    public var errorDescription: String? {
        return "\(self.errorCode.rawValue): \(self.reason)" + (context.count > 0 ? "\n context: \(self.context)" : "")
        
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
    
    
    
    

