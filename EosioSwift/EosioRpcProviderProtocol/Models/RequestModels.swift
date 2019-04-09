//
//  RequestModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/20/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioRpcTableRowsRequest: Codable {
    public var scope: String = "inita"
    public var code: String = "currency"
    public var table: String = "account"
    public var tableKey: String?
    public var json : Bool
    public var lowerBound : String?
    public var upperBound: String?
    public var limit : Int = 10
    public var indexPosition : String = "1"
    public var keyType: String?
    public var encodeType : String = "dec"
    
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
    public var limit: String
    public var lowerBound: String
    public var json: Bool
    
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
}


public struct EosioRpcPushTransactionRequest: Codable {
    public var signatures = [String]()
    public var compression = 0
    public var packedContextFreeData = ""
    public var packedTrx = ""
}

public struct EosioRpcBlockRequest: Codable {
    public var block_num_or_id: UInt64 = 0
}

public struct EosioRpcRawAbiRequest: Codable {
    public var account_name: EosioName
}

public struct EosioRpcBlockHeaderStateRequest: Codable {
    public var block_num_or_id: String = ""
}

public struct EosioRpcAccountRequest: Codable {
    public var account: EosioName
}



public struct EosioRpcCurrencyStatsRequest: Codable {
    public var code: String = ""
    public var symbol: String = ""
}

public struct EosioRpcHistoryTransactionRequest: Codable {
    public var transactionId: String = ""
}

public struct EosioRpcHistoryKeyAccountsRequest: Codable {
    public var publicKey: String = ""
}

public struct EosioRpcHistoryControlledAccountsRequest: Codable {
    public var controllingAccount: EosioName
}

public struct EosioRpcTableByScopeRequest: Codable{
    public let code: String
    public let table: String?
    public let lowerBound: String?
    public let upperBound: String?
    public let limit: Int32?
    public let reverse: Bool?
}
