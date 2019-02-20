//
//  EosioRequest.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public class EosioRequest {
    public var function: String
    public var method: EosioHttpMethod
    public var parameters: Codable?
    public var headers: [String:String]?
    
    init(function: String, parameters: Codable? = nil, method: EosioHttpMethod = EosioHttpMethod.post,
         headers: [String:String]? = ["Content-Type":"application/json; charset=utf-8"]) {
        self.function = function
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
