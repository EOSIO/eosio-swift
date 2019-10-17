//
//  ResponseModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Response struct for the `get_info` RPC endpoint.
public struct EosioRpcInfoResponse: EosioRpcInfoResponseProtocol, EosioRpcResponseProtocol, Decodable {
    public var _rawResponse: Any?
    public let serverVersion: String
    public let chainId: String
    public let headBlockNum: EosioUInt64
    public let lastIrreversibleBlockNum: EosioUInt64
    public let lastIrreversibleBlockId: String
    public let headBlockId: String
    public let headBlockTime: String
    public let headBlockProducer: String
    public let virtualBlockCpuLimit: EosioUInt64
    public let virtualBlockNetLimit: EosioUInt64
    public let blockCpuLimit: EosioUInt64
    public let blockNetLimit: EosioUInt64
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

    public init(serverVersion: String = "",
                chainId: String,
                headBlockNum: EosioUInt64,
                lastIrreversibleBlockNum: EosioUInt64,
                lastIrreversibleBlockId: String,
                headBlockId: String,
                headBlockTime: String,
                headBlockProducer: String = "",
                virtualBlockCpuLimit: EosioUInt64 = EosioUInt64.uint64(0),
                virtualBlockNetLimit: EosioUInt64 = EosioUInt64.uint64(0),
                blockCpuLimit: EosioUInt64 = EosioUInt64.uint64(0),
                blockNetLimit: EosioUInt64 = EosioUInt64.uint64(0),
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        serverVersion = try container.decodeIfPresent(String.self, forKey: .serverVersion) ?? ""
        chainId = try container.decode(String.self, forKey: .chainId)
        headBlockNum = try container.decode(EosioUInt64.self, forKey: .headBlockNum)
        lastIrreversibleBlockNum = try container.decode(EosioUInt64.self, forKey: .lastIrreversibleBlockNum)
        lastIrreversibleBlockId = try container.decode(String.self, forKey: .lastIrreversibleBlockId)
        headBlockId = try container.decode(String.self, forKey: .headBlockId)
        headBlockTime = try container.decode(String.self, forKey: .headBlockTime)
        headBlockProducer = try container.decodeIfPresent(String.self, forKey: .headBlockProducer) ?? ""
        virtualBlockCpuLimit = try container.decodeIfPresent(EosioUInt64.self, forKey: .virtualBlockCpuLimit) ?? EosioUInt64.uint64(0)
        virtualBlockNetLimit = try container.decodeIfPresent(EosioUInt64.self, forKey: .virtualBlockNetLimit) ?? EosioUInt64.uint64(0)
        blockCpuLimit = try container.decodeIfPresent(EosioUInt64.self, forKey: .blockCpuLimit) ?? EosioUInt64.uint64(0)
        blockNetLimit = try container.decodeIfPresent(EosioUInt64.self, forKey: .blockNetLimit) ?? EosioUInt64.uint64(0)
        serverVersionString = try container.decodeIfPresent(String.self, forKey: .serverVersionString) ?? ""
    }
}

/// Response struct for the `get_block` RPC endpoint.
public struct EosioRpcBlockResponse: EosioRpcBlockResponseProtocol, EosioRpcResponseProtocol, Decodable {
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
    public let transactions: [Any]
    public let blockExtensions: [Any]
    public let id: String
    public let blockNum: EosioUInt64
    public let refBlockPrefix: EosioUInt64

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
        case transactions
        case blockExtensions = "block_extensions"
        case id
        case blockNum = "block_num"
        case refBlockPrefix = "ref_block_prefix"

    }

    public init(timestamp: String, producer: String = "", confirmed: UInt = 0, previous: String = "", transactionMroot: String = "",
                actionMroot: String = "", scheduleVersion: UInt = 0, newProducers: String?, headerExtensions: [String] = [],
                producerSignature: String = "", transactions: [Any] = [Any](),
                blockExtensions: [Any] = [Any](),
                id: String, blockNum: EosioUInt64, refBlockPrefix: EosioUInt64) {
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
        self.transactions = transactions
        self.blockExtensions = blockExtensions
        self.id = id
        self.blockNum = blockNum
        self.refBlockPrefix = refBlockPrefix
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        timestamp = try container.decode(String.self, forKey: .timestamp)
        producer = try container.decodeIfPresent(String.self, forKey: .producer) ?? ""
        confirmed = try container.decodeIfPresent(UInt.self, forKey: .confirmed) ?? 0
        previous = try container.decodeIfPresent(String.self, forKey: .previous) ?? ""
        transactionMroot = try container.decodeIfPresent(String.self, forKey: .transactionMroot) ?? ""
        actionMroot = try container.decodeIfPresent(String.self, forKey: .actionMroot) ?? ""
        scheduleVersion = try container.decodeIfPresent(UInt.self, forKey: .scheduleVersion) ?? 0
        newProducers = try container.decodeIfPresent(String.self, forKey: .newProducers)
        headerExtensions = try container.decodeIfPresent([String].self, forKey: .headerExtensions) ?? [String]()
        producerSignature = try container.decodeIfPresent(String.self, forKey: .producerSignature) ?? ""
        var nestedTrx = try? container.nestedUnkeyedContainer(forKey: .transactions)
        transactions = nestedTrx?.decodeDynamicValues() ?? [Any]()
        var nestedBlx = try? container.nestedUnkeyedContainer(forKey: .blockExtensions)
        blockExtensions = nestedBlx?.decodeDynamicValues() ?? [Any]()
        id = try container.decode(String.self, forKey: .id)
        blockNum = try container.decode(EosioUInt64.self, forKey: .blockNum)
        refBlockPrefix = try container.decode(EosioUInt64.self, forKey: .refBlockPrefix)
    }

}

/// Response struct for the `get_raw_abi` RPC endpoint.
public struct EosioRpcRawAbiResponse: EosioRpcRawAbiResponseProtocol, EosioRpcResponseProtocol, Decodable {
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
public struct EosioRpcRequiredKeysResponse: EosioRpcRequiredKeysResponseProtocol, EosioRpcResponseProtocol, Decodable {
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
public struct EosioRpcTransactionResponse: EosioRpcTransactionResponseProtocol, EosioRpcResponseProtocol, Decodable {
    public var _rawResponse: Any?
    public var transactionId: String
    public var processed: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case processed
    }

    public init(transactionId: String) {
        self.transactionId = transactionId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        let processedContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .processed)
        processed = processedContainer?.decodeDynamicKeyValues()
    }
}

/// Response struct for the `get_key_accounts` RPC endpoint
public struct EosioRpcKeyAccountsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?
    public var accountNames: [String] = [String]()

    enum CodingKeys: String, CodingKey {
        case accountNames = "account_names"
    }
}

/// Reponse type for `wait_weight` in RPC endpoint responses.
public struct WaitWeight: Decodable {
    public var waitSec: EosioUInt64
    public var weight: EosioUInt64

    enum CodingKeys: String, CodingKey {
        case waitSec = "wait_sec"
        case weight
    }
}

/// Response type for `permission_level` in RPC endpoint responses.
public struct PermissionLevel: Decodable {
    public var actor: String
    public var permission: String

    enum CodingKeys: String, CodingKey {
        case actor
        case permission
    }
}

/// Response type for `permission_level_weight in RPC endpoint responses.
public struct PermissionLevelWeight: Decodable {
    public var weight: EosioUInt64
    public var permission: PermissionLevel

    enum CodingKeys: String, CodingKey {
        case weight
        case permission
    }
}

/// Response type for `key_weight` structure in RPC endpoint responses.
public struct KeyWeight: Decodable {
    public var key: String
    public var weight: EosioUInt64

    enum CodingKeys: String, CodingKey {
        case key
        case weight
    }
}

/// Response type for `authority` structure in RPC endpoint responses.
public struct Authority: Decodable {
    public var threshold: EosioUInt64
    public var keys: [KeyWeight]
    public var waits: [WaitWeight]
    public var accounts: [PermissionLevelWeight]

    enum CodingKeys: String, CodingKey {
        case threshold
        case keys
        case waits
        case accounts
    }
}

/// Response type for `permission` structure in RPC endpoint responses.
public struct Permission: Decodable {
    public var permName: String
    public var parent: String
    public var requiredAuth: Authority

    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
        case requiredAuth = "required_auth"
    }
}

/// Response type for the `get_account` RPC endpoint.
public struct EosioRpcAccountResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var accountName: String
    public var headBlockNum: EosioUInt64 = EosioUInt64.uint64(0)
    public var headBlockTime: String = ""
    public var privileged: Bool = false
    public var lastCodeUpdate: String = ""
    public var created: String = ""
    public var coreLiquidBalance: String = ""
    public var ramQuota: EosioInt64 = EosioInt64.int64(0)
    public var netWeight: EosioInt64 = EosioInt64.int64(0)
    public var cpuWeight: EosioInt64 = EosioInt64.int64(0)
    public var netLimit: [String: Any]
    public var cpuLimit: [String: Any]
    public var ramUsage: EosioInt64 = EosioInt64.int64(0)
    public var permissions: [Permission]
    public var totalResources: [String: Any]?
    public var selfDelegatedBandwidth: [String: Any]?
    public var refundRequest: [String: Any]?
    public var voterInfo: [String: Any]?

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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        accountName = try container.decode(String.self, forKey: .accountName)
        headBlockNum = try container.decodeIfPresent(EosioUInt64.self, forKey: .headBlockNum) ?? EosioUInt64.uint64(0)
        headBlockTime = try container.decodeIfPresent(String.self, forKey: .headBlockTime) ?? ""
        privileged = try container.decodeIfPresent(Bool.self, forKey: .privileged) ?? false
        lastCodeUpdate = try container.decodeIfPresent(String.self, forKey: .lastCodeUpdate) ?? ""
        created = try container.decodeIfPresent(String.self, forKey: .created) ?? ""
        coreLiquidBalance = try container.decodeIfPresent(String.self, forKey: .coreLiquidBalance) ?? ""
        ramQuota = try container.decodeIfPresent(EosioInt64.self, forKey: .ramQuota) ?? EosioInt64.int64(0)
        netWeight = try container.decodeIfPresent(EosioInt64.self, forKey: .netWeight) ?? EosioInt64.int64(0)
        cpuWeight = try container.decodeIfPresent(EosioInt64.self, forKey: .cpuWeight) ?? EosioInt64.int64(0)

        // netLimit = try container.decodeIfPresent(JSONValue.self, forKey: .netLimit)?.toDictionary() ?? [String: Any]()

        let netLimitContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .netLimit)
        netLimit = netLimitContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let cpuLimitContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .cpuLimit)
        cpuLimit = cpuLimitContainer?.decodeDynamicKeyValues() ?? [String: Any]()

        ramUsage = try container.decodeIfPresent(EosioInt64.self, forKey: .ramUsage) ?? EosioInt64.int64(0)
        permissions = try container.decodeIfPresent([Permission].self, forKey: .permissions) ?? [Permission]()
        let totalResourcesContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .totalResources)
        totalResources = totalResourcesContainer?.decodeDynamicKeyValues()
        let selfDelegatedBandwidthContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .selfDelegatedBandwidth)
        selfDelegatedBandwidth = selfDelegatedBandwidthContainer?.decodeDynamicKeyValues()
        let refundRequestContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .refundRequest)
        refundRequest = refundRequestContainer?.decodeDynamicKeyValues()
        let voterInfoContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .voterInfo)
        voterInfo = voterInfoContainer?.decodeDynamicKeyValues()
    }
}

/// Response type for the `get_transaction` RPC endpoint.
public struct EosioRpcGetTransactionResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var id: String
    public var trx: [String: Any]
    public var blockTime: String
    public var blockNum: EosioUInt64
    public var lastIrreversibleBlock: EosioUInt64
    public var traces: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case id
        case trx
        case blockTime = "block_time"
        case blockNum = "block_num"
        case lastIrreversibleBlock = "last_irreversible_block"
        case traces
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        let trxContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .trx)
        trx = trxContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        blockTime = try container.decode(String.self, forKey: .blockTime)
        blockNum = try container.decode(EosioUInt64.self, forKey: .blockNum)
        lastIrreversibleBlock = try container.decode(EosioUInt64.self, forKey: .lastIrreversibleBlock)
        let tracesContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .traces)
        traces = tracesContainer?.decodeDynamicKeyValues() ?? [String: Any]()
    }
}

/// Response struct for the `get_currency_balance` RPC endpoint
public struct EosioRpcCurrencyBalanceResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var currencyBalance: [String]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        currencyBalance = try container.decode([String].self)
    }
}

/// Response type for the `Currency` RPC endpoint.
public struct CurrencyStats: Decodable {
    public var supply: String
    public var maxSupply: String
    public var issuer: String

    enum CodingKeys: String, CodingKey {
        case supply
        case maxSupply = "max_supply"
        case issuer
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        supply = try container.decode(String.self, forKey: .supply)
        maxSupply = try container.decode(String.self, forKey: .maxSupply)
        issuer = try container.decode(String.self, forKey: .issuer)
    }
}

/// Response type for the `get_currency_stats` RPC endpoint.
public struct EosioRpcCurrencyStatsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var symbol: String
    public var currencyStats: CurrencyStats

    private struct CustomCodingKeys: CodingKey { // to decode custom symbol key (i.e. "EOS")
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int?
        init?(intValue: Int) { return nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        symbol = container.allKeys.first?.stringValue ?? "EOS"
        currencyStats = try container.decode(CurrencyStats.self, forKey: CustomCodingKeys(stringValue: symbol)!)
    }
}

/// Response type for the `get_raw_code_and_abi` RPC endpoint.
public struct EosioRpcRawCodeAndAbiResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var accountName: String
    public var wasm: String
    public var abi: String

    enum CustomCodingKeys: String, CodingKey {
        case accountName = "account_name"
        case wasm
        case abi
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        accountName = try container.decode(String.self, forKey: .accountName)
        wasm = try container.decode(String.self, forKey: .wasm)
        abi = try container.decode(String.self, forKey: .abi)
    }
}
/// Response type for the `get_code` RPC endpoint.
public struct EosioRpcCodeResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var accountName: String
    public var codeHash: String
    public var wast: String
    public var wasm: String
    public var abi: [String: Any]?

    enum CustomCodingKeys: String, CodingKey {
        case accountName = "account_name"
        case codeHash = "code_hash"
        case wast
        case wasm
        case abi
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        accountName = try container.decode(String.self, forKey: .accountName)
        codeHash = try container.decode(String.self, forKey: .codeHash)
        wast = try container.decode(String.self, forKey: .wast)
        wasm = try container.decode(String.self, forKey: .wasm)

        let abiContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .abi)
        abi = abiContainer?.decodeDynamicKeyValues()
    }

}

/// Response type for the `get_abi` RPC endpoint.
public struct EosioRpcAbiResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var accountName: String
    public var abi: [String: Any]

    enum CustomCodingKeys: String, CodingKey {
        case accountName = "account_name"
        case abi
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        accountName = try container.decode(String.self, forKey: .accountName)
        let abiContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .abi)
        abi = abiContainer?.decodeDynamicKeyValues() ?? [String: Any]()
    }
}

/// Response struct for the rows returned in the `get_producers` RPC endpoint response.
public struct ProducerRows: Decodable {
    public var owner: String
    public var totalVotes: String
    public var producerKey: String
    public var isActive: Int
    public var url: String
    public var unpaidBlocks: EosioUInt64
    public var lastClaimTime: String
    public var location: UInt16

    enum CustomCodingKeys: String, CodingKey {
        case owner
        case totalVotes = "total_votes"
        case producerKey = "producer_key"
        case isActive = "is_active"
        case url
        case unpaidBlocks = "unpaid_blocks"
        case lastClaimTime = "last_claim_time"
        case location
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        owner = try container.decode(String.self, forKey: .owner)
        totalVotes = try container.decode(String.self, forKey: .totalVotes)
        producerKey = try container.decode(String.self, forKey: .producerKey)
        isActive = try container.decode(Int.self, forKey: .isActive)
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        unpaidBlocks = try container.decodeIfPresent(EosioUInt64.self, forKey: .unpaidBlocks) ?? EosioUInt64.uint64(0)
        lastClaimTime = try container.decodeIfPresent(String.self, forKey: .lastClaimTime) ?? ""
        location = try container.decodeIfPresent(UInt16.self, forKey: .location) ?? 0
    }
}

/// Response type for the `get_producers` RPC endpoint.
public struct EosioRpcProducersResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var rows: [ProducerRows]
    public var totalProducerVoteWeight: String
    public var more: String

    enum CustomCodingKeys: String, CodingKey {
        case rows
        case totalProducerVoteWeight = "total_producer_vote_weight"
        case more
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        rows = try container.decodeIfPresent([ProducerRows].self, forKey: .rows) ?? [ProducerRows]()
        totalProducerVoteWeight = try container.decode(String.self, forKey: .totalProducerVoteWeight)
        more = try container.decodeIfPresent(String.self, forKey: .more) ?? ""
    }
}

/// Response type for the `push_transactions` RPC endpoint.
public struct EosioRpcPushTransactionsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var transactionResponses: [EosioRpcTransactionResponse]

    public init(from decoder: Decoder) throws {
        transactionResponses = [EosioRpcTransactionResponse]()
        if var container = try? decoder.unkeyedContainer() {
            while container.isAtEnd == false {
                transactionResponses.append(try container.decode(EosioRpcTransactionResponse.self))
            }
        }
    }
}
/// Response struct for `header` struct returned in the `get_block_header_state` RPC endpoint response.
public struct EosioRpcBlockHeaderStateResponseHeader: Decodable {
    public let timestamp: String
    public let producer: String
    public let confirmed: UInt
    public let previous: String
    public let transactionMroot: String
    public let actionMroot: String
    public let scheduleVersion: UInt
    public let headerExtensions: [String]
    public let producerSignature: String

    enum CustomCodingKeys: String, CodingKey {
        case timestamp
        case producer
        case confirmed
        case previous
        case transactionMroot = "transaction_mroot"
        case actionMroot = "action_mroot"
        case scheduleVersion = "schedule_version"
        case headerExtensions = "header_extensions"
        case producerSignature = "producer_signature"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        timestamp = try container.decode(String.self, forKey: .timestamp)
        producer = try container.decode(String.self, forKey: .producer)
        confirmed = try container.decode(UInt.self, forKey: .confirmed)
        previous = try container.decode(String.self, forKey: .previous)
        transactionMroot = try container.decode(String.self, forKey: .transactionMroot)
        actionMroot = try container.decode(String.self, forKey: .actionMroot)
        scheduleVersion = try container.decode(UInt.self, forKey: .scheduleVersion)
        headerExtensions = try container.decode([String].self, forKey: .headerExtensions)
        producerSignature = try container.decode(String.self, forKey: .producerSignature)
    }

}

/// Response type for the `get_block_header_state` RPC endpoint.
public struct EosioRpcBlockHeaderStateResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var id: String
    public var blockNumber: EosioUInt64
    public var header: EosioRpcBlockHeaderStateResponseHeader
    public var dposProposedIrreversibleBlockNumber: EosioUInt64
    public var dposIrreversibleBlockNumber: EosioUInt64
    public var bftIrreversibleBlockNumber: EosioUInt64
    public var pendingScheduleLibNumber: EosioUInt64
    public var pendingScheduleHash: String
    public var pendingSchedule: [String: Any]
    public var activeSchedule: [String: Any]
    public var blockRootMerkle: [String: Any]
    public var blockSigningKey: String
    public var confirmCount: [EosioUInt64]
    public var confirmations: [EosioUInt64]
    public var producerToLastProduced: [Any]
    public var producerToLastImpliedIrb: [Any]

    enum CustomCodingKeys: String, CodingKey {
        case id
        case blockNumber = "block_num"
        case header
        case dposProposedIrreversibleBlockNumber = "dpos_proposed_irreversible_blocknum"
        case dposIrreversibleBlockNumber = "dpos_irreversible_blocknum"
        case bftIrreversibleBlockNumber = "bft_irreversible_blocknum"
        case pendingScheduleLibNumber = "pending_schedule_lib_num"
        case pendingScheduleHash = "pending_schedule_hash"
        case pendingSchedule = "pending_schedule"
        case activeSchedule = "active_schedule"
        case blockRootMerkle = "blockroot_merkle"
        case blockSigningKey = "block_signing_key"
        case confirmCount = "confirm_count"
        case confirmations
        case producerToLastProduced = "producer_to_last_produced"
        case producerToLastImpliedIrb = "producer_to_last_implied_irb"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        blockNumber = try container.decode(EosioUInt64.self, forKey: .blockNumber)
        header = try container.decode(EosioRpcBlockHeaderStateResponseHeader.self, forKey: .header)
        dposProposedIrreversibleBlockNumber = try container.decode(EosioUInt64.self, forKey: .dposProposedIrreversibleBlockNumber)
        dposIrreversibleBlockNumber = try container.decode(EosioUInt64.self, forKey: .dposIrreversibleBlockNumber)
        bftIrreversibleBlockNumber = try container.decode(EosioUInt64.self, forKey: .bftIrreversibleBlockNumber)
        pendingScheduleLibNumber = try container.decode(EosioUInt64.self, forKey: .pendingScheduleLibNumber)
        pendingScheduleHash = try container.decode(String.self, forKey: .pendingScheduleHash)

        let pendingScheduleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .pendingSchedule)
        pendingSchedule = pendingScheduleContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let activeScheduleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .activeSchedule)
        activeSchedule = activeScheduleContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let blockRootMerkleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .blockRootMerkle)
        blockRootMerkle = blockRootMerkleContainer?.decodeDynamicKeyValues() ?? [String: Any]()

        blockSigningKey = try container.decode(String.self, forKey: .blockSigningKey)
        confirmCount = try container.decode([EosioUInt64].self, forKey: .confirmCount)
        confirmations = try container.decode([EosioUInt64].self, forKey: .confirmations)

        var nestedProducerToLast = try? container.nestedUnkeyedContainer(forKey: .producerToLastProduced)
        producerToLastProduced = nestedProducerToLast?.decodeDynamicValues() ?? [Any]()

        var nestedProducerToLastImply = try? container.nestedUnkeyedContainer(forKey: .producerToLastImpliedIrb)
        producerToLastImpliedIrb = nestedProducerToLastImply?.decodeDynamicValues() ?? [Any]()
    }

}

/* History Endpoints */
/// Response type for the `get_actions` RPC endpoint.
public struct EosioRpcActionsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var actions: [EosioRpcActionsResponseAction]
    public var lastIrreversibleBlock: EosioUInt64
    public var timeLimitExceededError: Bool

    enum CustomCodingKeys: String, CodingKey {
        case actions
        case lastIrreversibleBlock = "last_irreversible_block"
        case timeLimitExceededError = "time_limit_exceeded_error"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        actions = try container.decode([EosioRpcActionsResponseAction].self, forKey: .actions)
        lastIrreversibleBlock = try container.decode(EosioUInt64.self, forKey: .lastIrreversibleBlock)
        timeLimitExceededError = try container.decodeIfPresent(Bool.self, forKey: .timeLimitExceededError) ?? false
    }
}

public struct EosioRpcActionsResponseAction: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var globalActionSequence: EosioUInt64
    public var accountActionSequence: Int32
    public var blockNumber: UInt32
    public var blockTime: String
    public var actionTrace: EosioRpcActionsResponseActionTrace

    enum CustomCodingKeys: String, CodingKey {
        case globalActionSequence = "global_action_seq"
        case accountActionSequence = "account_action_seq"
        case blockNumber = "block_num"
        case blockTime = "block_time"
        case actionTrace = "action_trace"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        globalActionSequence = try container.decode(EosioUInt64.self, forKey: .globalActionSequence)
        accountActionSequence = try container.decode(Int32.self, forKey: .accountActionSequence)
        blockNumber = try container.decode(UInt32.self, forKey: .blockNumber)
        blockTime = try container.decode(String.self, forKey: .blockTime)
        actionTrace = try container.decode(EosioRpcActionsResponseActionTrace.self, forKey: .actionTrace)
    }
}

public struct EosioRpcActionsResponseActionTrace: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var receipt: EosioRpcActionsResponseActionTrReceipt
    public var action: EosioRpcActionsResponseActionTraceAction
    public var contextFree: Bool
    public var elapsed: EosioUInt64
    public var console: String
    public var transactionId: String
    public var blockNumber: EosioUInt64
    public var blockTime: String
    public var producerBlockId: String?
    public var accountRamDeltas: [EosioRpcActionsResponseActionTrActDeltas]
    public var exception: [String: Any]?

    enum CustomCodingKeys: String, CodingKey {
        case receipt
        case action = "act"
        case contextFree = "context_free"
        case elapsed = "elapsed"
        case console = "console"
        case transactionId = "trx_id"
        case blockNumber = "block_num"
        case blockTime = "block_time"
        case producerBlockId = "producer_block_id"
        case accountRamDeltas = "account_ram_deltas"
        case exception = "except"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        receipt = try container.decode(EosioRpcActionsResponseActionTrReceipt.self, forKey: .receipt)
        action = try container.decode(EosioRpcActionsResponseActionTraceAction.self, forKey: .action)
        contextFree = try container.decode(Bool.self, forKey: .contextFree)
        elapsed = try container.decode(EosioUInt64.self, forKey: .elapsed)
        console = try container.decode(String.self, forKey: .console)
        transactionId = try container.decode(String.self, forKey: .transactionId)
        blockNumber = try container.decode(EosioUInt64.self, forKey: .blockNumber)
        blockTime = try container.decode(String.self, forKey: .blockTime)
        producerBlockId = try container.decodeIfPresent(String.self, forKey: .producerBlockId)
        accountRamDeltas = try container.decode([EosioRpcActionsResponseActionTrActDeltas].self, forKey: .accountRamDeltas)

        let exceptionContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .exception)
        exception = exceptionContainer?.decodeDynamicKeyValues() ?? [String: Any]()
    }
}

public struct EosioRpcActionsResponseActionTrReceipt: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var receiver: String
    public var actionDigest: String
    public var globalSequence: EosioUInt64
    public var receiverSequence: EosioUInt64
    public var authorizationSequence: [Any]
    public var codeSequence: EosioUInt64
    public var abiSequence: EosioUInt64

    enum CustomCodingKeys: String, CodingKey {
        case receiver
        case actionDigest = "act_digest"
        case globalSequence = "global_sequence"
        case receiveSequence = "recv_sequence"
        case authorizationSequence = "auth_sequence"
        case codeSequence = "code_sequence"
        case abiSequence = "abi_sequence"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        receiver = try container.decode(String.self, forKey: .receiver)
        actionDigest = try container.decode(String.self, forKey: .actionDigest)
        globalSequence = try container.decode(EosioUInt64.self, forKey: .globalSequence)
        receiverSequence = try container.decode(EosioUInt64.self, forKey: .receiveSequence)
        var authorizationSequenceContainer = try? container.nestedUnkeyedContainer(forKey: .authorizationSequence)
        authorizationSequence = authorizationSequenceContainer?.decodeDynamicValues() ?? [Any]()
        codeSequence = try container.decode(EosioUInt64.self, forKey: .codeSequence)
        abiSequence = try container.decode(EosioUInt64.self, forKey: .abiSequence)
    }
}

public struct EosioRpcActionsResponseActionTraceAction: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var account: String
    public var name: String
    public var authorization: [EosioRpcActionsResponseActionTraceAuth]
    public var data: [String: Any]
    public var hexData: String?

    enum CustomCodingKeys: String, CodingKey {
        case account
        case name
        case authorization
        case data
        case hexData = "hex_data"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        account = try container.decode(String.self, forKey: .account)
        name = try container.decode(String.self, forKey: .name)
        authorization = try container.decode([EosioRpcActionsResponseActionTraceAuth].self, forKey: .authorization)
        let dataContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .data)
        data = dataContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        hexData = try? container.decode(String.self, forKey: .hexData)
    }
}

public struct EosioRpcActionsResponseActionTraceAuth: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var actor: String
    public var permission: String

    enum CustomCodingKeys: String, CodingKey {
        case actor
        case permission
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        actor = try container.decode(String.self, forKey: .actor)
        permission = try container.decode(String.self, forKey: .permission)
    }
}

public struct EosioRpcActionsResponseActionTrActDeltas: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    public var account: String
    public var delta: EosioInt64

    enum CustomCodingKeys: String, CodingKey {
        case account
        case delta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        account = try container.decode(String.self, forKey: .account)
        delta = try container.decode(EosioInt64.self, forKey: .delta)
    }
}

/// Response struct for the `get_controlled_accounts` RPC endpoint
public struct EosioRpcControlledAccountsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?
    public var controlledAccounts: [String] = [String]()

    enum CodingKeys: String, CodingKey {
        case controlledAccounts = "controlled_accounts"
    }
}

/// Response type for the `get_table_rows` RPC endpoint.
public struct EosioRpcTableRowsResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?
    public var rows: [Any] = [Any]()
    public var more: Bool

    enum CustomCodingKeys: String, CodingKey {
        case rows
        case more
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        var rowsContainer = try? container.nestedUnkeyedContainer(forKey: .rows)
        rows = rowsContainer?.decodeDynamicValues() ?? [Any]()
        more = try container.decodeIfPresent(Bool.self, forKey: .more) ?? false
    }
}

/// Response struct for the rows returned from get_table_by_scope
public struct TableByScopeRows: Decodable {
    public var code: String
    public var scope: String
    public var table: String
    public var payer: String
    public var count: UInt32
}

/// Response type for the `get_table_by_scope` RPC endpoint.
public struct EosioRpcTableByScopeResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?
    public var rows: [TableByScopeRows] = [TableByScopeRows]()
    public var more: String

    enum CustomCodingKeys: String, CodingKey {
        case rows
        case more
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        rows = try container.decode([TableByScopeRows].self, forKey: .rows)
        more = try container.decodeIfPresent(String.self, forKey: .more) ?? ""
    }
}

/* Responses without response models */

/// Struct for response types which do not have models created for them. For those, we simply provide the `_rawResponse`.
public struct RawResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    enum CodingKeys: CodingKey {
    }
}

/* History Endpoints */
