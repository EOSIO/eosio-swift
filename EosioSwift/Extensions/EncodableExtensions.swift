//
//  EncodableExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public extension Encodable {
    
    
    /// Encodes an `Encodable` object as a json string
    ///
    /// - Parameters:
    ///   - convertToSnakeCase: should camelCase keys be converted to snake_case? (default = false)
    ///   - prettyPrinted: should the output be prettyPrinted? (default = false)
    /// - Returns: a json string
    /// - Throws: if the object cannot be encoded to json
    public func toJsonString(convertToSnakeCase: Bool = false, prettyPrinted: Bool = false) throws -> String  {
        let jsonData = try self.toJsonData(convertToSnakeCase: convertToSnakeCase, prettyPrinted: prettyPrinted)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw EosioError(.deserializeError, reason: "json data is not utf8 format")
        }
        return jsonString
    }
    
    /**
        Encodes an `Encodable` object as a json string
     
        - Parameters:
            - convertToSnakeCase: should camelCase keys be converted to snake_case? (default = false)
            - prettyPrinted: should the output be prettyPrinted? (default = false)
        - Returns: a Data object.
        - Throws: if the object cannot be encoded into a JSON object.
    */
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
    
    /// Encodces an `Encodable` object as a dictionary of type `[String:Any]`
    ///
    /// - Returns: a dictionary of type `[String:Any]`
    func toDictionary() -> [String:Any]? {
        guard let json = try? self.toJsonString() else { return nil }
        return json.toJsonDictionary
    }
    
}
