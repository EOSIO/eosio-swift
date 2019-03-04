//
//  EosioResult.swift
//  EosioSwiftFoundation
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

// Used to provide typed results in closure returns so that there won't be
// any nil return states to test for.
public enum EosioResult<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
