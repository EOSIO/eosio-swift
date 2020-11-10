//
//  EosioTransactionPromises.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/17/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - `EosioTransaction` methods returning Promises.
extension EosioTransaction {
    /// Promised based method for signing a transaction and then broadcasting it.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///
    /// Returns Promise<Bool>.
    public func signAndBroadcast(_: PMKNamespacer) -> Promise<Bool> {
        return Promise { signAndBroadcast(completion: $0.resolve) }
    }
    /// Promised based method for signing a transaction.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///
    /// Returns Promise<Bool>.
    public func sign(_: PMKNamespacer) -> Promise<Bool> {
        return Promise { sign(completion: $0.resolve) }
    }
    /// Promised based method for signing a transaction with available keys.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///   - availableKeys: An array of public key strings that correspond to the private keys availble for signing.
    ///
    /// Returns Promise<Bool>.
    public func sign(_: PMKNamespacer, availableKeys: [String]) -> Promise<Bool> {
        return Promise { sign (availableKeys: availableKeys, completion: $0.resolve) }
    }
    // public func sign(publicKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void)
    /// Promised based method for signing a transaction with publicKeys keys.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///   - publicKeys: An array of public key strings that correspond to the private keys to sign the transaction with.
    ///
    /// Returns Promise<Bool>.
    public func sign(_: PMKNamespacer, publicKeys: [String]) -> Promise<Bool> {
        return Promise { sign (publicKeys: publicKeys, completion: $0.resolve) }
    }
    /// Promised based method for broadcast a transaction.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///
    /// Returns Promise<Bool>.
    public func broadcast(_: PMKNamespacer) -> Promise<Bool> {
        return Promise { broadcast(completion: $0.resolve) }
    }
    /// Promised based method to serialize a transaction.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///
    /// Returns Promise<Data>.
    public func serializeTransaction(_: PMKNamespacer) -> Promise<Data> {
        return Promise { serializeTransaction(completion: $0.resolve) }
    }
    /// Promised based method to prepare a transaction.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning function. Pass in `.promise` as the first parameter to call this method.
    ///
    /// Returns Promise<Bool>.
    public func prepare(_: PMKNamespacer) -> Promise<Bool> {
        return Promise { prepare(completion: $0.resolve) }
    }
}
