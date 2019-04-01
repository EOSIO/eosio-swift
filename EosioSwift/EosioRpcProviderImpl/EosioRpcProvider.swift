//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct EosioRpcProvider:EosioRpcProviderProtocol {
    
    private let endPoints:[URL]
    public init(endPoints:[URL]){
        self.endPoints = endPoints
    }
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        call(rpc: "chain/get_info", body: nil, callBack: completion)
    }
    
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        call(rpc: "chain/get_block", body: try? requestParameters.toJsonData(), callBack: completion)
    }
    
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        call(rpc: "chain/get_raw_abi", body: try? requestParameters.toJsonData(), callBack: completion)
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        call(rpc: "chain/get_required_keys", body: try? requestParameters.toJsonData(), callBack: completion)
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        call(rpc: "chain/push_transaction", body: try? requestParameters.toJsonData(convertToSnakeCase: true), callBack: completion)
    }
    
    
    private func call<T:Codable>(rpc:String, body:Data?, callBack:@escaping (EosioResult<T, EosioError>)->Void) {
        let url = URL(string: "v1/" + rpc, relativeTo: endPoints[0])!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                callBack(.failure(EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else{
                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server Error. Status Code: \(httpResponse.statusCode)")))
                return
            }
            
            if let data = data{
                let decoder = JSONDecoder()
                guard let resource = try? decoder.decode(T.self, from: data) else{
                    callBack(.failure(EosioError(.rpcProviderError, reason: "Error decoding returned data.")))
                    return
                }
                callBack(.success(resource))
            }
        }
        task.resume()
    }
}
