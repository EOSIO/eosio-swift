//
//  EosioUInt64.swift
//  EosioSwift
//
//  Created by Steve McCoole on 5/1/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Meta type that can hold a 64 bit unsigned value that can come from the server as a UInt64 or a String.
public enum EosioUInt64: Codable {
    /// Value as a `UInt64`.
    case uint64(UInt64)
    /// Value as a `String`.
    case string(String)

    public var value: UInt64 {
        switch self {
        case .uint64(let value):
            return value
        case .string(let str):
            let val: UInt64? = UInt64(str)
            return val ?? 0
        }
    }

    /// Initialize from a decoder, attempting to decode as a `UInt64` first. If that is unsuccessful, attempt to decode as `String`.
    ///
    /// - Parameter decoder: Decoder to read from.
    /// - Throws: DecodingError if the value cannot be decoded as `UInt64` or `String`.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .uint64(container.decode(UInt64.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(EosioUInt64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    /// Encode to an encoder, attempting to encode as a `UInt64` first. If that is unsuccessful, attempt to encode as `String`.
    ///
    /// - Parameter encoder: Encoder to encode to.
    /// - Throws: EncodingError if the value cannot be encoded as `UInt64` or `String`.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .uint64(let uint64):
            try container.encode(uint64)
        case .string(let string):
            try container.encode(string)
        }
    }
}
