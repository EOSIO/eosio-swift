//
//  EosioRpcProviderImpl.swift
//  EosioSwift
//
//  Created by Ben Martell on 3/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public class EosioRpcProviderImpl :  EosioRpcProviderProtocol {
    
    public var endpoints: [EosioEndpoint]
    
    public var failoverRetries: Int
    
    public var primaryEndpoint: EosioEndpoint
    
    let session: URLSession
    
    public required init(endpoints: [EosioEndpoint], failoverRetries: Int) {
        self.endpoints = endpoints
        self.failoverRetries = failoverRetries
        self.primaryEndpoint = endpoints[0]
        self.session = URLSession(configuration: self.primaryEndpoint.configuration)
    }
   
    public func rpcRequest(request: URLRequest, completion: @escaping (EosioResult<EosioResponse, EosioError>) -> Void) {
            
        self.session.dataTask(with: request) { (data, response, error) in
                
            if let theError = error {
                    
                let eosioError = EosioError(EosioErrorCode.rpcProviderError, reason: "Error returned from rpcRequest call.", originalError: theError as NSError)
                    
                completion(EosioResult.failure(eosioError))
                    
            } else {
                    
                if let response = response as? HTTPURLResponse {
                        
                    if response.statusCode >= 200 && response.statusCode <= 299 {
                            
                        let eosioResponse = EosioResponse(data: data, httpResponse: response)
                        completion(EosioResult.success(eosioResponse))
                            
                    } else {
                            
                        completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "Unexpected HTTP status code: \(response.statusCode)")))
                    }
                        
                } else {
                    completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "No valid http response recieved.")))
                }
            }
        }.resume()
    }
    
    private func doRequestAndDecode<T:Decodable>(request: EosioRpcRouter, errorCode: EosioErrorCode, returnCompletion: @escaping (EosioResult<T, EosioError>) -> Void) {
        do {
            let req = try request.asUrlRequest()
            self.rpcRequest(request: req, completion: { result in
                switch result {
                case .success(let response):
                    returnCompletion(response.decodeJson())
                case .failure(let error):
                    returnCompletion(EosioResult.failure(error))
                }
            })
        } catch let error as EosioError{
            error.errorCode = errorCode
            returnCompletion(EosioResult.failure(error))
        } catch {
            returnCompletion(EosioResult.failure(EosioError(errorCode, reason: "EosioRequest: could not create EosioRequest.")))
        }
    }
    
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponse, EosioError>) -> Void) {
        self.doRequestAndDecode(request: EosioRpcRouter.getInfoRequest(endpoint: self.primaryEndpoint),
                                errorCode: EosioErrorCode.getInfoError,
                                returnCompletion: completion)
    }

    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void) {
        self.doRequestAndDecode(request: EosioRpcRouter.getBlockRequest(requestParameters: requestParameters,
                                                                 endpoint: self.primaryEndpoint),
                                errorCode: EosioErrorCode.getBlockError,
                                returnCompletion: completion)
    }
    
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void) {
        self.doRequestAndDecode(request: EosioRpcRouter.getRawAbiRequest(requestParameters: requestParameters,
                                                                  endpoint: self.primaryEndpoint),
                                errorCode: EosioErrorCode.getRawAbiError,
                                returnCompletion: completion)
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void) {
        self.doRequestAndDecode(request: EosioRpcRouter.getRequiredKeysRequest(requestParameters: requestParameters,
                                                                        endpoint: self.primaryEndpoint),
                                errorCode: EosioErrorCode.getRequiredKeysError,
                                returnCompletion: completion)
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void) {
        self.doRequestAndDecode(request: EosioRpcRouter.pushTransactionRequest(requestParameters: requestParameters,
                                                                        endpoint: self.primaryEndpoint),
                                errorCode: EosioErrorCode.pushTransactionError,
                                returnCompletion: completion)
    }
}
