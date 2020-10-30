//
//  EosioRpcProviderEndpointsCombine.swift
//  EosioSwift
//  Created by Mark Johnson on 5/4/20
//  Copyright (c) 2017-2020 block.one and its contributors. All rights reserved.
//

import Foundation
#if canImport(Combine)
  import Combine
#endif

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension EosioRpcProvider {
    /* Chain Endpoints */

    /// Call `chain/get_account` and get a Publisher back. Fetch an account by account name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAccountRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcAccountResponse` or rejected with an `EosioError`.
    public func getAccountPublisher(requestParameters: EosioRpcAccountRequest) -> AnyPublisher<EosioRpcAccountResponse, EosioError> {
        return Future<EosioRpcAccountResponse, EosioError> { [weak self] promise in
            self?.getAccount(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_block` and get a Publisher back. Get a block by block number or ID.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcBlockResponse` or rejected with an `EosioError`.
    public func getBlockPublisher(requestParameters: EosioRpcBlockRequest) -> AnyPublisher<EosioRpcBlockResponse, EosioError> {
        return Future<EosioRpcBlockResponse, EosioError> { [weak self] promise in
            self?.getBlock(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }
    
    /// Call `chain/get_block_info` and get a Publisher back. Get a block by block number.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockInfoRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcBlockInfoResponse` or rejected with an `EosioError`.
    public func getBlockInfoPublisher(requestParameters: EosioRpcBlockInfoRequest) -> AnyPublisher<EosioRpcBlockInfoResponse, EosioError> {
        return Future<EosioRpcBlockInfoResponse, EosioError> { [weak self] promise in
            self?.getBlockInfo(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_info` and get a Publisher back. Get information about the chain and node.
    ///
    /// - Returns: A Publisher fulfilled with an `EosioRpcInfoResponse` or rejected with an `EosioError`.
    public func getInfoPublisher() -> AnyPublisher<EosioRpcInfoResponse, EosioError> {
        return Future<EosioRpcInfoResponse, EosioError> { [weak self] promise in
            self?.getInfo(completion: { promise($0.asResult) } as ((EosioResult<EosioRpcInfoResponse, EosioError>) -> Void))
        }.eraseToAnyPublisher()
    }

    /// Call `chain/push_transaction` and get a Publisher back. Push a transaction to the blockchain!
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcTransactionResponse` or rejected with an `EosioError`.
    public func pushTransactionPublisher(requestParameters: EosioRpcPushTransactionRequest) -> AnyPublisher<EosioRpcTransactionResponse, EosioError> {
        return Future<EosioRpcTransactionResponse, EosioError> { [weak self] promise in
            self?.pushTransaction(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/push_transactions` and get a Publisher back. Push multiple transactions to the chain.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcPushTransactionsResponse` or rejected with an `EosioError`.
    public func pushTransactionsPublisher(requestParameters: EosioRpcPushTransactionsRequest) -> AnyPublisher<EosioRpcPushTransactionsResponse, EosioError> {
        return Future<EosioRpcPushTransactionsResponse, EosioError> { [weak self] promise in
            self?.pushTransactions(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/send_transaction` and get a Publisher back. Send a transaction to the blockchain!
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcSendTransactionRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcTransactionResponse` or rejected with an `EosioError`.
    public func sendTransactionPublisher(requestParameters: EosioRpcSendTransactionRequest) -> AnyPublisher<EosioRpcTransactionResponse, EosioError> {
        return Future<EosioRpcTransactionResponse, EosioError> { [weak self] promise in
            self?.sendTransaction(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/send_transactions` and get a Publisher back. Send multiple transactions to the chain.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcSendTransactionsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcSendTransactionsResponse` or rejected with an `EosioError`.
    public func sendTransactionsPublisher(requestParameters: EosioRpcSendTransactionsRequest) -> AnyPublisher<EosioRpcSendTransactionsResponse, EosioError> {
        return Future<EosioRpcSendTransactionsResponse, EosioError> { [weak self] promise in
            self?.sendTransactions(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_block_header_state` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockHeaderStateRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcBlockHeaderStateResponse` or rejected with an `EosioError`.
    public func getBlockHeaderStatePublisher(requestParameters: EosioRpcBlockHeaderStateRequest) -> AnyPublisher<EosioRpcBlockHeaderStateResponse, EosioError> {
        return Future<EosioRpcBlockHeaderStateResponse, EosioError> { [weak self] promise in
            self?.getBlockHeaderState(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_abi` and get a Publisher back. Fetch an ABI by account/contract name.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcAbiRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcAbiResponse` or rejected with an `EosioError`.
    public func getAbiPublisher(requestParameters: EosioRpcAbiRequest) -> AnyPublisher<EosioRpcAbiResponse, EosioError> {
        return Future<EosioRpcAbiResponse, EosioError> { [weak self] promise in
            self?.getAbi(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_currency_balance` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyBalanceRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcCurrencyBalanceResponse` or rejected with an `EosioError`.
    public func getCurrencyBalancePublisher(requestParameters: EosioRpcCurrencyBalanceRequest) -> AnyPublisher<EosioRpcCurrencyBalanceResponse, EosioError> {
        return Future<EosioRpcCurrencyBalanceResponse, EosioError> { [weak self] promise in
            self?.getCurrencyBalance(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_currency_stats` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCurrencyStatsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcCurrencyStatsResponse` or rejected with an `EosioError`.
    public func getCurrencyStatsPublisher(requestParameters: EosioRpcCurrencyStatsRequest) -> AnyPublisher<EosioRpcCurrencyStatsResponse, EosioError> {
        return Future<EosioRpcCurrencyStatsResponse, EosioError> { [weak self] promise in
            self?.getCurrencyStats(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_required_keys` and get a Publisher back. Pass in a transaction and an array of available keys. Get back the subset of those keys required for signing the transaction.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRequiredKeysRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcRequiredKeysResponse` or rejected with an `EosioError`.
    public func getRequiredKeysPublisher(requestParameters: EosioRpcRequiredKeysRequest) -> AnyPublisher<EosioRpcRequiredKeysResponse, EosioError> {
        return Future<EosioRpcRequiredKeysResponse, EosioError> { [weak self] promise in
            self?.getRequiredKeys(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_producers` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcProducersRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcProducersResponse` or rejected with an `EosioError`.
    public func getProducersPublisher(requestParameters: EosioRpcProducersRequest) -> AnyPublisher<EosioRpcProducersResponse, EosioError> {
        return Future<EosioRpcProducersResponse, EosioError> { [weak self] promise in
            self?.getProducers(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_raw_code_and_abi` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawCodeAndAbiRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcRawCodeAndAbiResponse` or rejected with an `EosioError`.
    public func getRawCodeAndAbiPublisher(requestParameters: EosioRpcRawCodeAndAbiRequest) -> AnyPublisher<EosioRpcRawCodeAndAbiResponse, EosioError> {
        return Future<EosioRpcRawCodeAndAbiResponse, EosioError> { [weak self] promise in
            self?.getRawCodeAndAbi(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_raw_code_and_abi` and get a Publisher back. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account/contract name, as a String.
    /// - Returns: A Publisher fulfilled with an `EosioRpcRawCodeAndAbiResponse` or rejected with an `EosioError`.
    public func getRawCodeAndAbiPublisher(accountName: String) -> AnyPublisher<EosioRpcRawCodeAndAbiResponse, EosioError> {
        return Future<EosioRpcRawCodeAndAbiResponse, EosioError> { [weak self] promise in
            self?.getRawCodeAndAbi(accountName: accountName, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_table_by_scope` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableByScopeRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcTableByScopeResponse` or rejected with an `EosioError`.
    public func getTableByScopePublisher(requestParameters: EosioRpcTableByScopeRequest) -> AnyPublisher<EosioRpcTableByScopeResponse, EosioError> {
        return Future<EosioRpcTableByScopeResponse, EosioError> { [weak self] promise in
            self?.getTableByScope(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_table_rows` and get a Publisher back. Returns an object containing rows from the specified table.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcTableRowsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcTableRowsResponse` or rejected with an `EosioError`.
    public func getTableRowsPublisher(requestParameters: EosioRpcTableRowsRequest) -> AnyPublisher<EosioRpcTableRowsResponse, EosioError> {
        return Future<EosioRpcTableRowsResponse, EosioError> { [weak self] promise in
            self?.getTableRows(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_code` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcCodeRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcCodeResponse` or rejected with an `EosioError`.
    public func getCodePublisher(requestParameters: EosioRpcCodeRequest) -> AnyPublisher<EosioRpcCodeResponse, EosioError> {
        return Future<EosioRpcCodeResponse, EosioError> { [weak self] promise in
            self?.getCode(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_code` and geta Publisher back. Convenience method called with simple account name.
    ///
    /// - Parameters:
    ///   - accountName: The account/contract name, as a String.
    /// - Returns: A Publisher fulfilled with an `EosioRpcCodeResponse` or rejected with an `EosioError`.
    public func getCodePublisher(accountName: String) -> AnyPublisher<EosioRpcCodeResponse, EosioError> {
        return Future<EosioRpcCodeResponse, EosioError> { [weak self] promise in
            self?.getCode(accountName: accountName, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `chain/get_raw_abi` and get a Publisher back. Get a raw abi.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawAbiRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcRawAbiResponse` or rejected with an `EosioError`.
    public func getRawAbiPublisher(requestParameters: EosioRpcRawAbiRequest) -> AnyPublisher<EosioRpcRawAbiResponse, EosioError> {
        return Future<EosioRpcRawAbiResponse, EosioError> { [weak self] promise in
            self?.getRawAbi(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /* History Endpoints */

    /// Call `history/get_actions` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryActionsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcActionsResponse` or rejected with an `EosioError`.
    public func getActionsPublisher(requestParameters: EosioRpcHistoryActionsRequest) -> AnyPublisher<EosioRpcActionsResponse, EosioError> {
        return Future<EosioRpcActionsResponse, EosioError> { [weak self] promise in
            self?.getActions(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `history/get_transaction` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryTransactionRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcGetTransactionResponse` or rejected with an `EosioError`.
    public func getTransactionPublisher(requestParameters: EosioRpcHistoryTransactionRequest) -> AnyPublisher<EosioRpcGetTransactionResponse, EosioError> {
        return Future<EosioRpcGetTransactionResponse, EosioError> { [weak self] promise in
            self?.getTransaction(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `history/get_key_accounts` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryKeyAccountsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcKeyAccountsResponse` or rejected with an `EosioError`.
    public func getKeyAccountsPublisher(requestParameters: EosioRpcHistoryKeyAccountsRequest) -> AnyPublisher<EosioRpcKeyAccountsResponse, EosioError> {
        return Future<EosioRpcKeyAccountsResponse, EosioError> { [weak self] promise in
            self?.getKeyAccounts(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }

    /// Call `history/get_controlled_accounts` and get a Publisher back.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcHistoryControlledAccountsRequest`.
    /// - Returns: A Publisher fulfilled with an `EosioRpcControlledAccountsResponse` or rejected with an `EosioError`.
    public func getControlledAccountsPublisher(requestParameters: EosioRpcHistoryControlledAccountsRequest) -> AnyPublisher<EosioRpcControlledAccountsResponse, EosioError> {
        return Future<EosioRpcControlledAccountsResponse, EosioError> { [weak self] promise in
            self?.getControlledAccounts(requestParameters: requestParameters, completion: { promise($0.asResult) })
        }.eraseToAnyPublisher()
    }
}
