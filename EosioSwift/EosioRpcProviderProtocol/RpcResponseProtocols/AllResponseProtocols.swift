//
//  AllResponseProtocols.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/3/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public protocol EosioRpcInfoResponseProtocol {
    var chainId: String { get }
    var headBlockNum: UInt64 { get }
    var headBlockTime: String { get }
}

public protocol EosioRpcBlockResponseProtocol {
    var blockNum: UInt64 { get }
    var refBlockPrefix: UInt64 { get }
}

public protocol EosioRpcRawAbiResponseProtocol {
    var accountName: String { get }
    var abi: String { get }
    var abiHash: String { get }
}

public protocol EosioRpcRequiredKeysResponseProtocol {
    var requiredKeys: [String] { get }
}

public protocol EosioRpcTransactionResponseProtocol {
    var transactionId: String { get }
}
