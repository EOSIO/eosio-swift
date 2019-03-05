//
//  EosioTransactionRequest.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/14/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public struct EosioTransactionRequest: Codable {
    public var signatures = [String]()
    public var compression: Int = 0
    public var packedContextFreeData = ""
    public var packedTrx =  ""
    
    public var isSigned: Bool {
        return signatures.count > 0
    }
    
    public var json: String? {
        return try? self.toJsonString(convertToSnakeCase: true, prettyPrinted: false)
    }
    
    public init() {
        
    }
}
