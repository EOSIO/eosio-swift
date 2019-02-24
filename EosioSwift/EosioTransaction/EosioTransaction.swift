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
    
    public var rpcProvider: RpcProviderProtocol?
    public var signatureProvider: EosioSignatureProviderProtocol?
    
    public var taposConfig = EosioTransaction.TaposConfig()
    public struct TaposConfig {
        public var blocksBehind: UInt = 3
        public var expireSeconds: UInt = 60 * 5
    }
    
    public let abis = Abis()
    
    public var transactionId: String?
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
        let accounts = actions.compactMap { (action) -> EosioName in
            return action.account
        }
        return abis.missingAbis(names: accounts)
    }
    
    
    /// Returns an array of actions that do not have serialized data
    public var actionsWithoutSerializedData: [Action] {
        return actions.filter { (action) -> Bool in
            !action.isDataSerialized
        }
    }
    
    
    /// Encode the transaction as a json string. Properties will be snake_case. Action data will be serialized.
    ///
    /// - Parameter prettyPrinted: Should the json be pretty printed? (default = no)
    /// - Returns: The transaction as a json string
    /// - Throws: If the transaction cannot be encoded to json
    public func toJson(prettyPrinted: Bool = false) throws -> String {
        return try self.toJsonString(convertToSnakeCase: true, prettyPrinted: prettyPrinted)
    }
    
    
    /**
     Serializes the transaction and returns a `EosioTransactionRequest` struct with the `packedTrx` property set. Serializing a transaction requires the `serializedData` property for all the actions to have a value and the tapos properties (`refBlockNum`, `refBlockPrefix`, `expiration`) to have valid values. If the necessary data is not known to be set, call the async version method of this method which will attempt to get the necessary data first.
     - Returns: A `EosioTransactionRequest` struct
     - Throws: If any of the necessary data is missing, or transaction cannot be serialized.
     */
    public func toEosioTransactionRequest() throws -> EosioTransactionRequest {
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
        var eosioTransactionRequest = EosioTransactionRequest()
        let abieos = AbiEos()
        let json = try self.toJson()
        eosioTransactionRequest.packedTrx = try abieos.jsonToHex(contract: nil, type: "transaction", json: json, abi: "transaction.abi.json", isReorderable: true)
        return eosioTransactionRequest
    }
    
    
    /**
     Serializes the `data` property of each action in `actions` and sets the `serializedData` property for each action, if not alredy set. Serializing the action data requires abis to be available in the `abis` class for all the contracts in the actions. If the necessary abis are not known to be available, call the async version method of this method which will attempt to get the abis first.
     - Throws: If any required abis are not available, or the action `data` cannot be serialized.
     */
    public func serializeActionData() throws {
        let missingAbis = actionAccountsMissingAbis
        guard missingAbis.count == 0 else {
            throw EosioError(.serializationError, reason: "Cannot serialize action data. Abis missing for \(missingAbis).")
        }
        for action in actions {
            try action.serializeData(abi: abis.jsonAbi(name: action.account))
        }
    }
    
    /// Calculate the `expiration` using `taposConfig.expireSeconds` if current `expiration` is not valid
    public func calculateExpiration() {
        if expiration < Date() {
            expiration = Date().addingTimeInterval(TimeInterval(self.taposConfig.expireSeconds))
        }
    }

    
    /**
     This method will get the `chainId`, `info` and `block`, set the `chainId` property then calculate and set `refBlockNum` and `refBlockPrefix` using the `taposConfig` property. If the `chainId` is already set this method will validate against the `chainId` retreived from the `rpcProvider` and return a error if they do not do not match. If `chainId`, `refBlockNum`, and `refBlockPrefix` already have valid values this method will call the completion with `true`. If these properties do not have valid values, this method will require the `taposConfig` property to be set and an `rpcProvider` to get the data necessary to get or calculate these values. If either the `taposConfig` or the `rpcProvider` are not set or another error is encountered this method will call the completion with an error.
    */
    public func getChainIdAndCalculateTapos(completion: @escaping (EosioResult<Bool>) -> Void) {
        
        // if all the data is set just return true
        if refBlockNum > 0 && refBlockPrefix > 0  && chainId != "" {
            return completion(.success(true))
        }
        
        // if no rpcProvider available, return error
        guard let rpcProvider = rpcProvider else {
            return completion(.error(EosioError(.transactionError, reason: "No rpc provider available")))
        }
        
        // get chain info
        rpcProvider.getInfo { (infoResponse) in
            switch infoResponse {
            case .error(let error):
                completion(.error(error))
            case .empty:
                completion(.error(EosioError(.unexpectedError, reason: "")))
            case .success(let info):
                if self.chainId == "" {
                    self.chainId = info.chainId
                }
                // return an error if provided chainId does not match info chainID
                guard self.chainId == info.chainId else {
                    return completion(.error(EosioError(.transactionError, reason:"Provided chain id \(self.chainId) does not match chain id \(info.chainId)")))
                }
                // if the only data needed was the chainId, return now
                if self.refBlockPrefix > 0 && self.refBlockNum > 0 {
                    return completion(.success(true))
                }
                var blocksBehind = UInt64(self.taposConfig.blocksBehind)
                if blocksBehind > info.headBlockNum {
                    blocksBehind = info.headBlockNum
                }
                let blockNum = info.headBlockNum - blocksBehind
                rpcProvider.getBlock(blockNum: blockNum, completion: { (blockResponse) in
                    switch blockResponse {
                    case .error(let error):
                        completion(.error(error))
                    case .empty:
                        completion(.error(EosioError(.unexpectedError, reason: "")))
                    case .success(let block):
                        // set tapos fields and return
                        self.refBlockNum = UInt16(block.blockNum & 0xffff)
                        self.refBlockPrefix = block.refBlockPrefix
                        return completion(.success(true))
                    }
                })
            }
        }
        
       
       
    }
}
