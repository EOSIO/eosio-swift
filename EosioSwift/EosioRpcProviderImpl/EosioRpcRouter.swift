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
    case getInfo(endpoint: EosioEndpoint)
    case getBlock(requestParameters: Codable, endpoint: EosioEndpoint)
    case getBlockHeaderState(requestParameters: Codable, endpoint: EosioEndpoint)
    case getRawAbi(requestParameters: Codable, endpoint: EosioEndpoint)
    case getRequiredKeys(requestParameters: Codable, endpoint: EosioEndpoint)
    case pushTransaction(requestParameters: Codable, endpoint: EosioEndpoint)
    
    // no implementation yet in EosioRpcProviderProtocolImpl for these (will need to change some of these patterns as well)
    case getAccount(requestParameters: Codable, endpoint: EosioEndpoint)
    case getRawCodeAndAbi(requestParameters: Codable, endpoint: EosioEndpoint)
    case getTableRows(requestParameters: Codable, endpoint: EosioEndpoint)
    case getCurrencyStats(requestParameters: Codable, endpoint: EosioEndpoint)
    case getProducers(requestParameters: Codable, endpoint: EosioEndpoint)
    case pushTransactions(requestParameters: Codable, endpoint: EosioEndpoint)
    case getHistoryActions(requestParameters: Codable, endpoint: EosioEndpoint)
    case getHistoryTransaction(requestParameters: Codable, endpoint: EosioEndpoint)
    case getHistoryKeyAccounts(requestParameters: Codable, endpoint: EosioEndpoint)
    case getHistoryControlledAccounts(requestParameters: Codable, endpoint: EosioEndpoint)

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
        case let .getBlock(requestParameters, endpoint), let .getBlockHeaderState(requestParameters, endpoint), let .getRawAbi(requestParameters, endpoint), let .getRequiredKeys(requestParameters, endpoint), let .pushTransaction(requestParameters, endpoint):
            
            let url = endpoint.baseUrl!.appendingPathComponent(path)
            request = EosioRequest(url: url, requestParameters: requestParameters, method: method)
        
        case let .getInfo(endpoint) :
            let url = endpoint.baseUrl!.appendingPathComponent(path)
            request = EosioRequest(url: url, requestParameters: nil, method: method)
        default:
            break
        }

        guard let finalRequest = request else {
            throw EosioError(.rpcProviderError, reason: "Unable to create EosioRequest")
        }
        
        return finalRequest
    }
}

