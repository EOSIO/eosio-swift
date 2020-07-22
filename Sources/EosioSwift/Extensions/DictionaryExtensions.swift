//
//  DictionaryExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

public extension Dictionary {

    /// Returns a JSON string representation of the dictionary or nil if the dictionary can't be encoded to a JSON string.
    var jsonString: String? {
        guard JSONSerialization.isValidJSONObject(self),
            let jsonData = try? JSONSerialization.data(withJSONObject: self, options: [.sortedKeys]) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

}
