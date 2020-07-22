//
//  StringExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

public extension String {

    /// Returns the domain (host) component of a url.
    var urlDomain: String? {
        var string = self
        if !string.contains("://") {
            string = "http://" + string
        }
        return URL(string: string)?.host
    }

    /// Slices the string starting from `from` and ending at the start of the `to` string.
    ///
    /// - Parameters:
    ///   - from: The begining of the slice.
    ///   - to: The end of the slice.
    /// - Returns: String?
    func slice(from: String, to: String) -> String? { // swiftlint:disable:this identifier_name
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }

    /// Returns all the strings that match a regular expression.
    ///
    /// - Parameter regex: The string to use as a regular expression.
    /// - Returns: An array of all the matched string or empty if no match were found.
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))

        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }

    /// Is the string an absolute URL?
    ///
    /// - Returns: Returns `true` if the string is an absolute URL else returns `false`.
    func isAbsoluteURL() -> Bool {
        return self.lowercased().contains("http://") || self.lowercased().contains("https://")
    }

    /// Converts the string to a dictionary if it is convertible to a dictionary (i.e., it is a JSON string.) and returns the dictionary. Otherwise, returns `nil`.
    var toJsonDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        let dict = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? [String: Any]
        return dict
    }

    /// Converts the string to a array if it is convertible to a array (i.e., it is a JSON string.) and returns the array. Otherwise, returns `nil`.
    var toJsonArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        let array = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)) as? [Any]
        return array
    }

    /// Converts the string to a dictionary if it is convertible to a dictionary (i.e., it is a JSON string).
    ///
    /// - Returns: A dictionary if the text is a JSON string and convertible to a dictionary otherwise returns `nil`.
    /// - Throws: A `EosioError` if the string can not be converted to a dictionary.
    func jsonToDictionary() throws -> [String: Any] {
        guard let data = self.data(using: .utf8) else {
            throw EosioError(.deserializeError, reason: "Cannot create json from data")
        }

        guard let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments), let dict = result as? [String: Any] else {
            throw EosioError(.deserializeError, reason: "Cannot create dictionary from json")
        }
        return dict
    }

    /// Converts an object to a JSON string if possible.
    ///
    /// - Parameter jsonObject: An object to convert to JSON string.
    /// - Returns: A string if the object is convertible to JSON string or nil.
    static func jsonString(jsonObject: Any?) -> String? {
        guard let object = jsonObject else { return nil }
        if let string = object as? String {
            return string
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: object, options: []), let string = String(data: jsonData, encoding: .utf8) {
            return string
        }
        return nil
    }

    /// Initializes a string from an object that conforms to `Encodable` protocol.
    ///
    /// - Parameter encodeToJson: An object that conforms to `Encodable` protocol.
    /// - Throws: EosioError if the passed object is not convertible to JSON string.
    init<T: Encodable>(encodeToJson: T) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let data = try encoder.encode(encodeToJson)
        if let string = String(data: data, encoding: .utf8) {
            self = string
        } else {
            throw EosioError(.serializeError, reason: "Cannot create json from data \(data.hexEncodedString())")
        }
    }

    /// - Returns: Bool indicating whether the current string is a validly encode base58 string.
    var isValidBase58: Bool {
        guard Data(base58Decoding: self) != nil else {
            return false
        }
        return true
    }

    /// Does the string contain all of the provided words?
    ///
    /// - Parameter words: Words to look for in the string.
    /// - Returns: `true` if the string contains all of the words in `words`. Otherwise, false.
    func contains(words: String) -> Bool {
        guard self.count > 0, words.count > 0 else { return false }
        let components = self.components(separatedBy: " ")
        for word in words.components(separatedBy: " ") {
            if !components.contains(word) {
                return false
            }
        }
        return true
    }
}
