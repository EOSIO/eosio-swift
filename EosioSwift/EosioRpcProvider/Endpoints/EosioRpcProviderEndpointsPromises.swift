//
//  EosioRpcProviderEndpointsPromises.swift
//  EosioSwift
//
//  Created by Brandon Fancher on 4/18/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import PromiseKit

// MARK: - Endpoint methods returning Promises.
extension EosioRpcProvider {

    /* Chain Endpoints */

    /// Call `chain/get_account` and get a Promise back. Fetch an account by account name.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcAccountRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcAccountResponse` or rejected with an `EosioError`.
    public func getAccount(_: PMKNamespacer, requestParameters: EosioRpcAccountRequest) -> Promise<EosioRpcAccountResponse> {
        return Promise { getAccount(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_block` and get a Promise back. Get a block by block number or ID.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcBlockRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcBlockResponse` or rejected with an `EosioError`.
    public func getBlock(_: PMKNamespacer, requestParameters: EosioRpcBlockRequest) -> Promise<EosioRpcBlockResponse> {
        return Promise { getBlock(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_info` and get a Promise back. Get information about the chain and node.
    ///
    /// - Parameter _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    /// - Returns: A Promise fulfilled with an `EosioRpcInfoResponse` or rejected with an `EosioError`.
    public func getInfo(_: PMKNamespacer) -> Promise<EosioRpcInfoResponse> {
        return Promise { getInfo(completion: $0.resolve) }
    }

    /// Call `chain/push_transaction` and get a Promise back. Push a transaction to the blockchain!
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcPushTransactionRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcTransactionResponse` or rejected with an `EosioError`.
    public func pushTransaction(_: PMKNamespacer, requestParameters: EosioRpcPushTransactionRequest) -> Promise<EosioRpcTransactionResponse> {
        return Promise { pushTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/push_transactions` and get a Promise back. Push multiple transactions to the chain.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcPushTransactionsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcPushTransactionsResponse` or rejected with an `EosioError`.
    public func pushTransactions(_: PMKNamespacer, requestParameters: EosioRpcPushTransactionsRequest) -> Promise<EosioRpcPushTransactionsResponse> {
        return Promise { pushTransactions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_block_header_state` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcBlockHeaderStateRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcBlockHeaderStateResponse` or rejected with an `EosioError`.
    public func getBlockHeaderState(_: PMKNamespacer, requestParameters: EosioRpcBlockHeaderStateRequest) -> Promise<EosioRpcBlockHeaderStateResponse> {
        return Promise { getBlockHeaderState(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_abi` and get a Promise back. Fetch an ABI by account/contract name.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcAbiRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcAbiResponse` or rejected with an `EosioError`.
    public func getAbi(_: PMKNamespacer, requestParameters: EosioRpcAbiRequest) -> Promise<EosioRpcAbiResponse> {
        return Promise { getAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_currency_balance` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcCurrencyBalanceRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcCurrencyBalanceResponse` or rejected with an `EosioError`.
    public func getCurrencyBalance(_: PMKNamespacer, requestParameters: EosioRpcCurrencyBalanceRequest) -> Promise<EosioRpcCurrencyBalanceResponse> {
        return Promise { getCurrencyBalance(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_currency_stats` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcCurrencyStatsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcCurrencyStatsResponse` or rejected with an `EosioError`.
    public func getCurrencyStats(_: PMKNamespacer, requestParameters: EosioRpcCurrencyStatsRequest) -> Promise<EosioRpcCurrencyStatsResponse> {
        return Promise { getCurrencyStats(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_required_keys` and get a Promise back. Pass in a transaction and an array of available keys. Get back the subset of those keys required for signing the transaction.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcRequiredKeysRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcRequiredKeysResponse` or rejected with an `EosioError`.
    public func getRequiredKeys(_: PMKNamespacer, requestParameters: EosioRpcRequiredKeysRequest) -> Promise<EosioRpcRequiredKeysResponse> {
        return Promise { getRequiredKeys(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_producers` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcProducersRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcProducersResponse` or rejected with an `EosioError`.
    public func getProducers(_: PMKNamespacer, requestParameters: EosioRpcProducersRequest) -> Promise<EosioRpcProducersResponse> {
        return Promise { getProducers(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_raw_code_and_abi` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcRawCodeAndAbiRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcRawCodeAndAbiResponse` or rejected with an `EosioError`.
    public func getRawCodeAndAbi(_: PMKNamespacer, requestParameters: EosioRpcRawCodeAndAbiRequest) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_raw_code_and_abi` and get a Promise back. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - accountName: The account/contract name, as a String.
    /// - Returns: A Promise fulfilled with an `EosioRpcRawCodeAndAbiResponse` or rejected with an `EosioError`.
    public func getRawCodeAndAbi(_: PMKNamespacer, accountName: String) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(accountName: accountName, completion: $0.resolve) }
    }

    /// Call `chain/get_table_by_scope` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcTableByScopeRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcTableByScopeResponse` or rejected with an `EosioError`.
    public func getTableByScope(_: PMKNamespacer, requestParameters: EosioRpcTableByScopeRequest) -> Promise<EosioRpcTableByScopeResponse> {
        return Promise { getTableByScope(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_table_rows` and get a Promise back. Returns an object containing rows from the specified table.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcTableRowsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcTableRowsResponse` or rejected with an `EosioError`.
    public func getTableRows(_: PMKNamespacer, requestParameters: EosioRpcTableRowsRequest) -> Promise<EosioRpcTableRowsResponse> {
        return Promise { getTableRows(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_code` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcCodeRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcCodeResponse` or rejected with an `EosioError`.
    public func getCode(_: PMKNamespacer, requestParameters: EosioRpcCodeRequest) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `chain/get_code` and geta Promise back. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - accountName: The account/contract name, as a String.
    /// - Returns: A Promise fulfilled with an `EosioRpcCodeResponse` or rejected with an `EosioError`.
    public func getCode(_: PMKNamespacer, accountName: String) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(accountName: accountName, completion: $0.resolve) }
    }

    /// Call `chain/get_raw_abi` and get a Promise back. Get a raw abi.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcRawAbiRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcRawAbiResponse` or rejected with an `EosioError`.
    public func getRawAbi(_: PMKNamespacer, requestParameters: EosioRpcRawAbiRequest) -> Promise<EosioRpcRawAbiResponse> {
        return Promise { getRawAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /* History Endpoints */

    /// Call `history/get_actions` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcHistoryActionsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcActionsResponse` or rejected with an `EosioError`.
    public func getActions(_: PMKNamespacer, requestParameters: EosioRpcHistoryActionsRequest) -> Promise<EosioRpcActionsResponse> {
        return Promise { getActions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `history/get_transaction` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcHistoryTransactionRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcGetTransactionResponse` or rejected with an `EosioError`.
    public func getTransaction(_: PMKNamespacer, requestParameters: EosioRpcHistoryTransactionRequest) -> Promise<EosioRpcGetTransactionResponse> {
        return Promise { getTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `history/get_key_accounts` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcHistoryKeyAccountsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcKeyAccountsResponse` or rejected with an `EosioError`.
    public func getKeyAccounts(_: PMKNamespacer, requestParameters: EosioRpcHistoryKeyAccountsRequest) -> Promise<EosioRpcKeyAccountsResponse> {
        return Promise { getKeyAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }

    /// Call `history/get_controlled_accounts` and get a Promise back.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - requestParameters: An `EosioRpcHistoryControlledAccountsRequest`.
    /// - Returns: A Promise fulfilled with an `EosioRpcControlledAccountsResponse` or rejected with an `EosioError`.
    public func getControlledAccounts(_: PMKNamespacer, requestParameters: EosioRpcHistoryControlledAccountsRequest) -> Promise<EosioRpcControlledAccountsResponse> {
        return Promise { getControlledAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }
}
