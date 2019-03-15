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
    //Public-Private key pairs in String format
    private var stringKeyPairs = [String:String]()
    
    //Public-Private key pairs in Data format
    private var dataKeyPairs = [Data:Data]()
    
    /**
        Initializes EosiosSwiftSoftkeySignatureProvider using the public-private key pairs in the given dictionary.
        - Parameters:
            - keyPairs: A dictionary of public and private key pairs, with the public key as dictionary key and the associated private key as it's value in the dicationary.
        - Returns: An EosioSwiftSoftkeySignatureProvider object or nil if all the keys in the given `keyPairs` dictionary are not valid keys.
     
     */
    init?(keyPairs:[String : String]) {
        stringKeyPairs = keyPairs
        do{
            for (publicKey, privateKey) in keyPairs{
                let publicKeyData = try Data(eosioPublicKey: publicKey)
                let privateKeyData = try Data(eosioPrivateKey: privateKey)
                self.dataKeyPairs[publicKeyData] = privateKeyData
            }
        }catch{
            return nil
        }
    }
    
    
    
    
}

extension EosioSwiftSoftkeySignatureProvider: EosioSignatureProviderProtocol{
    public func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var response = EosioTransactionSignatureResponse()
        do{
            var signatures = [String]()
            
            for (publicKey, privateKey) in dataKeyPairs{
                let data = try EosioEccSign.signWithK1(publicKey: publicKey, privateKey: privateKey, data: request.serializedTransaction)
                signatures.append(data.toEosioK1Signature)
            }
            var signedTransaction = EosioTransactionSignatureResponse.SignedTransaction()
            signedTransaction.signatures = signatures
            response.signedTransaction = signedTransaction
            completion(response)
        }catch let error{
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
