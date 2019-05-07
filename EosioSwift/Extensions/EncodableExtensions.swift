//
//  EncodableExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

public extension Encodable {

    /// Encodes an `Encodable` object as a json string.
    ///
    /// - Parameters:
    ///   - convertToSnakeCase: Should camelCase keys be converted to snake_case? (default = false)
    ///   - prettyPrinted: Should the output be prettyPrinted? (default = false)
    /// - Returns: A json string.
    /// - Throws: If the object cannot be encoded to json.
    func toJsonString(convertToSnakeCase: Bool = false, prettyPrinted: Bool = false) throws -> String {
        let jsonData = try self.toJsonData(convertToSnakeCase: convertToSnakeCase, prettyPrinted: prettyPrinted)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw EosioError(.deserializeError, reason: "json data is not utf8 format")
        }
        return jsonString
    }

    /// Encodes an `Encodable` object as a json string.
    ///
    /// - Parameters:
    ///   - convertToSnakeCase: Should camelCase keys be converted to snake_case? (default = false)
    ///   - prettyPrinted: Should the output be prettyPrinted? (default = false)
    /// - Returns: A Data object.
    /// - Throws: If the object cannot be encoded into a JSON object.
    func toJsonData(convertToSnakeCase: Bool = false, prettyPrinted: Bool = false) throws -> Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.sortedKeys]

        if prettyPrinted {
            jsonEncoder.outputFormatting.insert(.prettyPrinted)
        }
        if convertToSnakeCase {
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        }
        jsonEncoder.dateEncodingStrategy = .formatted(Date.asTransactionTimestamp)
        return try jsonEncoder.encode(self)
    }

    /// Encodes an `Encodable` object as a dictionary of type `[String: Any]`.
    ///
    /// - Returns: A dictionary of type `[String: Any]`.
    func toDictionary() -> [String: Any]? {
        guard let json = try? self.toJsonString() else { return nil }
        return json.toJsonDictionary
    }

    /// Encodes an `Encodable` object as a array of type `[Any]`.
    ///
    /// - Returns: A dictionary of type `[Any]`.
    func toArray() -> [Any]? {
        guard let json = try? self.toJsonString() else { return nil }
        return json.toJsonArray
    }

}
