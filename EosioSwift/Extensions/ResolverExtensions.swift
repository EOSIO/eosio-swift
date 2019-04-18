//
//  ResolverExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/18/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import PromiseKit

public extension Resolver {
    func resolve(_ result: EosioResult<T, EosioError>) {
        switch result {
        case .failure (let err):
            reject(err)
        case .success (let res):
            fulfill(res)
        }
    }
}
