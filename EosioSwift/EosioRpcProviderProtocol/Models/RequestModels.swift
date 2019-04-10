//
//  RequestModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/20/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioRpcTableRowsRequest: Codable {

    public var scope: String
    public var code: String
    public var table: String
    public var tableKey: String?
    public var json : Bool
    public var lowerBound : String?
    public var upperBound: String?
    public var limit : Int = 10
    public var indexPosition : String = "1"
    public var keyType: String?
    public var encodeType : String = "dec"
    
    public init(scope: String, code: String, table: String, json : Bool, limit : Int = 10, tableKey: String? = nil, lowerBound : String? = nil, upperBound: String? = nil, indexPosition : String = "1", keyType: String? = nil, encodeType : String = "dec") {
        self.scope = scope
        self.code = code
        self.table = table
        self.tableKey = tableKey
        self.json = json
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.limit = limit
        self.indexPosition = indexPosition
        self.keyType = keyType
        self.encodeType = encodeType
    }
    

    enum CodingKeys: String, CodingKey {
        case scope
        case code
        case table
        case tableKey = "table_key"
        case json
        case lowerBound = "lower_bound"
        case upperBound = "upper_bound"
        case limit
        case indexPosition = "index_position"
        case keyType = "key_type"
        case encodeType = "encode_type"
    }
}

public struct EosioRpcCurrencyBalanceRequest: Codable {
    public var code: String
    public var account: String
    public var symbol: String
    
    public init(code: String, account: String, symbol: String) {
        self.code = code
        self.account = account
        self.symbol = symbol
    }
}

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

public struct EosioRpcProducersRequest: Codable {

    public var limit: UInt32
    public var lowerBound: String
    public var json: Bool
    
    public init(limit: UInt32, lowerBound: String, json: Bool) {
        self.limit = limit
        self.lowerBound = lowerBound
        self.json = json
    }
    

    enum CodingKeys: String, CodingKey {
        case limit
        case lowerBound = "lower_bound"
        case json
    }
}

public struct EosioRpcHistoryActionsRequest: Codable {
    public var position: Int32 = -1
    public var offset: Int32 = -20
    public var accountName: EosioName
    
    public init(position: Int32 = -1, offset: Int32 = -20, accountName: EosioName) {
        self.position = position
        self.offset = offset
        self.accountName = accountName
    }
}

public struct EosioRpcPushTransactionRequest: Codable {
    public var signatures = [String]()
    public var compression = 0
    public var packedContextFreeData = ""
    public var packedTrx = ""
    
    public init(signatures: [String] = [], compression:Int = 0, packedContextFreeData: String = "", packedTrx: String = "") {
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
    
    public init(accountName: EosioName) {
        self.accountName = accountName
    }
}

public struct EosioRpcBlockHeaderStateRequest: Codable {
    public var blockNumOrId: String
    
    public init(blockNumOrId: String) {
        self.blockNumOrId = blockNumOrId
    }
    

}

public struct EosioRpcAccountRequest: Codable {
    public var accountName: EosioName
    
    public init(accountName: EosioName) {
        self.accountName = accountName
    }
}



public struct EosioRpcCurrencyStatsRequest: Codable {
    public var code: String = ""
    public var symbol: String = ""
    
    public init(code: String = "", symbol: String = "") {
        self.code = code
        self.symbol = symbol
    }
}

public struct EosioRpcHistoryTransactionRequest: Codable {
    public var id: String
    public var blockNumHint: Int32?
    public init(transactionId: String, blockNumHint: Int32? = nil) {
        self.id = transactionId
        self.blockNumHint = blockNumHint
    }
}

public struct EosioRpcHistoryKeyAccountsRequest: Codable {
    public var publicKey: String = ""
    
    public init(publicKey: String) {
        self.publicKey = publicKey
    }
}

public struct EosioRpcHistoryControlledAccountsRequest: Codable {
    public var controllingAccount: EosioName
    
    public init(controllingAccount: EosioName) {
        self.controllingAccount = controllingAccount
    }
}

public struct EosioRpcTableByScopeRequest: Codable{
    public let code: String
    public let table: String?
    public let lowerBound: String?
    public let upperBound: String?
    public let limit: Int32?
    public let reverse: Bool?
    
    public init(code: String, table: String? = nil, lowerBound: String? = nil, upperBound: String? = nil, limit: Int32? = nil, reverse: Bool? = nil) {
        self.code = code
        self.table = table
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.limit = limit
        self.reverse = reverse
    }
}
