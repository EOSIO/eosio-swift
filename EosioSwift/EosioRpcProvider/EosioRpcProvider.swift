//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct EosioRpcProvider:EosioRpcProviderProtocol {

    private let endpoint:URL
    public init(endpoint:URL){
        self.endpoint = endpoint
    }
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil){(result: EosioRpcInfoResponse?, error:EosioError?) in
            self.callCompletion(responseObject: result, error: error, completion: completion)
        }
        
        
    }
    
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block", requestParameters: requestParameters){(result: EosioRpcBlockResponse?, error:EosioError?) in
            self.callCompletion(responseObject: result, error: error, completion: completion)
        }
    }
    
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters){(result: EosioRpcRawAbiResponse?, error:EosioError?) in
            self.callCompletion(responseObject: result, error: error, completion: completion)
        }
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters){(result: EosioRpcRequiredKeysResponse?, error:EosioError?) in
            self.callCompletion(responseObject: result, error: error, completion: completion)
        }
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters){(result: EosioRpcTransactionResponse?, error:EosioError?) in
            self.callCompletion(responseObject: result, error: error, completion: completion)
        }
        
    }
    
    func callCompletion<ResponseType>(responseObject:ResponseType?, error:EosioError?, completion:(EosioResult<ResponseType, EosioError>) -> Void) {
        if let responseObject = responseObject{
            completion(EosioResult.success(responseObject))
        }
        
        if let error = error{
            completion(EosioResult.failure(error))
        }
    }
    
    private func getResource<T:Codable>(rpc:String, requestParameters:Encodable?, callBack:@escaping (T?, EosioError?)->Void) {
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
            if let error = error{
                callBack(nil, EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else{
                callBack(nil, EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else{
                callBack(nil, EosioError(.rpcProviderError, reason: "Status Code: \(httpResponse.statusCode) Server Response: \(String(data:data ?? Data(), encoding: .utf8) ?? "nil")", originalError: nil))
                return
            }

            if let data = data{
                let decoder = JSONDecoder()
                guard let resource = try? decoder.decode(T.self, from: data) else{
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error decoding returned data.", originalError: nil))
                    return
                }
                callBack(resource, nil)
            }
        }
        task.resume()
    }
    
}

//MARK:- Extra Endpoints

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
                print(String(data: jsonData, encoding: .utf8) ?? "")
            } catch {
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError)))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else{
                completion(EosioResult.failure(EosioError(.rpcProviderError, reason: "Status Code: \(httpResponse.statusCode) Server Response: \(String(data:data ?? Data(), encoding: .utf8) ?? "nil")", originalError: nil)))
                return
            }
            
            if let data = data{
                let responseObject = RpcResponse(rawResponse: data)
                completion(EosioResult.success(responseObject))
            }
        }
        task.resume()
    }
    
    func getAccount(requestParameters: EosioRpcAccountRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_account", requestParameters: requestParameters, completion: completion)
    }
    
    func getCurrencyBalance(requestParameters: EosioRpcCurrencyBalanceRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_balance", requestParameters: requestParameters, completion: completion)
    }
    
    func getCurrencyStats(requestParameters: EosioRpcCurrencyStatsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_currency_stats", requestParameters: requestParameters, completion: completion)
    }
    
    func getTransaction(requestParameters: EosioRpcHistoryTransactionRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_transaction", requestParameters: requestParameters, completion: completion)
    }
    
    func getKeyAccounts(requestParameters: EosioRpcHistoryKeyAccountsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_key_accounts", requestParameters: requestParameters, completion: completion)
    }
    
    func getRawCodeAndAbi(accountName: String, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_code_and_abi", requestParameters: ["account_name" : accountName], completion: completion)
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
    
    func getActions(requestParameters: EosioRpcHistoryActionsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_actions", requestParameters: requestParameters, completion: completion)
    }
    
    func getControlledAccounts(requestParameters: EosioRpcHistoryControlledAccountsRequest, completion:@escaping (EosioResult<EosioRpcResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "history/get_controlled_accounts", requestParameters: requestParameters, completion: completion)
    }
    
    
    
    
    
    
}

