//
//  EosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation
import EosioSwiftC

public class EosioTransaction: Codable {
    
    public var chainId = ""
    
    public var abis = [EosioName:String]()
    
    public var id: String?
    public var blockNum: UInt64?
    
    public var expiration = Date(timeIntervalSince1970: 0)
    public var refBlockNum:  UInt16 = 0
    public var refBlockPrefix: UInt64 = 0
    public var maxNetUsageWords: UInt = 0
    public var maxCpuUsageMs: UInt = 0
    public var delaySec: UInt = 0
    public var contextFreeActions = [String]()
    public var actions = [Action]()
    public var transactionExtensions = [String]()
    
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        case expiration
        case refBlockNum
        case refBlockPrefix
        case maxNetUsageWords
        case maxCpuUsageMs
        case delaySec
        case contextFreeActions
        case actions
        case transactionExtensions
    }
    
    
    /// Returns an array of action accounts that do not have an abi in `abis`
    public var actionAccountsMissingAbis: [EosioName] {
        var accounts = [EosioName]()
        for action in actions {
            if abis[action.account] == nil, !accounts.contains(action.account) {
                accounts.append(action.account)
            }
        }
        return accounts
    }
    
    
    /// Returns an array of actions that do not have serialized data
    public var actionsWithoutSerializedData: [Action] {
        return actions.filter { (action) -> Bool in
            !action.isDataSerialized
        }
    }
    
    
    /// Encode the transaction as a json string. Properties will be snake_case. Action data will be serialized.
    func toJson(prettyPrinted: Bool = false) throws -> String {
        return try self.toJsonString(convertToSnakeCase: true, prettyPrinted: prettyPrinted)
    }
    
    
    /**
     Serializes the transaction using `Abieos` and returns a `SerializedEosioTransaction` struct. Serializing a transaction requires the `serializedData` property for all the actions to have a value and the tapos properties (`refBlockNum`, `refBlockPrefix`, `expiration`) to have valid values. If the necessary data is not known to be set, call the async version method of this method which will attempt to get the necessary data first.
     - Returns: A `SerializedEosioTransaction` struct
     - Throws: If any of the necessary data is missing, or transaction cannot be serialized.
     */
    public func toSerializedEosioTransaction() throws -> SerializedEosioTransaction {
        try serializeActionData()
        guard refBlockNum > 0 else {
            throw EosioError(.serializationError, reason: "refBlockNum is not set")
        }
        guard refBlockPrefix > 0 else {
            throw EosioError(.serializationError, reason: "refBlockPrefix is not set")
        }
        guard expiration > Date(timeIntervalSince1970: 0) else {
            throw EosioError(.serializationError, reason: "expiration is not set")
        }
        var serializedEosioTransaction = SerializedEosioTransaction()
        let abieos = AbiEos()
        let json = try self.toJson()
        serializedEosioTransaction.packedTrx = try abieos.jsonToHex(contract: nil, type: "transaction", json: json, abi: "transaction.abi.json", isReorderable: true)
        return serializedEosioTransaction
    }
    
    
    /**
     Serializes the `data` property of each action in `actions` and sets the `serializedData` property for each action, if not alredy set. Serializing the action data requires abis to be available in the `abis` dictionary for all the contracts in the actions. If the necessary abis are not known to be set, call the async version method of this method which will attempt to get the abis first.
     - Throws: If any required abis are not available, or the action `data` cannot be serialized.
     */
    public func serializeActionData() throws {
        let missingAbis = actionAccountsMissingAbis
        guard missingAbis.count == 0 else {
            throw EosioError(.serializationError, reason: "Cannot serialize action data. Abis missing for \(missingAbis).")
        }
        for action in actions {
            try action.serializeData(abi: abis[action.account] ?? "")
        }
    }
    
    
}
