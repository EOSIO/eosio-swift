//
//  EosioRpcProviderEndpointsCallbacks.swift
//  EosioSwift
//
//  Created by Brandon Fancher on 4/22/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

// MARK: - Endpoint methods taking callbacks
extension EosioRpcProvider {
    /* Chain Endpoints */

    /// Call `chain/get_account`. Fetch an account by account name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAccountRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcAccountResponse` and an optional `EosioError`.
    public func getAccount(requestParameters: EosioRpcAccountRequest, completion:@escaping (EosioResult<EosioRpcAccountResponse, EosioError>) -> Void) {
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
    public func pushTransactions(requestParameters: EosioRpcPushTransactionsRequest, completion: @escaping (EosioResult<EosioRpcPushTransactionsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transactions", requestParameters: requestParameters.transactions) {(result: EosioRpcPushTransactionsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
    /// Call `chain/get_block_header_state`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockHeaderStateRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcBlockHeaderStateResponse` and an optional `EosioError`.
    public func getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest, completion: @escaping (EosioResult<EosioRpcBlockHeaderStateResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block_header_state", requestParameters: requestParameters) {(result: EosioRpcBlockHeaderStateResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_abi`. Fetch an ABI by account/contract name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcAbiResponse` and an optional `EosioError`.
    public func getAbi(requestParameters: EosioRpcAbiRequest, completion: @escaping (EosioResult<EosioRpcAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_abi", requestParameters: requestParameters) {(result: EosioRpcAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_currency_balance`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyBalanceRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCurrencyBalanceResponse` and an optional `EosioError`.
    public func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest, completion:@escaping (EosioResult<EosioRpcCurrencyBalanceResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_balance", requestParameters: requestParameters) {(result: EosioRpcCurrencyBalanceResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_currency_stats`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyStatsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCurrencyStatsResponse` and an optional `EosioError`.
    public func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, completion:@escaping (EosioResult<EosioRpcCurrencyStatsResponse, EosioError>) -> Void) {
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
    public func getProducers(requestParameters: EosioRpcProducersRequest, completion:@escaping (EosioResult<EosioRpcProducersResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_producers", requestParameters: requestParameters) {(result: EosioRpcProducersResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_code_and_abi`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawCodeAndAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRawCodeAndAbiResponse` and an optional `EosioError`.
    public func getRawCodeAndAbi(requestParameters: EosioRpcRawCodeAndAbiRequest, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: requestParameters) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_code_and_abi`. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account name, as a String.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcRawCodeAndAbiResponse` and an optional `EosioError`.
    public func getRawCodeAndAbi(accountName: String, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: ["account_name": accountName]) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_table_by_scope`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableByScopeRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTableByScopeResponse` and an optional `EosioError`.
    public func getTableByScope(requestParameters: EosioRpcTableByScopeRequest, completion:@escaping (EosioResult<EosioRpcTableByScopeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_by_scope", requestParameters: requestParameters) {(result: EosioRpcTableByScopeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_table_rows`. Returns an object containing rows from the specified table.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableRowsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTableRowsResponse` and an optional `EosioError`.
    public func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion:@escaping (EosioResult<EosioRpcTableRowsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_rows", requestParameters: requestParameters) {(result: EosioRpcTableRowsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_code`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCodeRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCodeResponse` and an optional `EosioError`.
    public func getCode(requestParameters: EosioRpcCodeRequest, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: requestParameters) {(result: EosioRpcCodeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_code`. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account/contract name, as a String.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcCodeResponse` and an optional `EosioError`.
    public func getCode(accountName: String, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
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
    public func getActions(requestParameters: EosioRpcHistoryActionsRequest, completion:@escaping (EosioResult<EosioRpcActionsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_actions", requestParameters: requestParameters) {(result: EosioRpcActionsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_transaction`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcGetTransactionResponse` and an optional `EosioError`.
    public func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion:@escaping (EosioResult<EosioRpcGetTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_transaction", requestParameters: requestParameters) {(result: EosioRpcGetTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_key_accounts`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryKeyAccountsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcKeyAccountsResponse` and an optional `EosioError`.
    public func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion:@escaping (EosioResult<EosioRpcKeyAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_key_accounts", requestParameters: requestParameters) {(result: EosioRpcKeyAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `history/get_controlled_accounts`.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryControlledAccountsRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcControlledAccountsResponse` and an optional `EosioError`.
    public func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion:@escaping (EosioResult<EosioRpcControlledAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_controlled_accounts", requestParameters: requestParameters) {(result: EosioRpcControlledAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/send_transaction`. Send a transaction to the blockchain!
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcSendTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of an `EosioRpcTransactionResponse` and an optional `EosioError`.
    public func sendTransaction(requestParameters: EosioRpcSendTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/send_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
}
