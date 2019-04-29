//
//  ResponseModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

/// Response struct for the `get_info` RPC endpoint.
public struct EosioRpcInfoResponse: EosioRpcInfoResponseProtocol, EosioRpcResponseProtocol, Decodable {
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        serverVersion = try container.decodeIfPresent(String.self, forKey: .serverVersion) ?? ""
        chainId = try container.decode(String.self, forKey: .chainId)
        headBlockNum = try container.decode(UInt64.self, forKey: .headBlockNum)
        lastIrreversibleBlockNum = try container.decode(UInt64.self, forKey: .lastIrreversibleBlockNum)
        lastIrreversibleBlockId = try container.decode(String.self, forKey: .lastIrreversibleBlockId)
        headBlockId = try container.decode(String.self, forKey: .headBlockId)
        headBlockTime = try container.decode(String.self, forKey: .headBlockTime)
        headBlockProducer = try container.decodeIfPresent(String.self, forKey: .headBlockProducer) ?? ""
        virtualBlockCpuLimit = try container.decodeIfPresent(UInt64.self, forKey: .virtualBlockCpuLimit) ?? 0
        virtualBlockNetLimit = try container.decodeIfPresent(UInt64.self, forKey: .virtualBlockNetLimit) ?? 0
        blockCpuLimit = try container.decodeIfPresent(UInt64.self, forKey: .blockCpuLimit) ?? 0
        blockNetLimit = try container.decodeIfPresent(UInt64.self, forKey: .blockNetLimit) ?? 0
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
        blockNum = try container.decode(UInt64.self, forKey: .blockNum)
        refBlockPrefix = try container.decode(UInt64.self, forKey: .refBlockPrefix)
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
    public var waitSec: UInt64
    public var weight: UInt64

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
    public var weight: UInt64
    public var accounts: [PermissionLevel]

    enum CodingKeys: String, CodingKey {
        case weight
        case accounts
    }
}

/// Response type for `key_weight` structure in RPC endpoint responses.
public struct KeyWeight: Decodable {
    public var key: String
    public var weight: UInt64

    enum CodingKeys: String, CodingKey {
        case key
        case weight
    }
}

/// Response type for `authority` structure in RPC endpoint responses.
public struct Authority: Decodable {
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
public struct Permission: Decodable {
    public var permName: String
    public var parent: String

    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
    }
}

/// Response type for the `get_account` RPC endpoint.
public struct EosioRpcAccountResponse: Decodable, EosioRpcResponseProtocol {
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
    public var netLimit: [String: Any]
    public var cpuLimit: [String: Any]
    public var ramUsage: UInt64 = 0
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
        headBlockNum = try container.decodeIfPresent(UInt64.self, forKey: .headBlockNum) ?? 0
        headBlockTime = try container.decodeIfPresent(String.self, forKey: .headBlockTime) ?? ""
        privileged = try container.decodeIfPresent(Bool.self, forKey: .privileged) ?? false
        lastCodeUpdate = try container.decodeIfPresent(String.self, forKey: .lastCodeUpdate) ?? ""
        created = try container.decodeIfPresent(String.self, forKey: .created) ?? ""
        coreLiquidBalance = try container.decodeIfPresent(String.self, forKey: .coreLiquidBalance) ?? ""
        ramQuota = try container.decodeIfPresent(UInt64.self, forKey: .ramQuota) ?? 0
        netWeight = try container.decodeIfPresent(UInt64.self, forKey: .netWeight) ?? 0
        cpuWeight = try container.decodeIfPresent(UInt64.self, forKey: .cpuWeight) ?? 0

        // netLimit = try container.decodeIfPresent(JSONValue.self, forKey: .netLimit)?.toDictionary() ?? [String: Any]()

        let netLimitContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .netLimit)
        netLimit = netLimitContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let cpuLimitContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .cpuLimit)
        cpuLimit = cpuLimitContainer?.decodeDynamicKeyValues() ?? [String: Any]()

        ramUsage = try container.decodeIfPresent(UInt64.self, forKey: .ramUsage) ?? 0
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
    public var blockNum: UInt64
    public var lastIrreversibleBlock: UInt64
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
        blockNum = try container.decode(UInt64.self, forKey: .blockNum)
        lastIrreversibleBlock = try container.decode(UInt64.self, forKey: .lastIrreversibleBlock)
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
    public var unpaidBlocks: UInt64
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
        unpaidBlocks = try container.decodeIfPresent(UInt64.self, forKey: .unpaidBlocks) ?? 0
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
    public var blockNumber: UInt64
    public var header: EosioRpcBlockHeaderStateResponseHeader
    public var dposProposedIrreversibleBlockNumber: UInt64
    public var dposIrreversibleBlockNumber: UInt64
    public var bftIrreversibleBlockNumber: UInt64
    public var pendingScheduleLibNumber: UInt64
    public var pendingScheduleHash: String
    public var pendingSchedule: [String: Any]
    public var activeSchedule: [String: Any]
    public var blockRootMerkle: [String: Any]
    public var blockSigningKey: String
    public var confirmCount: [UInt64]
    public var confirmations: [UInt64]
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
        blockNumber = try container.decode(UInt64.self, forKey: .blockNumber)
        header = try container.decode(EosioRpcBlockHeaderStateResponseHeader.self, forKey: .header)
        dposProposedIrreversibleBlockNumber = try container.decode(UInt64.self, forKey: .dposProposedIrreversibleBlockNumber)
        dposIrreversibleBlockNumber = try container.decode(UInt64.self, forKey: .dposIrreversibleBlockNumber)
        bftIrreversibleBlockNumber = try container.decode(UInt64.self, forKey: .bftIrreversibleBlockNumber)
        pendingScheduleLibNumber = try container.decode(UInt64.self, forKey: .pendingScheduleLibNumber)
        pendingScheduleHash = try container.decode(String.self, forKey: .pendingScheduleHash)

        let pendingScheduleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .pendingSchedule)
        pendingSchedule = pendingScheduleContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let activeScheduleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .activeSchedule)
        activeSchedule = activeScheduleContainer?.decodeDynamicKeyValues() ?? [String: Any]()
        let blockRootMerkleContainer = try? container.nestedContainer(keyedBy: DynamicKey.self, forKey: .blockRootMerkle)
        blockRootMerkle = blockRootMerkleContainer?.decodeDynamicKeyValues() ?? [String: Any]()

        blockSigningKey = try container.decode(String.self, forKey: .blockSigningKey)
        confirmCount = try container.decode([UInt64].self, forKey: .confirmCount)
        confirmations = try container.decode([UInt64].self, forKey: .confirmations)

        var nestedProducerToLast = try? container.nestedUnkeyedContainer(forKey: .producerToLastProduced)
        producerToLastProduced = nestedProducerToLast?.decodeDynamicValues() ?? [Any]()

        var nestedProducerToLastImply = try? container.nestedUnkeyedContainer(forKey: .producerToLastImpliedIrb)
        producerToLastImpliedIrb = nestedProducerToLastImply?.decodeDynamicValues() ?? [Any]()
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

/* Responses without response models */

/// Struct for response types which do not have models created for them. For those, we simply provide the `_rawResponse`.
public struct RawResponse: Decodable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    enum CodingKeys: CodingKey {
    }
}

/// Response type for the `get_table_by_scope` RPC endpoint.
public typealias EosioRpcTableByScopeResponse = RawResponse

/// Response type for the `get_table_rows` RPC endpoint.
public typealias EosioRpcTableRowsResponse = RawResponse

/* History Endpoints */

/// Response type for the `get_actions` RPC endpoint.
public typealias EosioRpcActionsResponse = RawResponse
