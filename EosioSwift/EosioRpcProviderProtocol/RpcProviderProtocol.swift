//
//  RpcProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation

public protocol RpcProviderProtocol {
    
    var endpoints: [EosioEndpoint] { get }
    var failoverRetries: Int { get }
    var primaryEndpoint: EosioEndpoint { get }
    
    init(endpoints: [EosioEndpoint], failoverRetries: Int)
    
    func rpcRequest(request: EosioRequest, completion: @escaping (EosioResult<EosioResponse, EosioError>)->Void)
    
    /** Calls /v1/chain/get_info */
    func getInfo(completion: @escaping(EosioResult<EosioRpcInfo, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block` */
    func getBlock(blockNum: UInt64, completion: @escaping(EosioResult<EosioRpcBlock, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block_header_state` */
    func getBlockHeaderState(blockNum: UInt64, completion: @escaping(EosioResult<EosioRpcBlockHeaderState, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block_header_state` */
    func getBlockHeaderState(blockId: String, completion: @escaping(EosioResult<EosioRpcBlockHeaderState, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_account` */
    func getAccount(account: EosioName, completion: @escaping(EosioResult<EosioRpcAccount, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_raw_abi` */
    func getRawAbi(account: EosioName, completion: @escaping(EosioResult<EosioRpcRawAbi, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_raw_code_and_abi` */
    func getRawCodeAndAbi(account: EosioName, completion: @escaping(EosioResult<EosioRpcRawCodeAbi, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_table_rows` */
    func getTableRows(parameters: EosioRpcTableRowsRequest, completion: @escaping(EosioResult<EosioRpcTableRows, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_required_keys` */
    func getRequiredKeys(parameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeys, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_currency_stats` */
    func getCurrencyStats(code: String, symbol: String, completion: @escaping(EosioResult<EosioRpcCurrencyStats, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_producers` */
    func getProducers(parameters: EosioRpcProducersRequest, completion: @escaping(EosioResult<EosioRpcProducers, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransaction(transaction: EosioTransaction, completion: @escaping(EosioResult<EosioRpcTransaction, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransactions(transactions: [EosioTransaction], completion: @escaping ([EosioResult<EosioRpcTransaction, EosioError>]) -> Void)
    
    /** Calls `/v1/history/get_actions` */
    func getHistoryActions(parameters: EosioRpcHistoryActionsRequest, completion: @escaping(EosioResult<EosioRpcHistoryActions, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_transaction` */
    func getHistoryTransaction(transactionId: String, completion: @escaping(EosioResult<EosioRpcTransaction, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_key_accounts` */
    func getHistoryKeyAccounts(publicKey: String, completion: @escaping (EosioResult<EosioRpcKeyAccounts, EosioError>) -> Void)
    
    /** Calls `/v1/history/get_controlled_accounts` */
    func getHistoryControlledAccounts(controllingAccount: EosioName, completion: @escaping (EosioResult<EosioRpcControllingAccounts, EosioError>) -> Void)
    
}
