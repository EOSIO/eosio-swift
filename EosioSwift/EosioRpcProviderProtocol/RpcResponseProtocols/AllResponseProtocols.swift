//
//  AllResponseProtocols.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/3/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

/// Protocol for get_info responses. RPC responses must contain these properties, at a minimum, in order to be compatible with the core EOSIO SDK for Swift library.
public protocol EosioRpcInfoResponseProtocol {
    var chainId: String { get }
    var headBlockNum: UInt64 { get }
    var headBlockTime: String { get }
}

/// Protocol for get_block responses. RPC responses must contain these properties, at a minimum, in order to be compatible with the core EOSIO SDK for Swift library.
public protocol EosioRpcBlockResponseProtocol {
    var blockNum: UInt64 { get }
    var refBlockPrefix: UInt64 { get }
}

/// Protocol for get_raw_abi responses. RPC responses must contain these properties, at a minimum, in order to be compatible with the core EOSIO SDK for Swift library.
public protocol EosioRpcRawAbiResponseProtocol {
    var accountName: String { get }
    var abi: String { get }
    var abiHash: String { get }
}

/// Protocol for get_required_keys responses. RPC responses must contain these properties, at a minimum, in order to be compatible with the core EOSIO SDK for Swift library.
public protocol EosioRpcRequiredKeysResponseProtocol {
    var requiredKeys: [String] { get }
}

/// Protocol for push_transaction responses. RPC responses must contain these properties, at a minimum, in order to be compatible with the core EOSIO SDK for Swift library.
public protocol EosioRpcTransactionResponseProtocol {
    var transactionId: String { get }
}

/// Protocol for generic responses. All RPC response objects will contain the `_rawResponse` property.
public protocol EosioRpcResponseProtocol {
    var _rawResponse: Any? { get set }
}
