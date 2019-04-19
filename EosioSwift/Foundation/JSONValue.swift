//
//  JSONValue.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/19/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public enum JSONValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case uint8(UInt8)
    case uint16(UInt16)
    case uint32(UInt32)
    case uint64(UInt64)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    // swiftlint:disable cyclomatic_complexity
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case let .array(array):
            try container.encode(array)
        case let .object(object):
            try container.encode(object)
        case let .string(string):
            try container.encode(string)
        case let .int(int):
            try container.encode(int)
        case let .double(double):
            try container.encode(double)
        case let .bool(bool):
            try container.encode(bool)
        case let .uint8(uint8):
            try container.encode(uint8)
        case let .uint16(uint16):
            try container.encode(uint16)
        case let .uint32(uint32):
            try container.encode(uint32)
        case let .uint64(uint64):
            try container.encode(uint64)
        case .null:
            try container.encodeNil()
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(UInt8.self) {
            self = .uint8(value)
        } else if let value = try? container.decode(UInt16.self) {
            self = .uint16(value)
        } else if let value = try? container.decode(UInt32.self) {
            self = .uint32(value)
        } else if let value = try? container.decode(UInt64.self) {
            self = .uint64(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(JSONValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSONValue"))
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
