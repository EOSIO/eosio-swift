//
//  ResponseModels.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioRpcInfoResponse: Codable {
    public var serverVersion: String
    public var chainId: String
    public var headBlockNum: UInt64
    public var lastIrreversibleBlockNum: UInt64
    public var lastIrreversibleBlockId: String
    public var headBlockId: String
    public var headBlockTime: String
    public var headBlockProducer: String
    public var virtualBlockCpuLimit: UInt64
    public var virtualBlockNetLimit: UInt64
    public var blockCpuLimit: UInt64
    public var blockNetLimit: UInt64
    public var serverVersionString: String
    
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
    
    public init(serverVersion: String, chainId: String, headBlockNum: UInt64, lastIrreversibleBlockNum: UInt64,
                lastIrreversibleBlockId: String, headBlockId: String, headBlockTime: String, headBlockProducer: String,
                virtualBlockCpuLimit: UInt64, virtualBlockNetLimit: UInt64, blockCpuLimit: UInt64, blockNetLimit: UInt64,
                serverVersionString: String) {
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

public struct EosioRpcTrxResponse: Codable {
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

public struct EosioRpcTransactionInfoResponse: Codable {
    public var status: String
    public var cpuUsageUs: UInt
    public var netUsageWords: UInt
    public var trx: EosioRpcTrxResponse
    
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

public struct EosioRpcBlockResponse: Codable {
    public var timestamp: String
    public var producer: String
    public var confirmed: UInt
    public var previous: String
    public var transactionMroot: String
    public var actionMroot: String
    public var scheduleVersion: UInt
    public var newProducers: String?
    public var headerExtensions: [String]
    public var producerSignature: String
    public var transactions: [EosioRpcTransactionInfoResponse]
    public var blockExtensions: [String]
    public var id: String
    public var blockNum: UInt64
    public var refBlockPrefix: UInt64
    
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
    
    public init(timestamp: String, producer: String, confirmed: UInt, previous: String, transactionMroot: String,
                actionMroot: String, scheduleVersion: UInt, newProducers: String?, headerExtensions: [String],
                producerSignature: String, transactions: [EosioRpcTransactionInfoResponse], blockExtensions: [String],
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
}

public struct EosioRpcRawAbiResponse: Codable {
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

public struct EosioRpcRawCodeAbiResponse: Codable {
    //TODO: implement
}
public struct EosioRpcRequiredKeysResponse: Codable {
    public var requiredKeys: [String]
   
    
    enum CodingKeys: String, CodingKey {
        case requiredKeys = "required_keys"
    }
    
    public init(requiredKeys: [String]) {
        self.requiredKeys = requiredKeys
    }
}


public struct EosioRpcTransactionResponse : Codable {
    public var tranactionId: String
    
    enum CodingKeys: String, CodingKey {
        case tranactionId = "transaction_id"
    }
    
    public init(tranactionId: String) {
        self.tranactionId = tranactionId
    }
}

public struct EosioRpcHistoryActionsResponse: Codable {
     //TODO: fill in impl
}

public struct EosioRpcBlockHeaderStateResponse: Codable {
    
    //TODO: fill in impl
    
}

public struct EosioRpcAccountResponse: Codable {
    //TODO: fill in impl
}

public struct EosioRpcTableRowsResponse: Codable {
     //TODO: fill in impl
}

public struct EosioRpcCurrencyStatsResponse: Codable {
    //TODO: fill in impl
}

public struct EosioRpcProducersResponse: Codable {
    //TODO: fill in impl
}

public struct EosioRpcHistoryTransactionResponse: Codable {
    //TODO: fill in impl
}

public struct EosioRpcHistoryKeyAccountsResponse: Codable {
   //TODO: fill in impl
}

public struct EosioRpcControllingAccountsResponse: Codable {
   //TODO: fill in impl
}



