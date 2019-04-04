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
        call(rpc: "chain/get_info", requestParameters: nil){(result: EosioRpcInfoResponse?, error:EosioError?) in
            if let result = result{
                completion(EosioResult.success(result))
            }
            
            if let error = error{
                completion(EosioResult.failure(error))
            }
        }
    }
    
    func gr<T>(r:EosioResult<T, EosioError>) {
        
    }
    
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        call(rpc: "chain/get_block", requestParameters: requestParameters, callBack: completion)
    }
    
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        call(rpc: "chain/get_raw_abi", requestParameters: requestParameters, callBack: completion)
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        call(rpc: "chain/get_required_keys", requestParameters: requestParameters, callBack: completion)
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        call(rpc: "chain/push_transaction", requestParameters: requestParameters, callBack: completion)

    }
    
    
    private func call<T:Codable>(rpc:String, requestParameters:Encodable?, callBack:@escaping (T?, EosioError?)->Void) {
        let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestParameters = requestParameters {
            do {
                let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                request.httpBody = jsonData
            } catch {
//                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError)))
                callBack(nil, EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
//                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError)))
                callBack(nil, EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else{
//                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil)))
                callBack(nil, EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else{
//                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server Error. Status Code: \(httpResponse.statusCode) Response: \(httpResponse.description)")))
                callBack(nil, EosioError(.rpcProviderError, reason: "Server Error. Status Code: \(httpResponse.statusCode) Response: \(httpResponse.description)", originalError: nil))
                return
            }

            if let data = data{
                let decoder = JSONDecoder()
                guard let resource = try? decoder.decode(T.self, from: data) else{
//                    callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Error decoding returned data.")))
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error decoding returned data.", originalError: nil))
                    return
                }
                callBack(resource, nil)
            }
        }
        task.resume()
    }
}
