//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct EosioRpcProvider: EosioRpcProviderProtocol {

    private let endpoint: URL
    public init(endpoint: URL) {
        self.endpoint = endpoint
    }

    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters) {(result: EosioRpcBlockResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    private func getResource<T: Codable>(rpc: String, requestParameters: Encodable?, callBack:@escaping (T?, EosioError?) -> Void) {
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
                callBack(nil, EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError))
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
                guard let resource = try? decoder.decode(T.self, from: data) else {
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error decoding returned data.", originalError: nil))
                    return
                }
                callBack(resource, nil)
            }
        }
        task.resume()
    }

}

// MARK: - Extra Endpoints

public extension EosioRpcProvider {

    struct RpcResponse: EosioRpcResponseProtocol {
        public var rawResponse: Data?
    }

    private func getResource(rpc: String, requestParameters: Encodable?, completion: @escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestParameters = requestParameters {
            do {
                let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                request.httpBody = jsonData
            } catch {
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError)))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let reason = "Status Code: \(httpResponse.statusCode) Server Response: \(String(data: data ?? Data(), encoding: .utf8) ?? "nil")"
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: reason, originalError: nil)))
                return
            }

            if let data = data {
                let responseObject = RpcResponse(rawResponse: data)
                completion(EosioResult.success(responseObject))
            }
        }
        task.resume()
    }

    /* Chain endpoints */

    func getAccount(requestParameters: EosioRpcAccountRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_account", requestParameters: requestParameters, completion: completion)
    }

    func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_balance", requestParameters: requestParameters, completion: completion)
    }

    func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_stats", requestParameters: requestParameters, completion: completion)
    }

    func getRawCodeAndAbi(requestParameters: EosioRpcRawCodeAndAbiRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: requestParameters, completion: completion)
    }

    func getRawCodeAndAbi(accountName: String, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: ["account_name": accountName], completion: completion)
    }

    func getCode(requestParameters: EosioRpcCodeRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: requestParameters, completion: completion)
    }

    func getCode(accountName: String, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_code", requestParameters: ["account_name": accountName], completion: completion)
    }

    func getTableRows(requestParameters: EosioRpcTableRowsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_rows", requestParameters: requestParameters, completion: completion)
    }

    func getTableByScope(requestParameters: EosioRpcTableByScopeRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_table_by_scope", requestParameters: requestParameters, completion: completion)
    }

    func getProducers(requestParameters: EosioRpcProducersRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_producers", requestParameters: requestParameters, completion: completion)
    }

    /* History endpoints */

    func getActions(requestParameters: EosioRpcHistoryActionsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_actions", requestParameters: requestParameters, completion: completion)
    }

    func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_controlled_accounts", requestParameters: requestParameters, completion: completion)
    }

    func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_transaction", requestParameters: requestParameters, completion: completion)
    }

    func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_key_accounts", requestParameters: requestParameters, completion: completion)
    }
}
