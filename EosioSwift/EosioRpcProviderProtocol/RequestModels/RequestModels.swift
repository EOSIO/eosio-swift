//
//  RequestModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/20/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioRpcRequiredKeysRequest: Codable {

    public var transaction: EosioTransaction
    public var availableKeys: [String]

    public init(availableKeys: [String], transaction: EosioTransaction) {

        self.availableKeys = availableKeys
        self.transaction = transaction
    }

    enum CodingKeys: String, CodingKey {
        case transaction = "transaction"
        case availableKeys = "available_keys"
    }
}

public struct EosioRpcPushTransactionRequest: Codable {
    public var signatures = [String]()
    public var compression = 0
    public var packedContextFreeData = ""
    public var packedTrx = ""

    public init(signatures: [String] = [], compression: Int = 0, packedContextFreeData: String = "", packedTrx: String = "") {
        self.signatures = signatures
        self.compression = compression
        self.packedContextFreeData = packedContextFreeData
        self.packedTrx = packedTrx
    }
}

public struct EosioRpcBlockRequest: Codable {

    public var blockNumOrId: UInt64

    public init(blockNumOrId: UInt64 = 1) {
        self.blockNumOrId = blockNumOrId
    }
}

public struct EosioRpcRawAbiRequest: Codable {
    public var accountName: EosioName
    public var abiHash: String?
    public init(accountName: EosioName, abiHash: String? = nil) {
        self.accountName = accountName
        self.abiHash = abiHash
    }
}
