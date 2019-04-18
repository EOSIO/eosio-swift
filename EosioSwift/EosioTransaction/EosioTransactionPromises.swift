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
    /// Promised based method for broadcast a transaction.
    ///
    /// Returns Promise<Bool>.
    public func broadcast() -> Promise<Bool> {
        return Promise { broadcast(completion: $0.resolve) }
    }
}
