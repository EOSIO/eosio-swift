//
//  EosioInt64.swift
//  EosioSwift

//  Created by Steve McCoole on 8/15/19
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Meta type that can hold a 64 bit signed value that can come from the server as a Int64 or a String.
public enum EosioInt64: Codable {
    /// Value as a `Int64`.
    case int64(Int64)
    /// Value as a `String`.
    case string(String)

    public var value: Int64 {
        switch self {
        case .int64(let value):
            return value
        case .string(let str):
            let val: Int64? = Int64(str)
            return val ?? 0
        }
    }

    /// Initialize from a decoder, attempting to decode as a `Int64` first. If that is unsuccessful, attempt to decode as `String`.
    ///
    /// - Parameter decoder: Decoder to read from.
    /// - Throws: DecodingError if the value cannot be decoded as `Int64` or `String`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int64(container.decode(Int64.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(EosioInt64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    /// Encode to an encoder, attempting to encode as a `Int64` first. If that is unsuccessful, attempt to encode as `String`.
    ///
    /// - Parameter encoder: Encoder to encode to.
    /// - Throws: EncodingError if the value cannot be encoded as `Int64` or `String`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int64(let int64):
            try container.encode(int64)
        case .string(let string):
            try container.encode(string)
        }
    }
}
