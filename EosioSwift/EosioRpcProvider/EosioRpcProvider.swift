//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct EosioRpcProvider {

    private let endpoint: URL
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }

    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    private func getResource<T: Codable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?, callBack:@escaping (T?, EosioError?) -> Void) {
        let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestParameters = requestParameters {
            do {
                let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                request.httpBody = jsonData
            } catch {
                callBack(nil, EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                callBack(nil, EosioError(.rpcProviderError, reason: "Network error.", originalError: error as NSError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                callBack(nil, EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let reason = "Status Code: \(httpResponse.statusCode) Server Response: \(String(data: data ?? Data(), encoding: .utf8) ?? "nil")"
                callBack(nil, EosioError(.rpcProviderError, reason: reason, originalError: nil))
                return
            }

            if let data = data {
                let decoder = JSONDecoder()
                guard var resource = try? decoder.decode(T.self, from: data) else {
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error decoding returned data.", originalError: nil))
                    return
                }
                resource._rawResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                callBack(resource, nil)
            }
        }
        task.resume()
    }

}

// MARK: - EosioRpcProviderProtocol

extension EosioRpcProvider: EosioRpcProviderProtocol {

    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
}

// MARK: - Extra Endpoints

public extension EosioRpcProvider {

    /* Chain endpoints */

    func getAccount(requestParameters: EosioRpcAccountRequest, completion:@escaping (EosioResult<EosioRpcAccountResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_account", requestParameters: requestParameters) {(result: EosioRpcAccountResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest, completion:@escaping (EosioResult<EosioRpcCurrencyBalanceResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_balance", requestParameters: requestParameters) {(result: EosioRpcCurrencyBalanceResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, completion:@escaping (EosioResult<EosioRpcCurrencyStatsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_stats", requestParameters: requestParameters) {(result: EosioRpcCurrencyStatsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getRawCodeAndAbi(requestParameters: EosioRpcRawCodeAndAbiRequest, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: requestParameters) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getRawCodeAndAbi(accountName: String, completion:@escaping (EosioResult<EosioRpcRawCodeAndAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: ["account_name": accountName]) {(result: EosioRpcRawCodeAndAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getCode(requestParameters: EosioRpcCodeRequest, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: requestParameters) {(result: EosioRpcCodeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getCode(accountName: String, completion:@escaping (EosioResult<EosioRpcCodeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: ["account_name": accountName]) {(result: EosioRpcCodeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion:@escaping (EosioResult<EosioRpcTableRowsResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_rows", requestParameters: requestParameters) {(result: EosioRpcTableRowsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getTableByScope(requestParameters: EosioRpcTableByScopeRequest, completion:@escaping (EosioResult<EosioRpcTableByScopeResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_by_scope", requestParameters: requestParameters) {(result: EosioRpcTableByScopeResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getProducers(requestParameters: EosioRpcProducersRequest, completion:@escaping (EosioResult<EosioRpcProducersResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_producers", requestParameters: requestParameters) {(result: EosioRpcProducersResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /* History endpoints */

    func getActions(requestParameters: EosioRpcHistoryActionsRequest, completion:@escaping (EosioResult<EosioRpcActionsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_actions", requestParameters: requestParameters) {(result: EosioRpcActionsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion:@escaping (EosioResult<EosioRpcControlledAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_controlled_accounts", requestParameters: requestParameters) {(result: EosioRpcControlledAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion:@escaping (EosioResult<EosioRpcGetTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_transaction", requestParameters: requestParameters) {(result: EosioRpcGetTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion:@escaping (EosioResult<EosioRpcKeyAccountsResponse, EosioError>) -> Void) {
        getResource(rpc: "history/get_key_accounts", requestParameters: requestParameters) {(result: EosioRpcKeyAccountsResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
}
