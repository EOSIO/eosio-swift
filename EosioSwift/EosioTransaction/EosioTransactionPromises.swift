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
        return Promise { seal in
            signAndBroadcast { result in
                switch result {
                case .failure (let err):
                    seal.reject(err)
                case .success (let res):
                    seal.fulfill(res)
                }
            }
        }
    }
    /// Promised based method for signing a transaction.
    ///
    /// Returns Promise<Bool>.
    public func sign() -> Promise<Bool> {
        return Promise { seal in
            sign { result in
                switch result {
                case .failure (let err):
                    seal.reject(err)
                case .success (let res):
                    seal.fulfill(res)
                }
            }
        }
    }
    /// Promised based method for broadcast a transaction.
    ///
    /// Returns Promise<Bool>.
    public func broadcast() -> Promise<Bool> {
        return Promise { seal in
            sign { result in
                switch result {
                case .failure (let err):
                    seal.reject(err)
                case .success (let res):
                    seal.fulfill(res)
                }
            }
        }
    }
}
