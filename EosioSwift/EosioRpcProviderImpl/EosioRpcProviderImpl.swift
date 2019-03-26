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
   
    public func rpcRequest(request: EosioRequest, completion: @escaping (EosioResult<EosioResponse, EosioError>) -> Void) {
        
        if let urlRequest = try? request.asUrlRequest() {
            
            self.session.dataTask(with: urlRequest) { (data, response, error) in
                
                if let theError = error {
                    
                    let eosioError = EosioError(EosioErrorCode.rpcProviderError, reason: "Error returned from rpcRequest call.", originalError: theError as NSError)
                    
                    completion(EosioResult.failure(eosioError))
                    
                } else {
                    
                    if let response = response as? HTTPURLResponse {
                        
                        if response.statusCode == 200 {
                            
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

        } else {
            
            completion(EosioResult.failure(EosioError(EosioErrorCode.rpcProviderError, reason: "EosioRequest: could not convert to URLRequest")))
        }
        

    }
    
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfo, EosioError>) -> Void) {
        
        do {
           let request = try EosioRpcRouter.getInfo(endpoint: self.primaryEndpoint).asEosioRequest()
            
            self.rpcRequest(request: request, completion: { result in
                
                switch result {
                case .success(let response):
                    completion(response.decodeJson())
                case .failure(let error):
                    completion(EosioResult.failure(error))
                }
            })
            
        } catch let error as EosioError{
            error.errorCode = EosioErrorCode.getInfoError
            completion(EosioResult.failure(error))
        } catch {
            completion(EosioResult.failure(EosioError(EosioErrorCode.getBlockError, reason: "EosioRequest: could not create EosioRequest.")))
        }
    }

    public func getBlock(requestParameters: EosioBlockRequest, completion: @escaping (EosioResult<EosioRpcBlock, EosioError>) -> Void) {
        
        if let request = try? EosioRpcRouter.getBlock(requestParameters: requestParameters, endpoint: self.primaryEndpoint).asEosioRequest() {
            
            self.rpcRequest(request: request, completion: { result in
                
                switch result {
                case .success(let response):
                    completion(response.decodeJson())
                case .failure(let error):
                    completion(EosioResult.failure(error))
                }
            })
            
        } else {
            
            completion(EosioResult.failure(EosioError(EosioErrorCode.getBlockError, reason: "EosioRequest: could not create EosioRequest.")))
        }
    }
    
    public func getRawAbi(requestParameters: EosioRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbi, EosioError>) -> Void) {
        
        if let request = try? EosioRpcRouter.getRawAbi(requestParameters: requestParameters, endpoint: self.primaryEndpoint).asEosioRequest() {
            
            self.rpcRequest(request: request, completion: { result in
                
                switch result {
                case .success(let response):
                    completion(response.decodeJson())
                case .failure(let error):
                    completion(EosioResult.failure(error))
                }
            })
            
        } else {
            
            completion(EosioResult.failure(EosioError(EosioErrorCode.getRawAbiError, reason: "EosioRequest: could not create EosioRequest.")))
        }
        
    }
    
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeys, EosioError>) -> Void) {
        
        if let request = try? EosioRpcRouter.getRequiredKeys(requestParameters: requestParameters, endpoint: self.primaryEndpoint).asEosioRequest() {
            
            self.rpcRequest(request: request, completion: { result in
                
                switch result {
                case .success(let response):
                    completion(response.decodeJson())
                case .failure(let error):
                    completion(EosioResult.failure(error))
                }
            })
            
        } else {
            
            completion(EosioResult.failure(EosioError(EosioErrorCode.getRequiredKeysError, reason: "EosioRequest: could not create EosioRequest.")))
        }
        
    }
    
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransaction, EosioError>) -> Void) {
        
        if let request = try? EosioRpcRouter.pushTransaction(requestParameters: requestParameters, endpoint: self.primaryEndpoint).asEosioRequest() {
            
            self.rpcRequest(request: request, completion: { result in
                
                switch result {
                case .success(let response):
                    completion(response.decodeJson())
                case .failure(let error):
                    completion(EosioResult.failure(error))
                }
            })
            
        } else {
            
            completion(EosioResult.failure(EosioError(EosioErrorCode.getRequiredKeysError, reason: "EosioRequest: could not create EosioRequest.")))
        }
        
    }
}
