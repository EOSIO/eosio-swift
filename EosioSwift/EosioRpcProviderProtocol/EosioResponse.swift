//
//  EosioResponse.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation


public class EosioResponse {
    public var data: Data?
    public var statusCode: Int
    public var httpResponse: HTTPURLResponse?
    
    var string: String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    init(data: Data? = nil, statusCode: Int = 0, httpResponse: HTTPURLResponse? = nil) {
        self.data = data
        self.statusCode = statusCode
        self.httpResponse = httpResponse
    }
    
    func decodeJson<T:Decodable>() -> EosioResult<T, EosioError> {
        guard let data = data else {
            return EosioResult.failure(EosioError(EosioErrorCode.parsingError, reason: "Empty data sent."))
        }
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let json = string {
            let jsonKey = CodingUserInfoKey(rawValue: "json")!
            decoder.userInfo[jsonKey] = json
        }
        
        do {
            let rpcResponse = try decoder.decode(T.self, from: data)
            return EosioResult.success(rpcResponse)
        }
        catch {
            return EosioResult.failure(EosioError(EosioErrorCode.parsingError, reason: error.localizedDescription))
        }
    }
}
