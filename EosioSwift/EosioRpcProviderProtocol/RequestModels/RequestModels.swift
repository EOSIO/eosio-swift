//
//  RequestModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/20/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

/// Request struct for requests to `v1/chain/get_required_keys`.
public struct EosioRpcRequiredKeysRequest: Codable {
    /// The transaction, as an `EosioTransaction`.
    public var transaction: EosioTransaction
    /// All public keys available for signing.
    public var availableKeys: [String]

    /// Initialize an `EosioRpcRequiredKeysRequest`.
    public init(availableKeys: [String], transaction: EosioTransaction) {
        self.availableKeys = availableKeys
        self.transaction = transaction
    }

    enum CodingKeys: String, CodingKey {
        case transaction = "transaction"
        case availableKeys = "available_keys"
    }
}

/// Request struct for requests to `v1/chain/push_transaction`.
public struct EosioRpcPushTransactionRequest: Codable {
    /// Array of signatures as Strings.
    public var signatures = [String]()
    /// Compression
    public var compression = 0
    /// Context free data, packed.
    public var packedContextFreeData = ""
    /// The serialized transaction as a hex String.
    public var packedTrx = ""

    /// Initialize an `EosioRpcPushTransactionRequest`.
    public init(signatures: [String] = [], compression: Int = 0, packedContextFreeData: String = "", packedTrx: String = "") {
        self.signatures = signatures
        self.compression = compression
        self.packedContextFreeData = packedContextFreeData
        self.packedTrx = packedTrx
    }
}

/// Request struct for requests to `v1/chain/get_block`.
public struct EosioRpcBlockRequest: Codable {
    /// The number or ID of the block you are fetching.
    public var blockNumOrId: UInt64

    /// Initialize an `EosioRpcBlockRequest`.
    public init(blockNumOrId: UInt64 = 1) {
        self.blockNumOrId = blockNumOrId
    }
}

/// Request struct for requests to `v1/chain/get_raw_abi`.
public struct EosioRpcRawAbiRequest: Codable {
    /// Account name (i.e., name of the contract).
    public var accountName: EosioName
    /// Hash of the ABI. (optional)
    public var abiHash: String?
    /// Initialize an `EosioRpcRawAbiRequest`.
    public init(accountName: EosioName, abiHash: String? = nil) {
        self.accountName = accountName
        self.abiHash = abiHash
    }
}
