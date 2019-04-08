//
//  ZAssert.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

func ZAssert(_ test: Bool, message: String) {
    if test {
        return
    }

    #if DEBUG
    print(message)
    let exception = NSException()
    exception.raise()
    #else
    NSLog(message)
    return
    #endif
}
