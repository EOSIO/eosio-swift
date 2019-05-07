//
//  ArrayExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Extensions to `Array` that are used in `EosioSwift`.
public extension Array where Element == URLQueryItem {

    /// Converts current array of `URLQueryItem` to a dictionary of `URLQueryItem` values, keyed by `URLQueryItem` names.
    /// - Returns: Dictionary of `URLQueryItem` values, keyed by `URLQueryItem` names.
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

public extension Array {
    /// Converts current array of arbitrary objects to a JSON `String` or nil if it cannot be converted.
    /// - Returns: Optional JSON String representation of the input or nil if it cannot be converted.
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

public extension Array where Element == String {

    /// Converts current array of `String` to a JSON `String` or an empty JSON Array `String` if it cannot be converted/.
    /// - Returns: JSON `String` representation of the input or an empty JSON Array `String` if it cannot be converted.
    var jsonStringArray: String {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: []), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }

        return "[]"
    }

}

/// Protocol that defines objects that can return a JSON `String` representation of themselves.
public protocol JsonOutput {
    /// Computed variable to access the JSON `String` representation of the current object.
    var json: String { get }
}

public extension Array where Element == JsonOutput {
    /// Returns JSON `String` representation of an `Array` where the element type conforms to `JsonOutput` protocol or an empty JSON Array `String` if it cannot be converted..
    /// - Returns: JSON `String` representation of the input or an empty JSON Array `String` if it cannot be converted.
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
