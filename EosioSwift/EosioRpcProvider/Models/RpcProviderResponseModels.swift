//
//  ResponseModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

/// Response struct for the `get_info` RPC endpoint.
public struct EosioRpcInfoResponse: EosioRpcInfoResponseProtocol, EosioRpcResponseProtocol, Codable {
    public var _rawResponse: Any?
    public let serverVersion: String
    public let chainId: String
    public let headBlockNum: UInt64
    public let lastIrreversibleBlockNum: UInt64
    public let lastIrreversibleBlockId: String
    public let headBlockId: String
    public let headBlockTime: String
    public let headBlockProducer: String
    public let virtualBlockCpuLimit: UInt64
    public let virtualBlockNetLimit: UInt64
    public let blockCpuLimit: UInt64
    public let blockNetLimit: UInt64
    public let serverVersionString: String

    enum CodingKeys: String, CodingKey {
        case serverVersion = "server_version"
        case chainId = "chain_id"
        case headBlockNum = "head_block_num"
        case lastIrreversibleBlockNum = "last_irreversible_block_num"
        case lastIrreversibleBlockId = "last_irreversible_block_id"
        case headBlockId = "head_block_id"
        case headBlockTime = "head_block_time"
        case headBlockProducer = "head_block_producer"
        case virtualBlockCpuLimit = "virtual_block_cpu_limit"
        case virtualBlockNetLimit = "virtual_block_net_limit"
        case blockCpuLimit = "block_cpu_limit"
        case blockNetLimit = "block_net_limit"
        case serverVersionString = "server_version_string"
    }

    public init(serverVersion: String = "", chainId: String, headBlockNum: UInt64, lastIrreversibleBlockNum: UInt64,
                lastIrreversibleBlockId: String, headBlockId: String, headBlockTime: String, headBlockProducer: String = "",
                virtualBlockCpuLimit: UInt64 = 0, virtualBlockNetLimit: UInt64 = 0, blockCpuLimit: UInt64 = 0, blockNetLimit: UInt64 = 0,
                serverVersionString: String = "") {
        self.serverVersion = serverVersion
        self.chainId = chainId
        self.headBlockNum = headBlockNum
        self.lastIrreversibleBlockNum = lastIrreversibleBlockNum
        self.lastIrreversibleBlockId = lastIrreversibleBlockId
        self.headBlockId = headBlockId
        self.headBlockTime = headBlockTime
        self.headBlockProducer = headBlockProducer
        self.virtualBlockCpuLimit = virtualBlockCpuLimit
        self.virtualBlockNetLimit = virtualBlockNetLimit
        self.blockCpuLimit = blockCpuLimit
        self.blockNetLimit = blockNetLimit
        self.serverVersionString = serverVersionString
    }
}

/// Response struct for the `get_block` RPC endpoint.
public struct EosioRpcBlockResponse: EosioRpcBlockResponseProtocol, EosioRpcResponseProtocol, Codable {
    public var _rawResponse: Any?
    public let timestamp: String
    public let producer: String
    public let confirmed: UInt
    public let previous: String
    public let transactionMroot: String
    public let actionMroot: String
    public let scheduleVersion: UInt
    public let newProducers: String?
    public let headerExtensions: [String]
    public let producerSignature: String
    public let id: String
    public let blockNum: UInt64
    public let refBlockPrefix: UInt64

    enum CodingKeys: String, CodingKey {
        case timestamp
        case producer
        case confirmed
        case previous
        case transactionMroot = "transaction_mroot"
        case actionMroot = "action_mroot"
        case scheduleVersion = "schedule_version"
        case newProducers = "new_producers"
        case headerExtensions = "header_extensions"
        case producerSignature = "producer_signature"
        case id
        case blockNum = "block_num"
        case refBlockPrefix = "ref_block_prefix"

    }

    public init(timestamp: String, producer: String = "", confirmed: UInt = 0, previous: String = "", transactionMroot: String = "",
                actionMroot: String = "", scheduleVersion: UInt = 0, newProducers: String?, headerExtensions: [String] = [],
                producerSignature: String = "",
                id: String, blockNum: UInt64, refBlockPrefix: UInt64) {
        self.timestamp = timestamp
        self.producer = producer
        self.confirmed = confirmed
        self.previous = previous
        self.transactionMroot = transactionMroot
        self.actionMroot = actionMroot
        self.scheduleVersion = scheduleVersion
        self.newProducers = newProducers
        self.headerExtensions = headerExtensions
        self.producerSignature = producerSignature
        self.id = id
        self.blockNum = blockNum
        self.refBlockPrefix = refBlockPrefix
    }
}

/// Response struct for the `get_raw_abi` RPC endpoint.
public struct EosioRpcRawAbiResponse: EosioRpcRawAbiResponseProtocol, EosioRpcResponseProtocol, Codable {
    public var _rawResponse: Any?
    public var accountName: String
    public var codeHash: String
    public var abiHash: String
    public var abi: String

    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case codeHash = "code_hash"
        case abiHash = "abi_hash"
        case abi
    }

    public init(accountName: String, codeHash: String, abiHash: String, abi: String) {
        self.accountName = accountName
        self.codeHash = codeHash
        self.abiHash = abiHash
        self.abi = abi
    }
}

/// Response struct for the `get_required_keys` RPC endpoint.
public struct EosioRpcRequiredKeysResponse: EosioRpcRequiredKeysResponseProtocol, EosioRpcResponseProtocol, Codable {
    public var _rawResponse: Any?
    public var requiredKeys: [String]

    enum CodingKeys: String, CodingKey {
        case requiredKeys = "required_keys"
    }

    public init(requiredKeys: [String]) {
        self.requiredKeys = requiredKeys
    }
}

/// Response struct for the `push_transaction` RPC endpoint.
public struct EosioRpcTransactionResponse: EosioRpcTransactionResponseProtocol, EosioRpcResponseProtocol, Codable {
    public var _rawResponse: Any?
    public var transactionId: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
    }

    public init(transactionId: String) {
        self.transactionId = transactionId
    }
}

/// Response struct for the `get_key_accounts` RPC endpoint
public struct EosioRpcKeyAccountsResponse: Codable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?
    public var accountNames: [String] = [String]()

    enum CodingKeys: String, CodingKey {
        case accountNames = "account_names"
    }
}

/// Reponse type for `wait_weight` in RPC endpoint responses.
public struct WaitWeight: Codable {
    public var waitSec: UInt64
    public var weight: UInt64

    enum CodingKeys: String, CodingKey {
        case waitSec = "wait_sec"
        case weight
    }
}

/// Response type for `permission_level` in RPC endpoint responses.
public struct PermissionLevel: Codable {
    public var actor: String
    public var permission: String

    enum CodingKeys: String, CodingKey {
        case actor
        case permission
    }
}

/// Response type for `permission_level_weight in RPC endpoint responses.
public struct PermissionLevelWeight: Codable {
    public var weight: UInt64
    public var accounts: [PermissionLevel]

    enum CodingKeys: String, CodingKey {
        case weight
        case accounts
    }
}

/// Response type for `key_weight` structure in RPC endpoint responses.
public struct KeyWeight: Codable {
    public var key: String
    public var weight: UInt64

    enum CodingKeys: String, CodingKey {
        case key
        case weight
    }
}

/// Response type for `authority` structure in RPC endpoint responses.
public struct Authority: Codable {
    public var threshold: UInt64
    public var keys: [KeyWeight]
    public var waits: [WaitWeight]

    enum CodingKeys: String, CodingKey {
        case threshold
        case keys
        case waits
    }
}

/// Response type for `permission` structure in RPC endpoint responses.
public struct Permission: Codable {
    public var permName: String
    public var parent: String

    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
    }
}

/// Response type for the `get_account` RPC endpoint.
public struct EosioRpcAccountResponse: Codable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var accountName: String
    public var headBlockNum: UInt64 = 0
    public var headBlockTime: String = ""
    public var privileged: Bool = false
    public var lastCodeUpdate: String = ""
    public var created: String = ""
    public var coreLiquidBalance: String = ""
    public var ramQuota: UInt64 = 0
    public var netWeight: UInt64 = 0
    public var cpuWeight: UInt64 = 0
    public var netLimit: JSONValue
    public var cpuLimit: JSONValue
    public var ramUsage: UInt64 = 0
    public var permissions: [Permission]
    public var totalResources: JSONValue?
    public var selfDelegatedBandwidth: JSONValue?
    public var refundRequest: JSONValue?
    public var voterInfo: JSONValue?

    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case headBlockNum = "head_block_num"
        case headBlockTime = "head_block_time"
        case privileged
        case lastCodeUpdate = "last_code_update"
        case created
        case coreLiquidBalance = "core_liquid_balance"
        case ramQuota = "ram_quota"
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case netLimit = "net_limit"
        case cpuLimit = "cpu_limit"
        case ramUsage = "ram_usage"
        case permissions
        case totalResources = "total_resources"
        case selfDelegatedBandwidth = "self_delegated_bandwidth"
        case refundRequest = "refund_request"
        case voterInfo = "voter_info"
    }
}

/* Responses without response models */

/// Struct for response types which do not have models created for them. For those, we simply provide the `_rawResponse`.
public struct RawResponse: Codable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    enum CodingKeys: CodingKey {
    }
}

/// Response type for the `push_transactions` RPC endpoint.
public typealias EosioRpcPushTransactionsResponse = RawResponse

/// Response type for the `get_block_header_state` RPC endpoint.
public typealias EosioRpcBlockHeaderStateResponse = RawResponse

/// Response type for the `get_abi` RPC endpoint.
public typealias EosioRpcAbiResponse = RawResponse

/// Response type for the `get_currency_balance` RPC endpoint.
public typealias EosioRpcCurrencyBalanceResponse = RawResponse

/// Response type for the `get_currency_stats` RPC endpoint.
public typealias EosioRpcCurrencyStatsResponse = RawResponse

/// Response type for the `get_producers` RPC endpoint.
public typealias EosioRpcProducersResponse = RawResponse

/// Response type for the `get_raw_code_and_abi` RPC endpoint.
public typealias EosioRpcRawCodeAndAbiResponse = RawResponse

/// Response type for the `get_table_by_scope` RPC endpoint.
public typealias EosioRpcTableByScopeResponse = RawResponse

/// Response type for the `get_table_rows` RPC endpoint.
public typealias EosioRpcTableRowsResponse = RawResponse

/// Response type for the `get_code` RPC endpoint.
public typealias EosioRpcCodeResponse = RawResponse

/* History Endpoints */

/// Response type for the `get_actions` RPC endpoint.
public typealias EosioRpcActionsResponse = RawResponse

/// Response type for the `get_transaction` RPC endpoint.
public typealias EosioRpcGetTransactionResponse = RawResponse

/// Response type for the `get_controlled_accounts` RPC endpoint.
public typealias EosioRpcControlledAccountsResponse = RawResponse
