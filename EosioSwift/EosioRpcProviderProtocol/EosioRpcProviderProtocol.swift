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
    
    /** Calls /v1/chain/get_info */
    func getInfo(completion: @escaping(EosioResult<EosioRpcInfoResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block` */
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping(EosioResult<EosioRpcBlockResponse, EosioError>) -> Void)

    /** Calls `/v1/chain/get_raw_abi` */
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void)

    /** Calls `/v1/chain/get_required_keys` */
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block_header_state` */
     func getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest, completion: @escaping(EosioResult<EosioRpcBlockHeaderStateResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_account` */
    func getAccount(requestParameters: EosioRpcAccountRequest, completion: @escaping(EosioResult<EosioRpcAccountResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_raw_code_and_abi` */
    func getRawCodeAndAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawCodeAbiResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_table_rows` */
    func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion: @escaping(EosioResult<EosioRpcTableRowsResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_currency_stats` */
    func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, symbol: String, completion: @escaping(EosioResult<EosioRpcCurrencyStatsResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_producers` */
    func getProducers(requestParameters: EosioRpcProducersRequest, completion: @escaping(EosioResult<EosioRpcProducersResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransactions(requestParameters: [EosioRpcPushTransactionRequest], completion: @escaping ([EosioResult<EosioRpcTransactionResponse, EosioError>]) -> Void)
    
    /** Calls `/v1/history/get_actions` */
    func getHistoryActions(requestParameters: EosioRpcHistoryActionsRequest, completion: @escaping(EosioResult<EosioRpcHistoryActionsResponse, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_transaction` */
    func getHistoryTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_key_accounts` */
    func getHistoryKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion: @escaping (EosioResult<EosioRpcHistoryKeyAccountsResponse, EosioError>) -> Void)
   
    /** Calls `/v1/history/get_controlled_accounts` */
    func getHistoryControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion: @escaping (EosioResult<EosioRpcControllingAccountsResponse, EosioError>) -> Void)
}

/** to allow optional functions in a pure swift protocol (not using @objc)
    override these empty implementations if needed */
extension EosioRpcProviderProtocol {
    public func getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest, completion: @escaping(EosioResult<EosioRpcBlockHeaderStateResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getBlockHeaderState() not implemented.")))
    }
    
    public func getAccount(requestParameters: EosioRpcAccountRequest, completion: @escaping(EosioResult<EosioRpcAccountResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getAccount() not implemented.")))
    }
    
    public func getRawCodeAndAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawCodeAbiResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getRawCodeAndAbi() not implemented.")))
    }
    
    public func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion: @escaping(EosioResult<EosioRpcTableRowsResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getTableRows() not implemented.")))
    }
    
    public func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, symbol: String, completion: @escaping(EosioResult<EosioRpcCurrencyStatsResponse, EosioError>) -> Void) {
        
         completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getCurrencyStats() not implemented.")))
    }
    
    public func getProducers(requestParameters: EosioRpcProducersRequest, completion: @escaping(EosioResult<EosioRpcProducersResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getProducers() not implemented.")))
    }
    
    public func pushTransactions(requestParameters: [EosioRpcPushTransactionRequest], completion: @escaping ([EosioResult<EosioRpcTransactionResponse, EosioError>]) -> Void) {
        
        completion([EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: pushTransactions() not implemented."))])
    }
    
    public func getHistoryActions(requestParameters: EosioRpcHistoryActionsRequest, completion: @escaping(EosioResult<EosioRpcHistoryActionsResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryActions() not implemented.")))
    }
    
    public func getHistoryTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryTransaction() not implemented.")))
    }
    
    public func getHistoryKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion: @escaping (EosioResult<EosioRpcHistoryKeyAccountsResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryKeyAccounts() not implemented.")))
    }
    
    public func getHistoryControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion: @escaping (EosioResult<EosioRpcControllingAccountsResponse, EosioError>) -> Void) {
        
        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No Implementation: getHistoryControlledAccounts() not implemented.")))
    }
}

