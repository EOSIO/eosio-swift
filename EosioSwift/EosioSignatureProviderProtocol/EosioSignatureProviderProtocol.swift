//
//  EosioSignatureProviderProtocol.swift
//  EosioSwift

//  Created by Todd Bowden on 7/15/18.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// The transaction and related information structure sent to a signature provider for signing.
public struct EosioTransactionSignatureRequest: Codable {
    /// The serialized transaction as `Data`.
    public var serializedTransaction = Data()
    /// The chain ID as a `String`.
    public var chainId = ""
    /// An array of public keys identifying the private keys with which the transaction should be signed.
    public var publicKeys = [String]()
    /// An array of `BinaryAbi`s sent along so that signature providers can display transaction information to the user.
    public var abis = [BinaryAbi]()
    /// Should the signature provider be allowed to modify the transaction? E.g., adding an assert action. Defaults to `true`.
    public var isModificationAllowed = true

    /// The structure for `BinaryAbi`s.
    public struct BinaryAbi: Codable {
        /// The account name for the contract, as a `String`.
        public var accountName = ""
        /// The binary representation of the ABI as a `String`.
        public var abi = ""
        /// Initializer for the `BinaryAbi`.
        public init() { }
    }

    /// Initializer for the `EosioTransactionSignatureRequest`.
    public init() { }
}

/// The structure for the response from a signature provider to an `EosioTransactionSignatureRequest`.
public struct EosioTransactionSignatureResponse: Codable {
    /// The signed transaction, as a `SignedTransaction`.
    public var signedTransaction: SignedTransaction?
    /// An optional error.
    public var error: EosioError?

    /// The structure for a `SignedTransaction`.
    public struct SignedTransaction: Codable {
        /// The serialized transaction, as `Data`. This may be different the transaction requested if the transaction was modified by the signature provider.
        public var serializedTransaction = Data()
        /// An array of signatures as `String`s.
        public var signatures = [String]()
        /// Initializer for the `SignedTransaction`.
        public init() { }
    }

    /// Initializer for the `EosioTransactionSignatureResponse`.
    public init() { }

    /// Initializer for the `EosioTransactionSignatureResponse` when it contains an error.
    ///
    /// - Parameter error: The error as an `EosioError`.
    public init(error: EosioError) {
        self.error = error
    }
}

/// The structure for the response from a signature provider when asked what keys are available for signing.
public struct EosioAvailableKeysResponse: Codable {
    /// The keys as `String`s.
    public var keys: [String]?
    /// An optional error.
    public var error: EosioError?

    /// Initializer for the `EosioAvailableKeysResponse`.
    public init() { }
}

/// The protocol to which signature provider implementations must conform.
public protocol EosioSignatureProviderProtocol {
    /// The method signature for transaction signing requests to conforming signature providers.
    ///
    /// - Parameters:
    ///   - request: The request as an `EosioTransactionSignatureRequest`.
    ///   - completion: The completion that the signature provider implementation will call in response.
    func signTransaction(request: EosioTransactionSignatureRequest, completion: @escaping (EosioTransactionSignatureResponse) -> Void)

    /// The method signature for transaction signing requests to conforming signature providers while specifying
    /// a prompt to use for biometric validation if desired.
    ///
    /// - Parameters:
    ///   - request: The request as an `EosioTransactionSignatureRequest`.
    ///   - prompt: Prompt for biometric authentication, if required.
    ///   - completion: The completion that the signature provider implementation will call in response.
    func signTransaction(request: EosioTransactionSignatureRequest,
                         prompt: String,
                         completion: @escaping (EosioTransactionSignatureResponse) -> Void)

    /// The method signature for public key requests to conforming signature providers.
    ///
    /// - Parameter completion: The method signature for key requests to conforming signature providers.
    func getAvailableKeys(completion: @escaping (EosioAvailableKeysResponse) -> Void)
}

public extension EosioSignatureProviderProtocol {
    func signTransaction(request: EosioTransactionSignatureRequest,
                         prompt: String,
                         completion: @escaping (EosioTransactionSignatureResponse) -> Void) {
        self.signTransaction(request: request, completion: completion)
    }
}
