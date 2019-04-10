//
//  ArrayExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

// Was QueryItems+dictionary.swift
public extension Array where Element == URLQueryItem {

    var dictionary: [String: String] {
        var dict = [String: String]()
        for item in self {
            if let value = item.value {
                dict[item.name] = value
            }
        }
        return dict
    }
}

// From JsonExtensions.swift
public extension Array {
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

public extension Array where Element == String {
    /**
     Returns JSON String representation of an array.
     */
    var jsonStringArray: String {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }

        return "[]"
    }

}

// From JsonOutput.swift
public protocol JsonOutput {
    var json: String { get }
}

public extension Array where Element == JsonOutput {
    /**
     Returns JSON string representation of an array where the element type conforms to JsonOutput protocol.
     */
    var json: String {
        guard self.count > 0 else {
            return "[]"
        }
        var json = "[\n"
        for (i, element) in self.enumerated() {
            json += element.json
            if i < self.count - 1 {
                json += ","
            }
            json += "\n"
        }
        json += "]"
        return json
    }

}
