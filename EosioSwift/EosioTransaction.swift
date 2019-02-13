//
//  EosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation

public class EosioTransaction {
    
    public var chainId = ""
    
    public var abis = [EosioName:String]()
    
    public var id: String?
    public var blockNum: UInt64?
    
    public var expiration = Date(timeIntervalSince1970: 0)
    public var refBlockNum:  UInt16 = 0
    public var refBlockPrefix: UInt64 = 0
    public var maxNetUsageWords: UInt = 0
    public var maxCpuUsageMs: UInt = 0
    public var delaySec: UInt = 0
    public var contextFreeActions = [String]()
    public var actions = [Action]()
    public var transactionExtensions = [String]()
    

    
    
}
