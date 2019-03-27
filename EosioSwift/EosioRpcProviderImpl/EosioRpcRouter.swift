//
//  EosioRpcRouter.swift
//  EosioSwift
//
//  Created by Ben Martell on 3/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public protocol EosioRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encoutered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws: Any error thrown while constructing the `URLRequest`.
    func asUrlRequest() throws -> URLRequest
}

public enum EosioRpcRouter : EosioRequestConvertible {
    
    static let apiVersion = "v1"
    
    //implemented
    case getInfo(endpoint: EosioEndpoint)
    case getBlock(requestParameters: EosioRpcBlockRequest, endpoint: EosioEndpoint)
    case getRawAbi(requestParameters: EosioRpcRawAbiRequest, endpoint: EosioEndpoint)
    case getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, endpoint: EosioEndpoint)
    case pushTransaction(requestParameters: EosioRpcPushTransactionRequest, endpoint: EosioEndpoint)
    
    // no implementation yet in EosioRpcProviderProtocolImpl
    case getBlockHeaderState(requestParameters: EosioRpcBlockHeaderStateRequest, endpoint: EosioEndpoint)
    case getAccount(requestParameters: EosioRpcAccountRequest, endpoint: EosioEndpoint)
    case getRawCodeAndAbi(requestParameters: EosioRpcRawAbiRequest, endpoint: EosioEndpoint)
    case getTableRows(requestParameters: EosioRpcTableRowsRequest, endpoint: EosioEndpoint)
    case getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, endpoint: EosioEndpoint)
    case getProducers(requestParameters: EosioRpcProducersRequest, endpoint: EosioEndpoint)
    case getHistoryActions(requestParameters: EosioRpcHistoryActionsRequest, endpoint: EosioEndpoint)
    case getHistoryTransaction(requestParameters: EosioRpcHistoryTransactionRequest, endpoint: EosioEndpoint)
    case getHistoryKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, endpoint: EosioEndpoint)
    case getHistoryControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, endpoint: EosioEndpoint)

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

    public func asUrlRequest() throws -> URLRequest {

        var url: URL?
        var urlRequest: URLRequest?
        var parameters: Data?
        let encoder = JSONEncoder()
        
        // Handle getting the proper parameters and endpoint (only the 5 that we use are implemented for now)
        switch self {
            
            case let .getBlock(requestParameters, endpoint) :
                 url = endpoint.baseUrl!.appendingPathComponent(path)
                 parameters = try encoder.encode(requestParameters)
            
            case let .getRawAbi(requestParameters, endpoint) :
                 url = endpoint.baseUrl!.appendingPathComponent(path)
                 parameters = try encoder.encode(requestParameters)
            
            case let .getRequiredKeys(requestParameters, endpoint) :
                url = endpoint.baseUrl!.appendingPathComponent(path)
                parameters = try encoder.encode(requestParameters)
            
            case let .pushTransaction(requestParameters, endpoint):
                url = endpoint.baseUrl!.appendingPathComponent(path)
                parameters = try encoder.encode(requestParameters)
        
            case let .getInfo(endpoint) :
                let url = endpoint.baseUrl!.appendingPathComponent(path)
                urlRequest = try self.createRequest(url: url, parameters: nil)
            
        default:
            break
        }

        urlRequest = try self.createRequest(url: url, parameters: parameters)
        guard let finalRequest = urlRequest else {
            throw EosioError(.rpcProviderError, reason: "Unable to create URLRequest")
        }
        
        return finalRequest
    }
    
    private func createRequest(url: URL?, parameters: Data?) throws -> URLRequest {
        
        if let theUrl = url {
            var urlRequest = URLRequest(url: theUrl)
            urlRequest.httpMethod = self.method.rawValue
            if let theParameters = parameters {
                urlRequest.httpBody = theParameters
            }
            return urlRequest
            
        } else {
            throw EosioError(EosioErrorCode.rpcProviderError, reason: "Failed to create URL with path")
        }
    }
}

