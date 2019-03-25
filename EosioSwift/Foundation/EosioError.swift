//
//  EosioError.swift
//  EosioSwift
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public enum EosioErrorCode : String, Codable {
    
    case eosioTransactionError = "EosioTransactionError"
    case rpcProviderError = "RpcProviderError"
    case getInfoError = "GetInfoError"
    case getBlockError = "GetBlockError"
    case getRequiredKeysError = "GetRequiredKeysError"
    case getRawAbiError = "GetRawAbiError"
    case pushTransactionError = "PushTransactionError"
    case signatureProviderError = "SignatureProviderErrorr"
    case getAvailableKeysError = "GetAvailableKeysError"
    case signTransactionError = "SignTransactionError"
    case abiProviderError = "AbiProviderError"
    case getAbiError = "GetAbiError"
    case serializationProviderError = "SerializationProviderError"
    case serializeError = "SerializeError"
    case deserializeError = "DeserializeError"

    // non provider errors (added as these are encoundered in Eosio Extensions and Foundation)
    case eosioNameError = "EosioNameError"
    case keyManagementError = "KeyManagementError"
    case keySigningError = "KeySigningError"

    // general catch all
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
        
        switch self.errorCode {
            case .eosioTransactionError:
                return NSLocalizedString("Error was encountered while preparing the Transaction.", comment: "Error in transaction processing flow.")
            case .rpcProviderError:
                return NSLocalizedString("Error was was encountered in RpcProvider.", comment: "Error in rpc processing flow.")
            case .getInfoError:
                return NSLocalizedString("Error was returned by getInfo() method.", comment: "Error in RPC processing flow.")
            case .getBlockError:
                return NSLocalizedString("Error was encountered from getBlock() method of RPCProvider.", comment: "Error in RPC processing flow.")
            case .getRequiredKeysError:
                    return NSLocalizedString("Error was returned by getRequiredKeys() method.", comment: "Error in RPC processing flow.")
            case .getRawAbiError:
                return NSLocalizedString("Error was returned by getRawAbi() method.", comment: "Error in RPC processing flow.")
            case .pushTransactionError:
                return NSLocalizedString("Error was encountered while pushing the transaction.", comment: "Error in RPC processing flow.")
            case .signatureProviderError:
                return NSLocalizedString("Error was was encountered in SignatureProvider.", comment: "Error in SignatureProvider processing flow.")
            case .getAvailableKeysError:
                return NSLocalizedString("Error was returned by getAvailableKeys() method.", comment: "Error in SignatureProviderError processing flow.")
            case .signTransactionError:
                return NSLocalizedString("Error was encountered while signing the transaction.", comment: "Error in SignatureProviderError processing flow.")
            case .abiProviderError:
                return NSLocalizedString("Error was was encountered in AbiProviderError.", comment: "Error in AbiProvider  processing flow.")
            case .getAbiError:
                return NSLocalizedString("Error was returned by getAbi() method.", comment: "Error in AbiProvider processing flow.")
            case .serializationProviderError:
                return NSLocalizedString("Error was was encountered in SerializationProvider.", comment: "Error in SerializationProvider processing flow.")
            case .serializeError:
                return NSLocalizedString("Error was encountered while serializing the transaction.", comment: "Error in SerializationProvider processing flow.")
            case .deserializeError:// = "Error was encountered while deserializing transaction."
                return NSLocalizedString("Error was encountered while deserializing transaction.", comment: "Error in SerializationProvider processing flow.")
            case .eosioNameError: //= "Error was encountered in EosioName."
                return NSLocalizedString("Error was encountered in EosioName.", comment: "Error in EosioName processing flow.")
            case .keyManagementError:
                return NSLocalizedString("Error was encountered in managing a key.", comment: "Error was encountered in managing a key.")
            case .keySigningError:
            return NSLocalizedString("Error was encountered signing with a key.", comment: "Error was encountered signing with a key.")
            case .unexpectedError: //= "UnexpectedError"
                return NSLocalizedString("Unexpected Error was encountered.", comment: "Unexpected Error")
        }
        
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
    
    
    
    

