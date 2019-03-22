//
//  EosioRequest.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public protocol EosioRequestConvertible {
    /// Returns a `EosioRequest` or throws if an `Error` was encoutered.
    ///
    /// - Returns: A `EosioRequest`.
    /// - Throws: Any error thrown while constructing the `EosioRequest`.
    func asEosioRequestRequest() throws -> EosioRequest
}

public class EosioRequest {
    public var url: URL
    public var method: EosioHttpMethod
    public var parameters: Codable?
    public var headers: [String:String]?
    
    init(url: URL, parameters: Codable? = nil, method: EosioHttpMethod = EosioHttpMethod.post,
         headers: [String:String]? = ["Content-Type":"application/json; charset=utf-8"]) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
    
    public func setValue(value: String, forHTTPHeaderField: String) {
        self.headers![forHTTPHeaderField] = value
    }
    
    public func getUrlRequest() -> URLRequest {
        let urlRequest = URLRequest(url: self.url)
        return urlRequest
    }
}
