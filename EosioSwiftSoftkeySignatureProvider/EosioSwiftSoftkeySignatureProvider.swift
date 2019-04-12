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

/**
 Example signature provider for EOSIO SDK for Swift for signing transactions using in-memory K1 private keys. This
 signature provider implementation stores keys in memory and is therefore not secure. Use only for development purposes.
 */
public final class EosioSwiftSoftkeySignatureProvider: EosioSignatureProviderProtocol {
    private var stringKeyPairs = [String: String]()
    private var dataKeyPairs = [Data: Data]()

    /**
         Initializes the signature provider using the private keys in the given array.

         - Parameters:
            - privateKeys: Array of private keys in `String` format.
         - Returns: An `EosioSwiftSoftkeySignatureProvider` object.
         - Throws:  Throws an error if any of the keys in the given `privateKeys` array is not valid.
     */
    public init(privateKeys: [String]) throws {
        for privateKey in privateKeys {
            let (_, version, _) = try privateKey.eosioComponents()
            if version != "K1" {
                throw EosioError(EosioErrorCode.keyManagementError, reason: "Unsupported key type. Only K1 key types are supported in this version of the library. Key: \(privateKey) Type: \(version)")
            }
            let privateKeyData = try Data(eosioPrivateKey: privateKey)
            let publicKeyData = try EccRecoverKey.recoverPublicKey(privateKey: privateKeyData, curve: .k1)
            guard let compressedPublicKey = publicKeyData.toCompressedPublicKey else {
                throw EosioError(EosioErrorCode.keyManagementError, reason: "Cannot compress key \(publicKeyData.hex)")
            }
            let publicKeyString = compressedPublicKey.toEosioK1PublicKey
            self.dataKeyPairs[publicKeyData] = privateKeyData
            self.stringKeyPairs[publicKeyString] = privateKey
        }

    }

    /**
        Asynchronous method signing a transaction request. Invoked by an `EosioTransaction` during the signing process.
     
        - Parameters:
            - request: An `EosioTransactionSignatureRequest` struct (as defined in the `EosioSwift` library).
            - completion: The completion callback.
        - Returns: An `EosioTransactionSignatureResponse` struct (as defined in the `EosioSwift` library).

    */
    public func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var response = EosioTransactionSignatureResponse()
        do {
            var signatures = [String]()

            for eosioPublicKey in request.publicKeys {
                let publicKey = try Data(eosioPublicKey: eosioPublicKey)
                guard let privateKey = dataKeyPairs[publicKey] else {
                    response.error = EosioError(.keyManagementError, reason: "No private key available for \(eosioPublicKey)")
                    return completion(response)
                }
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

    /**
        Asynchronous method that provides available public keys to the `EosioTransaction` during the signing preparation process.

         - Parameters:
            - completion: The completion callback.
         - Returns: An `EosioAvailableKeysResponse` stuct containing an optional array of available public keys in `String` format.
    */
    public func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void) {

        var response = EosioAvailableKeysResponse()
        response.keys = Array(stringKeyPairs.keys)
        completion(response)

    }
}
