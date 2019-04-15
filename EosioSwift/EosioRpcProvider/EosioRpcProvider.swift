//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

/// Default RPC Provider implementation. Conforms to `EosioRpcProviderProtocol`.
/// RPC Reference: https://developers.eos.io/eosio-nodeos/reference
public struct EosioRpcProvider {

    private let endpoint: URL

    /// Initialize the default RPC Provider implementation.
    ///
    /// - Parameter endpoint: A node URL.
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }

    /* Chain Endpoints */

    /// Call `chain/get_account`. Fetch an account by account name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAccountRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcAccountResponse` and an optional `EosioError`.
    func getAccount(requestParameters: EosioRpcAccountRequest, completion:@escaping (EosioResult<EosioRpcAccountResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_account", requestParameters: requestParameters) {(result: EosioRpcAccountResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_block`. Get a block by block number or ID.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcBlockResponse` and an optional `EosioError`.
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_info`. Get information about the chain and node.
    ///
    /// - Parameter completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcInfoResponse` and an optional `EosioError`.
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/push_transaction`. Push a transaction to the blockchain!
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTransactionResponse` and an optional `EosioError`.
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/push_transactions`. Push multiple transactions to the chain.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcPushTransactionsResponse` and an optional `EosioError`.
    func pushTransactions(requestParameters: EosioRpcPushTransactionsRequest, completion: @escaping (EosioResult<EosioRpcPushTransactionsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transactions", requestParameters: requestParameters.transactions) {(result: EosioRpcPushTransactionsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
    /// Call `chain/get_block_header_state`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockHeaderStateRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcBlockHeaderStateResponse` and an optional `EosioError`.
    func getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest, completion: @escaping (EosioResult<EosioRpcBlockHeaderStateResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block_header_state", requestParameters: requestParameters) {(result: EosioRpcBlockHeaderStateResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_abi`. Fetch an ABI by account/contract name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcAbiResponse` and an optional `EosioError`.
    func getAbi(requestParameters: EosioRpcAbiRequest, completion: @escaping (EosioResult<EosioRpcAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_abi", requestParameters: requestParameters) {(result: EosioRpcAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_currency_balance`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyBalanceRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCurrencyBalanceResponse` and an optional `EosioError`.
    func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest, completion:@escaping (EosioResult<EosioRpcCurrencyBalanceResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_balance", requestParameters: requestParameters) {(result: EosioRpcCurrencyBalanceResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_currency_stats`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyStatsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCurrencyStatsResponse` and an optional `EosioError`.
    func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, completion:@escaping (EosioResult<EosioRpcCurrencyStatsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_stats", requestParameters: requestParameters) {(result: EosioRpcCurrencyStatsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_required_keys`. Pass in a transaction and an array of available keys. Get back the subset of those keys required for signing the transaction.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRequiredKeysRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRequiredKeysResponse` and an optional `EosioError`.
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_producers`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcProducersRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcProducersResponse` and an optional `EosioError`.
    func getProducers(requestParameters: EosioRpcProducersRequest, completion:@escaping (EosioResult<EosioRpcProducersResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_producers", requestParameters: requestParameters) {(result: EosioRpcProducersResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_code_and_abi`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawCodeAndAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRawCodeAndAbiResponse` and an optional `EosioError`.
    func getRawCodeAndAbi(requestParameters: EosioRpcRawCodeAndAbiRequest, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: requestParameters) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_code_and_abi`. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account name, as a String.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRawCodeAndAbiResponse` and an optional `EosioError`.
    func getRawCodeAndAbi(accountName: String, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: ["account_name": accountName]) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_table_by_scope`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableByScopeRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTableByScopeResponse` and an optional `EosioError`.
    func getTableByScope(requestParameters: EosioRpcTableByScopeRequest, completion:@escaping (EosioResult<EosioRpcTableByScopeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_by_scope", requestParameters: requestParameters) {(result: EosioRpcTableByScopeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_table_rows`. Returns an object containing rows from the specified table.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableRowsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTableRowsResponse` and an optional `EosioError`.
    func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion:@escaping (EosioResult<EosioRpcTableRowsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_rows", requestParameters: requestParameters) {(result: EosioRpcTableRowsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_code`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCodeRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCodeResponse` and an optional `EosioError`.
    func getCode(requestParameters: EosioRpcCodeRequest, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: requestParameters) {(result: EosioRpcCodeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_code`. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account/contract name, as a String.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCodeResponse` and an optional `EosioError`.
    func getCode(accountName: String, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: ["account_name": accountName]) {(result: EosioRpcCodeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_abi`. Get a raw abi.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRawAbiResponse` and an optional `EosioError`.
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /* History Endpoints */

    /// Call `history/get_actions`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryActionsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcActionsResponse` and an optional `EosioError`.
    func getActions(requestParameters: EosioRpcHistoryActionsRequest, completion:@escaping (EosioResult<EosioRpcActionsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_actions", requestParameters: requestParameters) {(result: EosioRpcActionsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_transaction`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcGetTransactionResponse` and an optional `EosioError`.
    func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion:@escaping (EosioResult<EosioRpcGetTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_transaction", requestParameters: requestParameters) {(result: EosioRpcGetTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_key_accounts`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryKeyAccountsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcKeyAccountsResponse` and an optional `EosioError`.
    func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion:@escaping (EosioResult<EosioRpcKeyAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_key_accounts", requestParameters: requestParameters) {(result: EosioRpcKeyAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_controlled_accounts`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryControlledAccountsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcControlledAccountsResponse` and an optional `EosioError`.
    func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion:@escaping (EosioResult<EosioRpcControlledAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_controlled_accounts", requestParameters: requestParameters) {(result: EosioRpcControlledAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    private func getResource<T: Codable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?, callBack:@escaping (T?, EosioError?) -> Void) {
        let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestParameters = requestParameters {
            do {
                let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                request.httpBody = jsonData
            } catch {
                callBack(nil, EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callBack(nil, EosioError(.rpcProviderError, reason: "Network error.", originalError: error as NSError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                callBack(nil, EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let reason = "Status Code: \(httpResponse.statusCode) Server Response: \(String(data: data ?? Data(), encoding: .utf8) ?? "nil")"
                callBack(nil, EosioError(.rpcProviderError, reason: reason, originalError: nil))
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                do {
                    var resource = try decoder.decode(T.self, from: data)
                    resource._rawResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    callBack(resource, nil)
                } catch let error {
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error occured in decoding/serializing returned data.", originalError: error as NSError))
                }
            }
        }
        task.resume()
    }

}

// MARK: - RPC methods used by `EosioTransaction`. These force conformance only to the protocols, not the entire response structs.
extension EosioRpcProvider: EosioRpcProviderProtocol {

    /// Call `chain/get_info`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameter completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcInfoResponseProtocol` and an optional `EosioError`.
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_block`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcBlockResponseProtocol` and an optional `EosioError`.
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_abi`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcRawAbiResponseProtocol` and an optional `EosioError`.
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_required_keys`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRequiredKeysRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcRequiredKeysResponseProtocol` and an optional `EosioError`.
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/push_transaction`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcTransactionResponseProtocol` and an optional `EosioError`.
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
}
