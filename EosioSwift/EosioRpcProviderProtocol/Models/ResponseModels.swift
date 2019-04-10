//
//  ResponseModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioRpcInfoResponse: EosioRpcInfoResponseProtocol, RawResponseConvertible, Codable {

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

public struct EosioRpcTrxResponse: RawResponseConvertible, Codable {
    public var id: String
    public var signatures: [String]
    public var compression: String
    public var packedContextFreeData: String
    public var contextFreeData: [String]
    public var packedTrx: String
    public var transaction: EosioRpcTransactionResponse

    enum CodingKeys: String, CodingKey {
        case id
        case signatures
        case compression
        case packedContextFreeData = "packed_context_free_data"
        case contextFreeData = "context_free_data"
        case packedTrx = "packed_trx"
        case transaction
    }

    public init(id: String, signatures: [String], compression: String, packedContextFreeData: String,
                contextFreeData: [String], packedTrx: String, transaction: EosioRpcTransactionResponse) {
        self.id = id
        self.signatures = signatures
        self.compression = compression
        self.packedContextFreeData = packedContextFreeData
        self.contextFreeData = contextFreeData
        self.packedTrx = packedTrx
        self.transaction = transaction

    }
}

public struct EosioRpcTransactionInfoResponse: RawResponseConvertible, Codable {
    public let status: String
    public let cpuUsageUs: UInt
    public let netUsageWords: UInt
    public let trx: EosioRpcTrxResponse

    enum CodingKeys: String, CodingKey {
        case status
        case cpuUsageUs = "cpu_usage_us"
        case netUsageWords = "net_usage_words"
        case trx
    }

    public init(status: String, cpuUsageUs: UInt, netUsageWords: UInt, trx: EosioRpcTrxResponse) {
        self.status = status
        self.cpuUsageUs = cpuUsageUs
        self.netUsageWords = netUsageWords
        self.trx = trx
    }
}

public struct EosioRpcBlockResponse: EosioRpcBlockResponseProtocol, RawResponseConvertible, Codable {

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

public struct EosioRpcRawAbiResponse: EosioRpcRawAbiResponseProtocol, RawResponseConvertible, Codable {
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

public struct EosioRpcRequiredKeysResponse: EosioRpcRequiredKeysResponseProtocol, RawResponseConvertible, Codable {
    public var requiredKeys: [String]

    enum CodingKeys: String, CodingKey {
        case requiredKeys = "required_keys"
    }

    public init(requiredKeys: [String]) {
        self.requiredKeys = requiredKeys
    }
}

public struct EosioRpcTransactionResponse: EosioRpcTransactionResponseProtocol, RawResponseConvertible, Codable {
    public var transactionId: String

    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
    }

    public init(transactionId: String) {
        self.transactionId = transactionId
    }
}
