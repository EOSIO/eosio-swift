//
//  EosioRpcRouter.swift
//  EosioSwift
//
//  Created by Ben Martell on 3/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public class EosioRpcRouter {

    public enum EndPointPath : String {
        
        case getInfo = "/v1/chain/get_info"
        case getBlock = "/v1/chain/get_block"
        case getBlockHeaderState = "/v1/chain/get_block_header_state"
        case getAccount = "/v1/chain/get_account"
        case getRawAbi = "/v1/chain/get_raw_abi"
        case getRawCodeAndAbi = "/v1/chain/get_raw_code_and_abi"
        case getTableRows = "/v1/chain/get_table_rows"
        case getRequiredKeys = "/v1/chain/get_required_keys"
        case getCurrencyStats = "/v1/chain/get_currency_stats"
        case getProducers = "/v1/chain/get_producers"
        case pushTransaction = "/v1/chain/push_transaction`"
        case pushTransactions = "/v1/chain/push_transactions`"
        case getHistoryActions = "/v1/history/get_actions`"
        case getHistoryTransaction = "/v1/history/get_transaction"
        case getHistoryKeyAccounts = "/v1/history/get_key_accounts`"
        case getHistoryControlledAccounts = "/v1/history/get_controlled_accounts"
    }
    
    public static func buildRpcRequest(endPoint: EosioEndpoint, parameters: Codable? = nil, path: EosioRpcRouter.EndPointPath ) -> EosioRequest? {
        
        guard let url = endPoint.baseUrl else { return nil }
        
        let functionCall = url.absoluteString + path.rawValue
        return  EosioRequest(function: functionCall, parameters: parameters)
    }
    
}
