//
//  EosioRpcProviderPromises.swift
//  EosioSwift
//
//  Created by Brandon Fancher on 4/18/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import PromiseKit

extension EosioRpcProvider {
    public func getAccount(requestParameters: EosioRpcAccountRequest) -> Promise<EosioRpcAccountResponse> {
        return Promise { getAccount(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest) -> Promise<EosioRpcBlockResponse> {
        return Promise { getBlock(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getInfo() -> Promise<EosioRpcInfoResponse> {
        return Promise { getInfo(completion: $0.resolve) }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest) -> Promise<EosioRpcTransactionResponse> {
        return Promise { pushTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func pushTransactions(requestParameters: EosioRpcPushTransactionsRequest) -> Promise<EosioRpcPushTransactionsResponse> {
        return Promise { pushTransactions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest) -> Promise<EosioRpcBlockHeaderStateResponse> {
        return Promise { getBlockHeaderState(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getAbi(requestParameters: EosioRpcAbiRequest) -> Promise<EosioRpcAbiResponse> {
        return Promise { getAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest) -> Promise<EosioRpcCurrencyBalanceResponse> {
        return Promise { getCurrencyBalance(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest) -> Promise<EosioRpcCurrencyStatsResponse> {
        return Promise { getCurrencyStats(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest) -> Promise<EosioRpcRequiredKeysResponse> {
        return Promise { getRequiredKeys(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getProducers(requestParameters: EosioRpcProducersRequest) -> Promise<EosioRpcProducersResponse> {
        return Promise { getProducers(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRawCodeAndAbi(requestParameters: EosioRpcRawCodeAndAbiRequest) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRawCodeAndAbi(accountName: String) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(accountName: accountName, completion: $0.resolve) }
    }

    public func getTableByScope(requestParameters: EosioRpcTableByScopeRequest) -> Promise<EosioRpcTableByScopeResponse> {
        return Promise { getTableByScope(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getTableRows(requestParameters: EosioRpcTableRowsRequest) -> Promise<EosioRpcTableRowsResponse> {
        return Promise { getTableRows(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCode(requestParameters: EosioRpcCodeRequest) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCode(accountName: String) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(accountName: accountName, completion: $0.resolve) }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest) -> Promise<EosioRpcRawAbiResponse> {
        return Promise { getRawAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getActions(requestParameters: EosioRpcHistoryActionsRequest) -> Promise<EosioRpcActionsResponse> {
        return Promise { getActions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest) -> Promise<EosioRpcGetTransactionResponse> {
        return Promise { getTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest) -> Promise<EosioRpcKeyAccountsResponse> {
        return Promise { getKeyAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest) -> Promise<EosioRpcControlledAccountsResponse> {
        return Promise { getControlledAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }

    // Protocol Versions

    public func getInfo() -> Promise<EosioRpcInfoResponseProtocol> {
        return Promise { getInfo(completion: $0.resolve) }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest) -> Promise<EosioRpcBlockResponseProtocol> {
        return Promise { getBlock(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest) -> Promise<EosioRpcRawAbiResponseProtocol> {
        return Promise { getRawAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest) -> Promise<EosioRpcRequiredKeysResponseProtocol> {
        return Promise { getRequiredKeys(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest) -> Promise<EosioRpcTransactionResponseProtocol> {
        return Promise { pushTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }
}
