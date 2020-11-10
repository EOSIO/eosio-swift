//
//  EosioTransactionCombine.swift
//  EosioSwift

//  Created by Mark Johnson on 5/5/20
//  Copyright (c) 2017-2020 block.one and its contributors. All rights reserved.
//

import Foundation
#if canImport(Combine)
  import Combine
#endif

// MARK: - `EosioTransaction` methods returning Publishers.
@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension EosioTransaction {
    /// Publisher based method for signing a transaction and then broadcasting it.
    ///
    /// Returns an AnyPublisher<Bool, EosioError>.
    public func signAndBroadcastPublisher() -> AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.signAndBroadcast(completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method for signing a transaction.
    ///
    /// Returns AnyPublisher<Bool, EosioError>.
    public func signPublisher() -> AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.sign(completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method for signing a transaction with available keys.
    ///
    /// - Parameters:
    ///   - availableKeys: An array of public key strings that correspond to the private keys availble for signing.
    ///
    /// Returns AnyPublisher<Bool, EosioError>.
    public func signPublisher(availableKeys: [String]) -> AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.sign(availableKeys: availableKeys, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method for signing a transaction with publicKeys keys.
    ///
    /// - Parameters:
    ///   - publicKeys: An array of public key strings that correspond to the private keys to sign the transaction with.
    ///
    /// Returns AnyPublisher<Bool, EosioError>.
    public func signPublisher(publicKeys: [String]) -> AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.sign(publicKeys: publicKeys, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method for broadcast a transaction.
    ///
    /// Returns Promise<Bool>.
    public func broadcastPublisher() -> AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.broadcast(completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method to serialize a transaction.
    ///
    /// Returns AnyPublisher<Data, EosioError>.
    public func serializeTransactionPublisher() -> AnyPublisher<Data, EosioError> {
        return Future<Data, EosioError> { [weak self] promise in
            self?.serializeTransaction(completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Publisher based method to prepare a transaction.
    ///
    /// Returns AnyPublisher<Bool, EosioError>.
    public func preparePublisher() ->AnyPublisher<Bool, EosioError> {
        return Future<Bool, EosioError> { [weak self] promise in
            self?.prepare(completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }
}
