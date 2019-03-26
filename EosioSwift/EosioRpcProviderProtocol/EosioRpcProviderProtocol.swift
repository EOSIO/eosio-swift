//
//  RpcProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public protocol EosioRpcProviderProtocol {
    
    var endpoints: [EosioEndpoint] { get }
    var failoverRetries: Int { get }
    var primaryEndpoint: EosioEndpoint { get }
    
    init(endpoints: [EosioEndpoint], failoverRetries: Int)
    
    func rpcRequest(request: EosioRequest, completion: @escaping (EosioResult<EosioResponse, EosioError>)->Void)
    
    /** Calls /v1/chain/get_info */
    func getInfo(completion: @escaping(EosioResult<EosioRpcInfo, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block` */
    func getBlock(requestParameters: EosioBlockRequest, completion: @escaping(EosioResult<EosioRpcBlock, EosioError>) -> Void)

    /** Calls `/v1/chain/get_raw_abi` */
    func getRawAbi(requestParameters: EosioRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawAbi, EosioError>) -> Void)

    /** Calls `/v1/chain/get_required_keys` */
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeys, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransaction, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block_header_state` */
     func getBlockHeaderState(requestParameters: EosioBlockHeaderStateRequest, completion: @escaping(EosioResult<EosioRpcBlockHeaderState, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_account` */
    func getAccount(requestParameters: EosioAccountRequest, completion: @escaping(EosioResult<EosioRpcAccount, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_raw_code_and_abi` */
    func getRawCodeAndAbi(requestParameters: EosioRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawCodeAbi, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_table_rows` */
    func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion: @escaping(EosioResult<EosioRpcTableRows, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_currency_stats` */
    func getCurrencyStats(requestParameters: EosioCurrencyStatsRequest, symbol: String, completion: @escaping(EosioResult<EosioRpcCurrencyStats, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_producers` */
    func getProducers(requestParameters: EosioRpcProducersRequest, completion: @escaping(EosioResult<EosioRpcProducers, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransactions(requestParameters: [EosioRpcPushTransactionRequest], completion: @escaping ([EosioResult<EosioRpcTransaction, EosioError>]) -> Void)
    
    /** Calls `/v1/history/get_actions` */
    func getHistoryActions(requestParameters: EosioRpcHistoryActionsRequest, completion: @escaping(EosioResult<EosioRpcHistoryActions, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_transaction` */
    func getHistoryTransaction(requestParameters: EosioHistoryTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransaction, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_key_accounts` */
    func getHistoryKeyAccounts(requestParameters: EosioHistoryKeyAccountsRequest, completion: @escaping (EosioResult<EosioRpcKeyAccounts, EosioError>) -> Void)
   
    /** Calls `/v1/history/get_controlled_accounts` */
    func getHistoryControlledAccounts(requestParameters: EosioHistoryControlledAccountsRequest, completion: @escaping (EosioResult<EosioRpcControllingAccounts, EosioError>) -> Void)
}

/** to allow optional functions in a pure swift protocol (not using @objc)
    override these empty implementations if needed */
extension EosioRpcProviderProtocol {
    public func getBlockHeaderState(requestParameters: EosioBlockHeaderStateRequest, completion: @escaping(EosioResult<EosioRpcBlockHeaderState, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getBlockHeaderState() not implemented.")))
    }
    
    public func getAccount(requestParameters: EosioAccountRequest, completion: @escaping(EosioResult<EosioRpcAccount, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getAccount() not implemented.")))
    }
    
    public func getRawCodeAndAbi(requestParameters: EosioRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawCodeAbi, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getRawCodeAndAbi() not implemented.")))
    }
    
    public func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion: @escaping(EosioResult<EosioRpcTableRows, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getTableRows() not implemented.")))
    }
    
    public func getCurrencyStats(requestParameters: EosioCurrencyStatsRequest, symbol: String, completion: @escaping(EosioResult<EosioRpcCurrencyStats, EosioError>) -> Void) {
        
         completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getCurrencyStats() not implemented.")))
    }
    
    public func getProducers(requestParameters: EosioRpcProducersRequest, completion: @escaping(EosioResult<EosioRpcProducers, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getProducers() not implemented.")))
    }
    
    public func pushTransactions(requestParameters: [EosioRpcPushTransactionRequest], completion: @escaping ([EosioResult<EosioRpcTransaction, EosioError>]) -> Void) {
        
        completion([EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: pushTransactions() not implemented."))])
    }
    
    public func getHistoryActions(requestParameters: EosioRpcHistoryActionsRequest, completion: @escaping(EosioResult<EosioRpcHistoryActions, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryActions() not implemented.")))
    }
    
    public func getHistoryTransaction(requestParameters: EosioHistoryTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransaction, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryTransaction() not implemented.")))
    }
    
    public func getHistoryKeyAccounts(requestParameters: EosioHistoryKeyAccountsRequest, completion: @escaping (EosioResult<EosioRpcKeyAccounts, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryKeyAccounts() not implemented.")))
    }
    
    public func getHistoryControlledAccounts(requestParameters: EosioHistoryControlledAccountsRequest, completion: @escaping (EosioResult<EosioRpcControllingAccounts, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryControlledAccounts() not implemented.")))
    }
}
