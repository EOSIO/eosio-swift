//
//  EosioResult.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation

public enum EosioResult<T> {
    case success(T)
    case error(EosioError)
    case empty
}
