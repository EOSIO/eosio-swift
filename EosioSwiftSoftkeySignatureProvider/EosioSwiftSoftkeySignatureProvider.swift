//
//  EosioSwiftSoftkeySignatureProvider.swift
//  EosioSwiftSoftkeySignatureProvider
//
//  Created by Farid Rahmani on 3/14/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation
import EosioSwift
import EosioSwiftEcc
public final class EosioSwiftSoftkeySignatureProvider {
    //Private key pairs in String format
    private var stringKeyPairs = [String:String]()
    
    //Public-Private key pairs in Data format
    private var dataKeyPairs = [Data:Data]()
    
    /**
        Initializes EosiosSwiftSoftkeySignatureProvider using the private keys in the given array.
        - Parameters:
            - privateKeys: An `String` array of private keys.
        - Returns: An EosioSwiftSoftkeySignatureProvider object.
        - Throws:  Throws an error if all the keys in the given `privateKeys` array are not valid keys.
     */
    public init(privateKeys:[String]) throws {
        for privateKey in privateKeys {
            let (_, version, _) = try privateKey.eosioComponents()
            if version != "K1" {
                throw EosioError(EosioErrorCode.keyManagementError, reason: "Unsupported key type. Only K1 key types are supported in this version of the library. Key: \(privateKey) Type: \(version)")
            }
            let privateKeyData = try Data(eosioPrivateKey: privateKey)
            let publicKeyData = try EccRecoverKey.recoverPublicKey(privateKey: privateKeyData, curve: .k1)
            guard let compressedPublicKey = publicKeyData.compressedPublicKey else {
                throw EosioError(EosioErrorCode.keyManagementError, reason: "Cannot compress key \(publicKeyData.hex)")
            }
            let publicKeyString = compressedPublicKey.toEosioK1PublicKey
            self.dataKeyPairs[publicKeyData] = privateKeyData
            self.stringKeyPairs[publicKeyString] = privateKey
        }
        
        
    }
    
    
    
    
}

extension EosioSwiftSoftkeySignatureProvider: EosioSignatureProviderProtocol {
    
    public func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var response = EosioTransactionSignatureResponse()
        do {
            var signatures = [String]()
            
            for (publicKey, privateKey) in dataKeyPairs{
                let chainIdData = try Data(hex: request.chainId)
                let zeros = Data(repeating: 0, count: 32)
                let data = try EosioEccSign.signWithK1(publicKey: publicKey, privateKey: privateKey, data: chainIdData + request.serializedTransaction + zeros)
                signatures.append(data.toEosioK1Signature)
            }
            var signedTransaction = EosioTransactionSignatureResponse.SignedTransaction()
            signedTransaction.signatures = signatures
            signedTransaction.serializedTransaction = request.serializedTransaction
            response.signedTransaction = signedTransaction
            completion(response)
        } catch {
            response.error = error as? EosioError
            completion(response)
        }
        
    }
    
    public func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void) {
        
        var response = EosioAvailableKeysResponse()
        response.keys = Array(stringKeyPairs.keys)
        completion(response)
        
    }
}
