//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct EosioRpcProvider:EosioRpcProviderProtocol {
    private let endPoint:URL
    public init(endPoint:URL){
        self.endPoint = endPoint
    }
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        call(rpc: "get_info", body: nil, callBack: completion)
        print("\(#function) called")
    }
    
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        call(rpc: "get_block", body: requestParameters.toDictionary(), callBack: completion)
        print("\(#function) called")
    }
    
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        call(rpc: "get_raw_abi", body: requestParameters.toDictionary(), callBack: completion)
        print("\(#function) called")
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        call(rpc: "get_required_keys", body: requestParameters.toDictionary(), callBack: completion)
        print("\(#function) called")
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        call(rpc: "push_transaction", body: requestParameters.toDictionary(), callBack: completion)
        print("\(#function) called")
    }
    
    
    private func call<T:Codable>(rpc:String, body:[String: Any]?, callBack:@escaping (EosioResult<T, EosioError>)->Void){
        let url = URL(string: rpc, relativeTo: endPoint)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let body = body{
            let jsonData = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't access network.", originalError: error as NSError)))
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                callBack(.failure(EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else{
                callBack(EosioResult.failure(EosioError(.rpcProviderError, reason: "Server Error. Status Code: \(httpResponse.statusCode)")))
                print("Server error")
                return
            }
            
            
            if let data = data{
                let decoder = JSONDecoder()
                guard let resource = try? decoder.decode(T.self, from: data) else{
                    callBack(.failure(EosioError(.rpcProviderError, reason: "Error decoding returned data.")))
                    print("Error Parsing data")
                    return
                }
               
                callBack(.success(resource))
            }
        }
        task.resume()
    }
}
