//
//  EosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation

public class EosioTransaction {
    
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
    
    /// Retuns an array of actions that do not have serialized data
    public var actionsWithoutSerializedData: [Action] {
        return actions.filter { (action) -> Bool in
            !action.isDataSerialized
        }
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
