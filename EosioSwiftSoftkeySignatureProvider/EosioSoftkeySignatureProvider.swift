//
//  EosioSwiftSoftkeySignatureProvider.swift
//  EosioSwiftSoftkeySignatureProvider
//
//  Created by Farid Rahmani on 3/14/19.
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import EosioSwift
import EosioSwiftEcc

/// Example signature provider for EOSIO SDK for Swift for signing transactions using in-memory K1 private keys. This
/// signature provider implementation stores keys in memory and is therefore not secure. Use only for development purposes.
public final class EosioSoftkeySignatureProvider: EosioSignatureProviderProtocol {
    private struct Key {
        let eosioPublicKey: String
        let uncompressedPublicKey: Data
        let compressedPublicKey: Data
        let privateKey: Data
    }
    private var keyPairs = [Data: Key]()
    private let lock = String()

    /// Initializes the signature provider using the private keys in the given array.
    ///
    /// - Parameter privateKeys: Array of private keys in `String` format.
    /// - Throws: Throws an error if any of the keys in the given `privateKeys` array is not valid.
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
            let eosioPublicKey = compressedPublicKey.toEosioK1PublicKey
            let key = Key(eosioPublicKey: eosioPublicKey, uncompressedPublicKey: publicKeyData, compressedPublicKey: compressedPublicKey, privateKey: privateKeyData)
            keyPairs[compressedPublicKey] = key
        }

    }

    /// Asynchronous method signing a transaction request. Invoked by an `EosioTransaction` during the signing process.
    ///
    /// - Parameters:
    ///   - request: An `EosioTransactionSignatureRequest` struct (as defined in the `EosioSwift` library).
    ///   - completion: Calls the completion with an `EosioTransactionSignatureResponse` struct (as defined in the `EosioSwift` library).
    public func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        var response = EosioTransactionSignatureResponse()
        do {
            var signatures = [String]()

            for eosioPublicKey in request.publicKeys {
                let compressedPublicKey = try Data(eosioPublicKey: eosioPublicKey)
                objc_sync_enter(lock)
                guard let key = keyPairs[compressedPublicKey] else {
                    response.error = EosioError(.keyManagementError, reason: "No private key available for \(eosioPublicKey)")
                    return completion(response)
                }
                objc_sync_exit(lock)
                let chainIdData = try Data(hex: request.chainId)
                let zeros = Data(repeating: 0, count: 32)
                let data = try EosioEccSign.signWithK1(publicKey: key.uncompressedPublicKey, privateKey: key.privateKey, data: chainIdData + request.serializedTransaction + zeros)
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

    /// Asynchronous method that provides available public keys to the `EosioTransaction` during the signing preparation process.
    ///
    /// - Parameter completion: Calls the completion with an `EosioAvailableKeysResponse` stuct containing an optional array of available public keys in `String` format.
    public func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void) {
        var response = EosioAvailableKeysResponse()
        objc_sync_enter(lock)
        response.keys = Array(keyPairs.values).compactMap({ (key) -> String? in
            return key.eosioPublicKey
        })
        objc_sync_exit(lock)
        completion(response)
    }
}
