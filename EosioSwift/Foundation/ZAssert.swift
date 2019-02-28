//
//  ZAssert.swift
//  EosioSwiftFoundation
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

func ZAssert(_ test: Bool, message: String) -> Void {
    
    if(test) {
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
