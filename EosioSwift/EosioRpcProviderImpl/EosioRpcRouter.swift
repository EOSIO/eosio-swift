//
//  EosioRpcRouter.swift
//  EosioSwift
//
//  Created by Ben Martell on 3/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public enum EosioRpcRouter : EosioRequestConvertible {
    
    static let apiVersion = "v1"
    
    //implemented
    case getInfo(parameters: Codable, endpoint: EosioEndpoint)
    case getBlock(parameters: Codable, endpoint: EosioEndpoint)
    case getBlockHeaderState(parameters: Codable, endpoint: EosioEndpoint)
    case getRawAbi(parameters: Codable, endpoint: EosioEndpoint)
    case getRequiredKeys(parameters: Codable, endpoint: EosioEndpoint)
    case pushTransaction(parameters: Codable, endpoint: EosioEndpoint)
    
    // no implementation yet in EosioRpcProviderProtocolImpl for these (will need to change some of these patterns as well)
    case getAccount(parameters: Codable, endpoint: EosioEndpoint)
    case getRawCodeAndAbi(parameters: Codable, endpoint: EosioEndpoint)
    case getTableRows(parameters: Codable, endpoint: EosioEndpoint)
    case getCurrencyStats(parameters: Codable, endpoint: EosioEndpoint)
    case getProducers(parameters: Codable, endpoint: EosioEndpoint)
    case pushTransactions(parameters: Codable, endpoint: EosioEndpoint)
    case getHistoryActions(parameters: Codable, endpoint: EosioEndpoint)
    case getHistoryTransaction(parameters: Codable, endpoint: EosioEndpoint)
    case getHistoryKeyAccounts(parameters: Codable, endpoint: EosioEndpoint)
    case getHistoryControlledAccounts(parameters: Codable, endpoint: EosioEndpoint)

    var method: EosioHttpMethod {
        switch self {
        case .getInfo:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getInfo:
            return "\(EosioRpcRouter.apiVersion)/chain/get_info"
        case .getBlock:
            return "\(EosioRpcRouter.apiVersion)/chain/get_block"
        case .getBlockHeaderState:
            return "\(EosioRpcRouter.apiVersion)/chain/get_block_header_state"
        case .getRawAbi:
            return "\(EosioRpcRouter.apiVersion)/chain/get_raw_abi"
        case .getRequiredKeys:
            return "\(EosioRpcRouter.apiVersion)/chain/get_required_keys"
        case .pushTransaction:
            return "\(EosioRpcRouter.apiVersion)/chain/push_transaction"
        case .getAccount:
            return "\(EosioRpcRouter.apiVersion)chain/get_account"
        case .getRawCodeAndAbi:
            return "\(EosioRpcRouter.apiVersion)/chain/get_raw_code_and_abi"
        case .getTableRows:
            return "\(EosioRpcRouter.apiVersion)/chain/get_table_rows"
        case .getCurrencyStats:
            return "\(EosioRpcRouter.apiVersion)/chain/get_currency_stats"
        case .getProducers:
            return "\(EosioRpcRouter.apiVersion)/chain/get_producers"
        case .pushTransactions:
            return "\(EosioRpcRouter.apiVersion)/chain/push_transactions"
        case .getHistoryActions:
            return "\(EosioRpcRouter.apiVersion)/history/get_actions"
        case .getHistoryTransaction:
            return "\(EosioRpcRouter.apiVersion)/history/get_transaction"
        case .getHistoryKeyAccounts:
            return "\(EosioRpcRouter.apiVersion)history/get_key_accounts"
        case .getHistoryControlledAccounts:
            return "\(EosioRpcRouter.apiVersion)/history/get_controlled_accounts"
        }
    }

    public func asEosioRequest() throws -> EosioRequest {

        var request: EosioRequest?

        // Handle getting the proper parameters and endpoint
        switch self {
            
        //NOTE: remaining enums will need to be added but the patterns for them may be different
        case let .getInfo(parameters, endpoint), let .getBlock(parameters, endpoint),
            let .getBlockHeaderState(parameters, endpoint), let .getRawAbi(parameters, endpoint),
            let .getRequiredKeys(parameters, endpoint), let .pushTransaction(parameters, endpoint):
            
            let url = endpoint.baseUrl!.appendingPathComponent(path)
            request = EosioRequest(url: url, parameters: parameters, method: method)

        default:
            break
        }

        guard let finalRequest = request else {
            // NOTE: This error code will change once the new EosioError changes are merged!
            throw EosioError(.rpcProviderError, reason: "Unable to create EosioRequest")
        }
        
        return finalRequest
    }
}

