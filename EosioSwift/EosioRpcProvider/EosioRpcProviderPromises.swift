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
    public func getAccount(_: PMKNamespacer, requestParameters: EosioRpcAccountRequest) -> Promise<EosioRpcAccountResponse> {
        return Promise { getAccount(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getBlock(_: PMKNamespacer, requestParameters: EosioRpcBlockRequest) -> Promise<EosioRpcBlockResponse> {
        return Promise { getBlock(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getInfo(_: PMKNamespacer) -> Promise<EosioRpcInfoResponse> {
        return Promise { getInfo(completion: $0.resolve) }
    }

    public func pushTransaction(_: PMKNamespacer, requestParameters: EosioRpcPushTransactionRequest) -> Promise<EosioRpcTransactionResponse> {
        return Promise { pushTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func pushTransactions(_: PMKNamespacer, requestParameters: EosioRpcPushTransactionsRequest) -> Promise<EosioRpcPushTransactionsResponse> {
        return Promise { pushTransactions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getBlockHeaderState(_: PMKNamespacer, requestParameters: EosioRpcBlockHeaderStateRequest) -> Promise<EosioRpcBlockHeaderStateResponse> {
        return Promise { getBlockHeaderState(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getAbi(_: PMKNamespacer, requestParameters: EosioRpcAbiRequest) -> Promise<EosioRpcAbiResponse> {
        return Promise { getAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCurrencyBalance(_: PMKNamespacer, requestParameters: EosioRpcCurrencyBalanceRequest) -> Promise<EosioRpcCurrencyBalanceResponse> {
        return Promise { getCurrencyBalance(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCurrencyStats(_: PMKNamespacer, requestParameters: EosioRpcCurrencyStatsRequest) -> Promise<EosioRpcCurrencyStatsResponse> {
        return Promise { getCurrencyStats(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRequiredKeys(_: PMKNamespacer, requestParameters: EosioRpcRequiredKeysRequest) -> Promise<EosioRpcRequiredKeysResponse> {
        return Promise { getRequiredKeys(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getProducers(_: PMKNamespacer, requestParameters: EosioRpcProducersRequest) -> Promise<EosioRpcProducersResponse> {
        return Promise { getProducers(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRawCodeAndAbi(_: PMKNamespacer, requestParameters: EosioRpcRawCodeAndAbiRequest) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getRawCodeAndAbi(_: PMKNamespacer, accountName: String) -> Promise<EosioRpcRawCodeAndAbiResponse> {
        return Promise { getRawCodeAndAbi(accountName: accountName, completion: $0.resolve) }
    }

    public func getTableByScope(_: PMKNamespacer, requestParameters: EosioRpcTableByScopeRequest) -> Promise<EosioRpcTableByScopeResponse> {
        return Promise { getTableByScope(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getTableRows(_: PMKNamespacer, requestParameters: EosioRpcTableRowsRequest) -> Promise<EosioRpcTableRowsResponse> {
        return Promise { getTableRows(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCode(_: PMKNamespacer, requestParameters: EosioRpcCodeRequest) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getCode(_: PMKNamespacer, accountName: String) -> Promise<EosioRpcCodeResponse> {
        return Promise { getCode(accountName: accountName, completion: $0.resolve) }
    }

    public func getRawAbi(_: PMKNamespacer, requestParameters: EosioRpcRawAbiRequest) -> Promise<EosioRpcRawAbiResponse> {
        return Promise { getRawAbi(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getActions(_: PMKNamespacer, requestParameters: EosioRpcHistoryActionsRequest) -> Promise<EosioRpcActionsResponse> {
        return Promise { getActions(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getTransaction(_: PMKNamespacer, requestParameters: EosioRpcHistoryTransactionRequest) -> Promise<EosioRpcGetTransactionResponse> {
        return Promise { getTransaction(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getKeyAccounts(_: PMKNamespacer, requestParameters: EosioRpcHistoryKeyAccountsRequest) -> Promise<EosioRpcKeyAccountsResponse> {
        return Promise { getKeyAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }

    public func getControlledAccounts(_: PMKNamespacer, requestParameters: EosioRpcHistoryControlledAccountsRequest) -> Promise<EosioRpcControlledAccountsResponse> {
        return Promise { getControlledAccounts(requestParameters: requestParameters, completion: $0.resolve) }
    }
}
