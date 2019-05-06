//
//  EosioTransactionFactory.swift
//  EosioSwift
//
//  Created by Serguei Vinnitskii on 4/15/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Convenience class for creating transactions on EOSIO-based blockchains. Once you set properties (`rpcProvider` etc.), you don't have to set them again in order to create a new transaction.
public class EosioTransactionFactory {

    /// Remote Procedure Call (RPC) provider for facilitating communication with blockchain nodes. Conforms to `EosioRpcProviderProtocol`.
    let rpcProvider: EosioRpcProviderProtocol
    /// Signature provider for facilitating the retrieval of available public keys and the signing of transactions. Conforms to `EosioSignatureProviderProtocol`.
    let signatureProvider: EosioSignatureProviderProtocol
    /// Serialization provider for facilitating ABI-driven transaction and action (de)serialization between JSON and binary data representations. Conforms to `EosioSerializationProviderProtocol`.
    let serializationProvider: EosioSerializationProviderProtocol
     /// Application Binary Interface (ABI) provider for facilitating the fetching and caching of ABIs from blockchain nodes. A default is provided. Conforms to `EosioAbiProviderProtocol`.
    let abiProvider: EosioAbiProviderProtocol?
    /// Transaction configuration.
    let config: EosioTransaction.Config?

    /// Initializes the class.
    public init(
        rpcProvider: EosioRpcProviderProtocol,
        signatureProvider: EosioSignatureProviderProtocol,
        serializationProvider: EosioSerializationProviderProtocol,
        abiProvider: EosioAbiProviderProtocol? = nil,
        config: EosioTransaction.Config? = nil
    ) {
        self.rpcProvider = rpcProvider
        self.signatureProvider = signatureProvider
        self.serializationProvider = serializationProvider
        self.abiProvider = abiProvider
        self.config = config
    }

    /// Returns a new `EosioTransaction` instance.
    public func newTransaction() -> EosioTransaction {

        let newTransaction = EosioTransaction()
        newTransaction.rpcProvider = rpcProvider
        newTransaction.signatureProvider = signatureProvider
        newTransaction.serializationProvider = serializationProvider
        newTransaction.abiProvider = abiProvider
        if let config = config { newTransaction.config = config }

        return newTransaction
    }
}
