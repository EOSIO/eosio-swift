//
//  SerializedEosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/14/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct SerializedEosioTransaction: Codable {
    public var signatures = [String]()
    public var compression: Int = 0
    public var packedContextFreeData = ""
    public var packedTrx =  ""
    
    public var json: String? {
        return try? self.toJsonString(convertToSnakeCase: true, prettyPrinted: false)
    }
}
