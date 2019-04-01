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
    case getInfoRequest(endpoint: EosioEndpoint)
    case getBlockRequest(requestParameters: EosioRpcBlockRequest, endpoint: EosioEndpoint)
    case getRawAbiRequest(requestParameters: EosioRpcRawAbiRequest, endpoint: EosioEndpoint)
    case getRequiredKeysRequest(requestParameters: EosioRpcRequiredKeysRequest, endpoint: EosioEndpoint)
    case pushTransactionRequest(requestParameters: EosioRpcPushTransactionRequest, endpoint: EosioEndpoint)
    
    // no implementation yet in EosioRpcProviderProtocolImpl
    case getBlockHeaderStateRequest(requestParameters: EosioRpcBlockHeaderStateRequest, endpoint: EosioEndpoint)
    case getAccountRequest(requestParameters: EosioRpcAccountRequest, endpoint: EosioEndpoint)
    case getRawCodeAndAbiRequest(requestParameters: EosioRpcRawAbiRequest, endpoint: EosioEndpoint)
    case getTableRowsRequest(requestParameters: EosioRpcTableRowsRequest, endpoint: EosioEndpoint)
    case getCurrencyStatsRequest(requestParameters: EosioRpcCurrencyStatsRequest, endpoint: EosioEndpoint)
    case getProducersRequest(requestParameters: EosioRpcProducersRequest, endpoint: EosioEndpoint)
    case getHistoryActionsRequest(requestParameters: EosioRpcHistoryActionsRequest, endpoint: EosioEndpoint)
    case getHistoryTransactionRequest(requestParameters: EosioRpcHistoryTransactionRequest, endpoint: EosioEndpoint)
    case getHistoryKeyAccountsRequest(requestParameters: EosioRpcHistoryKeyAccountsRequest, endpoint: EosioEndpoint)
    case getHistoryControlledAccountsRequest(requestParameters: EosioRpcHistoryControlledAccountsRequest, endpoint: EosioEndpoint)

    var method: EosioHttpMethod {
            return .post
    }
    
    var path: String {
        switch self {
        case .getInfoRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_info"
        case .getBlockRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_block"
        case .getBlockHeaderStateRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_block_header_state"
        case .getRawAbiRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_raw_abi"
        case .getRequiredKeysRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_required_keys"
        case .pushTransactionRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/push_transaction"
        case .getAccountRequest:
            return "\(EosioRpcRouter.apiVersion)chain/get_account"
        case .getRawCodeAndAbiRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_raw_code_and_abi"
        case .getTableRowsRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_table_rows"
        case .getCurrencyStatsRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_currency_stats"
        case .getProducersRequest:
            return "\(EosioRpcRouter.apiVersion)/chain/get_producers"
        case .getHistoryActionsRequest:
            return "\(EosioRpcRouter.apiVersion)/history/get_actions"
        case .getHistoryTransactionRequest:
            return "\(EosioRpcRouter.apiVersion)/history/get_transaction"
        case .getHistoryKeyAccountsRequest:
            return "\(EosioRpcRouter.apiVersion)history/get_key_accounts"
        case .getHistoryControlledAccountsRequest:
            return "\(EosioRpcRouter.apiVersion)/history/get_controlled_accounts"
        }
    }

    public func asUrlRequest() throws -> URLRequest {

        var url: URL?
        var urlRequest: URLRequest?
        var parameters: Data?
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Date.asTransactionTimestamp)
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        // Handle getting the proper parameters and endpoint (only the 5 that we use are implemented for now)
        switch self {
            
            case let .getBlockRequest(requestParameters, endpoint) :
                 url = endpoint.baseUrl!.appendingPathComponent(path)
                 parameters = try encoder.encode(requestParameters)
            
            case let .getRawAbiRequest(requestParameters, endpoint) :
                 url = endpoint.baseUrl!.appendingPathComponent(path)
                 parameters = try encoder.encode(requestParameters)
            
            case let .getRequiredKeysRequest(requestParameters, endpoint) :
                url = endpoint.baseUrl!.appendingPathComponent(path)
                parameters = try encoder.encode(requestParameters)
            
            case let .pushTransactionRequest(requestParameters, endpoint):
                url = endpoint.baseUrl!.appendingPathComponent(path)
                parameters = try encoder.encode(requestParameters)
        
            case let .getInfoRequest(endpoint) :
                url = endpoint.baseUrl!.appendingPathComponent(path)
                parameters = nil
            
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

