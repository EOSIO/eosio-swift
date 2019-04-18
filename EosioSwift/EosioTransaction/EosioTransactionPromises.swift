//
//  EosioTransactionPromises.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/17/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import PromiseKit

extension EosioTransaction {
    /// Promised based method for signing a transaction and then broadcasting it.
    ///
    /// Returns Promise<Bool>.
    public func signAndBroadcast() -> Promise<Bool> {
        return Promise { signAndBroadcast(completion: $0.resolve) }
    }
    /// Promised based method for signing a transaction.
    ///
    /// Returns Promise<Bool>.
    public func sign() -> Promise<Bool> {
        return Promise { sign(completion: $0.resolve) }
    }
    /// Promised based method for signing a transaction with available keys.
    ///
    /// - Parameters:
    ///   - availableKeys: An array of public key strings that correspond to the private keys availble for signing.
    ///
    /// Returns Promise<Bool>.
    public func sign(availableKeys: [String]) -> Promise<Bool> {
        return Promise { sign (availableKeys: availableKeys, completion: $0.resolve) }
    }
    // public func sign(publicKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void)
    /// Promised based method for signing a transaction with publicKeys keys.
    ///
    /// - Parameters:
    ///   - publicKeys: An array of public key strings that correspond to the private keys to sign the transaction with.
    ///
    /// Returns Promise<Bool>.
    public func sign(publicKeys: [String]) -> Promise<Bool> {
        return Promise { sign (publicKeys: publicKeys, completion: $0.resolve) }
    }
    /// Promised based method for broadcast a transaction.
    ///
    /// Returns Promise<Bool>.
    public func broadcast() -> Promise<Bool> {
        return Promise { broadcast(completion: $0.resolve) }
    }
    /// Promised based method to serialize a transaction.
    ///
    /// Returns Promise<Bool>.
    public func promiseSerializeTransaction() -> Promise<Data> {
        return Promise { serializeTransaction(completion: $0.resolve) }
    }
    /// Promised based method to prepare a transaction.
    ///
    /// Returns Promise<Bool>.
    public func prepare() -> Promise<Bool> {
        return Promise { prepare(completion: $0.resolve) }
    }
}
