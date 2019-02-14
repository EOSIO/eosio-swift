//
//  SerializedEosioTransaction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/14/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

struct SerializedEosioTransaction: Codable {
    var signatures = [String]()
    var compression: Int = 0
    var packedContextFreeData = ""
    var packedTrx =  ""
    
    var json: String? {
        return try? self.toJsonString(convertToSnakeCase: true, prettyPrinted: false)
    }
}
