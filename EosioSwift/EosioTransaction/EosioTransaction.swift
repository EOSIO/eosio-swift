//
//  EosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public class EosioTransaction: Codable {

    public var chainId = ""

    public var rpcProvider: EosioRpcProviderProtocol?
    public var abiProvider: EosioAbiProviderProtocol?
    public var signatureProvider: EosioSignatureProviderProtocol?
    public var serializationProvider: EosioSerializationProviderProtocol? {
        didSet {
            abis.serializationProvider = serializationProvider
        }
    }

    public var config = EosioTransaction.Config()
    public struct Config {
        public var blocksBehind: UInt = 3
        public var expireSeconds: UInt = 60 * 5
    }
    public var allowSignatureProviderToModifyTransaction = true

    public let abis = Abis()

    public var expiration = Date(timeIntervalSince1970: 0)
    public var refBlockNum: UInt16 = 0
    public var refBlockPrefix: UInt64 = 0
    public var maxNetUsageWords: UInt = 0
    public var maxCpuUsageMs: UInt = 0
    public var delaySec: UInt = 0
    public var contextFreeActions = [String]()
    public var actions = [Action]()
    public var transactionExtensions = [String]()

    public private(set) var serializedTransaction: Data?
    public private(set) var signatures: [String]?
    public private(set) var transactionId: String?

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

    public init() {  }

    /// Deserialize a serialized transaction and return a `EosioTransaction` object.
    ///
    /// - Parameters:
    ///   - serializedTransaction: A serialized transaction
    ///   - serializationProvider: A serializationProvider, will be set as the serializationProvider for the `EosioTransaction`
    /// - Returns: An `EosioTransaction`
    /// - Throws: If the transaction cannot be deserialized
    static public func deserialize(_ serializedTransaction: Data, serializationProvider: EosioSerializationProviderProtocol) throws -> EosioTransaction {
        let json = try serializationProvider.deserializeTransaction(hex: serializedTransaction.hex)
        guard let data = json.data(using: .utf8) else {
            throw EosioError(.deserializeError, reason: "Cannot create json from data")
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let transaction = try jsonDecoder.decode(EosioTransaction.self, from: data)
        transaction.serializationProvider = serializationProvider
        return transaction
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
     Serializes the transaction and returns a `Data` object. Serializing a transaction requires the `serializedData` property for all the actions
     to have a value and the tapos properties (`refBlockNum`, `refBlockPrefix`, `expiration`) to have valid values. If the necessary data is not
     known to be set, call the async version method of this method which will attempt to get the necessary data first.
     - Returns: A `Data` object
     - Throws: If any of the necessary data is missing, or transaction cannot be serialized.
     */
    public func serializeTransaction() throws -> Data {
        try serializeActionData()
        guard refBlockNum > 0 else {
            throw EosioError(.serializeError, reason: "refBlockNum is not set")
        }
        guard refBlockPrefix > 0 else {
            throw EosioError(.serializeError, reason: "refBlockPrefix is not set")
        }
        guard expiration > Date(timeIntervalSince1970: 0) else {
            throw EosioError(.serializeError, reason: "expiration is not set")
        }
        guard let serializer = self.serializationProvider else {
            preconditionFailure("A serializationProvider must be set!")
        }
        let json = try self.toJson()
        return try Data(hex: serializer.serializeTransaction(json: json))
    }

    /**
     This method will call `prepare(completion:)` before attemping to create a serialized transaction. If an error is encountered this method will
     call the completion with that error, otherwise the completion will be called with a serialized transaction.
     */
    public func serializeTransaction(completion: @escaping (EosioResult<Data, EosioError>) -> Void) {
        prepare { [weak self] (result) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                do {
                    let serializedTransaction = try strongSelf.serializeTransaction()
                    return completion(.success(serializedTransaction))
                } catch {
                    return completion(.failure(error.eosioError))
                }
            }
        }
    }

    /**
     This method will prepare the transaction, fetching or calculating any needed values by calling the `calculateExpiration()`,
     `getChainIdAndCalculateTapos(completion:)` and `serializeActionData(completion:)`. If any of these methods return an error this method will
     call the completion that error.
     */
    public func prepare(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {

        getInfoAndSetValues { [weak self] (taposResult) in
            switch taposResult {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                guard let strongSelf = self else {
                    return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
                }
                strongSelf.serializeActionData(completion: completion)
            }
        }
    }

    /**
     Serializes the `data` property of each action in `actions` and sets the `serializedData` property for each action, if not already set.
     Serializing the action data requires abis to be available in the `abis` class for all the contracts in the actions. If the necessary abis
     are not known to be available, call the async version method of this method which will attempt to get the abis first.
     - Paramerter serializationProvider: an EosioSerializationProviderProtocol conforming implementation for the transformation
     - Throws: If any required abis are not available, or the action `data` cannot be serialized.
     */
    public func serializeActionData() throws {
        let missingAbis = actionAccountsMissingAbis
        guard missingAbis.count == 0 else {
            throw EosioError(.serializeError, reason: "Cannot serialize action data. Abis missing for \(missingAbis).")
        }
        guard let serializer = self.serializationProvider else {
            preconditionFailure("A serializationProvider must be set!")
        }
        for action in actions {
            try action.serializeData(abi: abis.jsonAbi(name: action.account), serializationProvider: serializer)
        }
    }

    /**
     This method will call `getABIs(completion:)` before before attemping to serialize the actions data by calling `serializeActionData()`.
     If `getABIs(completion:)` returns an error this method will call completion with that error. If `serializeActionData()` throws an error,
     the completion will be called with that error. If all action data is successfully serialized the completion will be called with true.
     */
    public func serializeActionData(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        getAbis { [weak self] (abisResult) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch abisResult {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                do {
                    try strongSelf.serializeActionData()
                    return completion(.success(true))
                } catch {
                    return completion(.failure(error.eosioError))
                }
            }
        }
    }

    /**
     This method will get abis for every contract in the actions using the `abiProvider` and add them to `abis`. If abis are already present
     for all contracts this method will not need to use the abiProvider, and will immediately call the completion with true. If the `abiProvider`
     is not set but the `rpcProvider` is set, an `EosioAbiProvider` instance will be created using the `rpcProvider` and set as the `abiProvider`.
     If the abis are not present and the `abiProvider` is not set or `abiProvider` cannot get some of the requested abis, then an error is returned.
     If all abis are successfully set this method will call the completion with true.
     */
    public func getAbis(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        let missingAbis = actionAccountsMissingAbis
        // if no missing abis, return now
        if missingAbis.count == 0 {
            return completion(.success(true))
        }
        // if abiProvider is not set but rpcProvider is, init the default abiProvider with the rpcProvider
        if let rpcProvider = self.rpcProvider, self.abiProvider == nil {
            self.abiProvider = EosioAbiProvider(rpcProvider: rpcProvider)
        }
        guard let abiProvider = self.abiProvider else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "No abi provider available")))
        }
        guard chainId != "" else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "Chain id is not set")))
        }
        abiProvider.getAbis(chainId: chainId, accounts: missingAbis) { [weak self] (response) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let abiDictionary):
                do {
                    for (account, abi) in abiDictionary {
                        try strongSelf.abis.addAbi(name: account, data: abi)
                    }
                    return completion(.success(true))
                } catch {
                    return completion(.failure(error.eosioError))
                }
            }
        }
    }

    /**
     Get the chain info, set the `chainId` and `expiration`,  then calculate the reference block num using the using the `config` property and call
     `getBlockAndSetTapos(blockNum:, completion:)`. If the `chainId` is already set this method will validate against the `chainId` retreived from
     the `rpcProvider` and return a error if they do not do not match.
     */
    private func getInfoAndSetValues(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {

        // if all the data is set just return true
        if refBlockNum > 0 && refBlockPrefix > 0  && chainId != "" && expiration > Date(timeIntervalSince1970: 0) {
            return completion(.success(true))
        }

        // if no rpcProvider available, return error
        guard let rpcProvider = rpcProvider else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "No rpc provider available")))
        }

        // get chain info
        rpcProvider.getInfo { [weak self] (infoResponse) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.getInfoError, reason: "self does not exist")))
            }
            switch infoResponse {
            case .failure(let error):
                completion(.failure(error))
            case .success(let info):
                if strongSelf.chainId == "" {
                    strongSelf.chainId = info.chainId
                }
                // return an error if provided chainId does not match info chainID
                guard strongSelf.chainId == info.chainId else {
                    return completion(.failure(EosioError(.eosioTransactionError, reason: "Provided chain id \(strongSelf.chainId) does not match chain id \(info.chainId)")))
                }

                // if expiration not set, set by adding config.expireSeconds to head block time
                if strongSelf.expiration <= Date(timeIntervalSince1970: 0) {
                    guard let headBlockTime = Date(yyyyMMddTHHmmss: info.headBlockTime) else {
                        return completion(.failure(EosioError(.eosioTransactionError, reason: "Invalid head block time \(info.headBlockTime)")))
                    }
                    strongSelf.expiration = headBlockTime.addingTimeInterval(TimeInterval(strongSelf.config.expireSeconds))
                }

                let blocksBehind = UInt64(strongSelf.config.blocksBehind)
                var blockNum = info.headBlockNum - blocksBehind
                if blockNum <= 0 {
                    blockNum = 1
                }
                strongSelf.getBlockAndSetTapos(blockNum: blockNum, completion: completion)
            }
        }
    }

    /**
     Get the `block` specified by `blockNum` and set `refBlockNum` and `refBlockPrefix`. If `refBlockNum`, and `refBlockPrefix` already have valid
     values this method will call the completion with `true`. If these properties do not have valid values, this method will require an `rpcProvider`
     to get the data for these values. If the `rpcProvider` is not set or another error is encountered this method will call the completion with an error.
     */
    public func getBlockAndSetTapos(blockNum: UInt64, completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        // if the only data needed was the chainId, return now
        if self.refBlockPrefix > 0 && self.refBlockNum > 0 {
            return completion(.success(true))
        }
        // if no rpcProvider available, return error
        guard let rpcProvider = rpcProvider else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "No rpc provider available")))
        }

        let requestParameters = EosioRpcBlockRequest(block_num_or_id: blockNum)
        rpcProvider.getBlock(requestParameters: requestParameters, completion: { [weak self] (blockResponse) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.getBlockError, reason: "self does not exist")))
            }
            switch blockResponse {
            case .failure(let error):
                completion(.failure(error))
            case .success(let block):
                // set tapos fields and return
                strongSelf.refBlockNum = UInt16(block.blockNum & 0xffff)
                strongSelf.refBlockPrefix = block.refBlockPrefix
                return completion(.success(true))
            }
        })
    }

    /// Sign a transaction by getting the available keys from the signatureProvider then calling `sign(availableKeys:, completion:)`
    public func sign(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        guard let signatureProvider = signatureProvider else {
            return completion(.failure(EosioError(.signatureProviderError, reason: "No signature provider available")))
        }
        signatureProvider.getAvailableKeys { [weak self] (response) in
            guard let availableKeys = response.keys else {
                return completion(.failure(response.error ?? EosioError(.signatureProviderError, reason: "Unable to get available keys from signature provider")))
            }
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            strongSelf.sign(availableKeys: availableKeys, completion: completion)
        }
    }

    /// Sign a transaction by preparing the transaction and then calling `signPreparedTransaction(availableKeys:, completion:)`
    public func sign(availableKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        prepare { [weak self] (result) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                strongSelf.signPreparedTransaction(availableKeys: availableKeys, completion: completion)
            }
        }
    }

    /// Sign a transaction by getting the required keys using the rpcProvider then calling `sign(publicKeys:, completion:)`
    private func signPreparedTransaction(availableKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        guard let rpcProvider = rpcProvider else {
            return completion(.failure(EosioError(.signatureProviderError, reason: "No rpc provider available")))
        }
        let requiredKeysRequest = EosioRpcRequiredKeysRequest(availableKeys: availableKeys, transaction: self)
        rpcProvider.getRequiredKeys(requestParameters: requiredKeysRequest) { (response) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let requiredKeys):
                self.sign(publicKeys: requiredKeys.requiredKeys, completion: completion)
            }
        }
    }

    /// Serialize the transaction then sign with the public keys. If successful, set the `signatures` and return `true`, otherwise return an error.
    public func sign(publicKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        self.serializeTransaction { [weak self] (result) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let serializedTransaction):
                strongSelf.sign(serializedTransaction: serializedTransaction, publicKeys: publicKeys, completion: completion)
            }
        }
    }

    /// Serialize the transaction then sign with the public keys. If successful, set the `signatures` and return `true`, otherwise return an error.
    private func sign(serializedTransaction: Data, publicKeys: [String], completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        guard let signatureProvider = signatureProvider else {
            return completion(.failure(EosioError(.signatureProviderError, reason: "No signature provider available")))
        }
        var transactionSignatureRequest = EosioTransactionSignatureRequest()
        transactionSignatureRequest.serializedTransaction = serializedTransaction
        transactionSignatureRequest.publicKeys = publicKeys
        transactionSignatureRequest.chainId = self.chainId
        var binaryAbis = [EosioTransactionSignatureRequest.BinaryAbi]()
        for (name, hexAbi) in abis.hexAbis() {
            var binaryAbi = EosioTransactionSignatureRequest.BinaryAbi()
            binaryAbi.accountName = name.string
            binaryAbi.abi = hexAbi
            binaryAbis.append(binaryAbi)
        }
        transactionSignatureRequest.abis = binaryAbis

        signatureProvider.signTransaction(request: transactionSignatureRequest) { [weak self] (transactionSignatureResponse) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            guard let signedTransaction = transactionSignatureResponse.signedTransaction else {
                return completion(.failure(transactionSignatureResponse.error ?? EosioError(.signatureProviderError, reason: "Signature provider error")))
            }
            strongSelf.process(signedTransaction: signedTransaction, originalSerializedTransaction: serializedTransaction, completion: completion)
        }
    }

    /// Process a signed transaction
    private func process(signedTransaction: EosioTransactionSignatureResponse.SignedTransaction, originalSerializedTransaction: Data, completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        if signedTransaction.serializedTransaction == originalSerializedTransaction {
            self.serializedTransaction = signedTransaction.serializedTransaction
            self.signatures = signedTransaction.signatures
            return completion(.success(true))
        }

        guard allowSignatureProviderToModifyTransaction else {
            return completion(.failure(EosioError(.signatureProviderError, reason: "Signature provider is not allowed to modify transaction")))
        }

        // deserialize the signed transaction and set properties
        guard let serializer = self.serializationProvider else {
            preconditionFailure("A serializationProviderType must be set!")
        }
        do {
            let modifiedTransaction = try EosioTransaction.deserialize(signedTransaction.serializedTransaction, serializationProvider: serializer)
            // update properties to match deserialized modified transaction
            self.expiration = modifiedTransaction.expiration
            self.refBlockNum = modifiedTransaction.refBlockNum
            self.refBlockPrefix = modifiedTransaction.refBlockPrefix
            self.maxNetUsageWords = modifiedTransaction.maxNetUsageWords
            self.maxCpuUsageMs = modifiedTransaction.maxCpuUsageMs
            self.delaySec = modifiedTransaction.delaySec
            self.contextFreeActions = modifiedTransaction.contextFreeActions
            self.actions = modifiedTransaction.actions
            self.transactionExtensions = modifiedTransaction.transactionExtensions

            // set the serializedTransaction and signatures
            self.serializedTransaction = signedTransaction.serializedTransaction
            self.signatures = signedTransaction.signatures
            return completion(.success(true))
        } catch {
            return completion(.failure(error.eosioError))
        }

    }

    /// Broadcast a signed transaction. If successful, set the `transactionId` and return `true`, otherwise return an error.
    public func broadcast(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        guard let serializedTransaction = serializedTransaction, let signatures = signatures, signatures.count > 0 else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "Transaction must be signed before broadcast")))
        }
        guard let rpcProvider = rpcProvider else {
            return completion(.failure(EosioError(.eosioTransactionError, reason: "No rpc provider available")))
        }
        var pushTransactionRequest = EosioRpcPushTransactionRequest()
        pushTransactionRequest.packedTrx = serializedTransaction.hex
        pushTransactionRequest.signatures = signatures
        rpcProvider.pushTransaction(requestParameters: pushTransactionRequest) { [weak self] (response) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let pushTransactionResponse):
                strongSelf.transactionId = pushTransactionResponse.transactionId
                return completion(.success(true))
            }
        }
    }

    /// Sign a transaction, then broadcast
    public func signAndBroadcast(completion: @escaping (EosioResult<Bool, EosioError>) -> Void) {
        sign { [weak self] (result) in
            guard let strongSelf = self else {
                return completion(.failure(EosioError(.unexpectedError, reason: "self does not exist")))
            }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                strongSelf.broadcast(completion: completion)
            }
        }
    }

}
