//
//  DictionaryExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2018-2019 block.one. 
//

import Foundation

public extension Dictionary {
    
    /**
        Encodes the dictionary to a JSON string.
 
        - Returns: A JSON string representation of the dictionary or nil if the dictionary can't be encoded to a JSON string.
    */
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.sortedKeys]) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
}

