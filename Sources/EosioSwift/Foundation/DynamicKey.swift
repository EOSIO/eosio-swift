//
//  DynamicKey.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/22/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// CodingKey implementation that will allow for arbitrary String or Int key names in `Decodable` objects.
struct DynamicKey: CodingKey {

    /// Internal `String` value to represent the key.
    var stringValue: String

    /// Optional Internal `Int` value to represent the key.
    var intValue: Int?

    /// Initialize a new `DynamicKey` with the given `String` value.
    /// - Parameter stringValue: A `String` value to use as the key.
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    /// Initialize a new `DynamicKey` with the given `Int` value.
    /// - Parameter intValue: A `Int` value to use as the key
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    /// Initialize a new `DynamicKey` with the given `String` and `Int` value.
    /// - Parameter stringValue: A `String` value to use as the key.
    /// - Parameter intValue: A `Int` value to use as the key
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }

}

/// Implementation of a a `KeyedDecodingContainer` that will decode arbitrary JSON and return it represented as `[String: Any]`.
/// This should be used when the top level of the JSON to decode is a JSON Object.
extension KeyedDecodingContainer where Key == DynamicKey {

    // swiftlint:disable cyclomatic_complexity

    /// Cycle through all keys in the current container, decoding them as appropriate and returning the values as `AnyObject`.
    /// - Returns: `[String: Any]` representation of the current `KeyedDecodingContaier` contents.
    func decodeDynamicKeyValues() -> [String: Any] {
        var dict = [String: Any]()
        for key in allKeys {
            if let thing = try? decode(String.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(Bool.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(Int.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(Double.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(Float.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(UInt8.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(UInt16.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(UInt32.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? decode(UInt64.self, forKey: key) {
                dict[key.stringValue] = thing as AnyObject
            } else if let thing = try? nestedContainer(keyedBy: DynamicKey.self, forKey: key) {
                dict[key.stringValue] = thing.decodeDynamicKeyValues()
            } else if var thing = try? nestedUnkeyedContainer(forKey: key) {
                dict[key.stringValue] = thing.decodeDynamicValues()
            } else if let isNil = try? decodeNil(forKey: key), isNil {
                dict[key.stringValue] = NSNull() as AnyObject
            } else {
                print("Key \(key.stringValue) type not supported")
            }
        }
        return dict
    }
    // swiftlint:enable cyclomatic_complexity

}

/// Implementation of a a `UnkeyedDecodingContainer` that will decode arbitrary JSON and return it represented as `[Any]`.
/// This should be used when the top level of the JSON to decode is a JSON Array.
extension UnkeyedDecodingContainer {

    // swiftlint:disable cyclomatic_complexity

    /// Step through all elements in the current container, decoding them as appropriate and returning the values as `AnyObject`.
    /// - Returns: `[Any]` representation of the current `UnkeyedDecodingContaier` contents.
    mutating func decodeDynamicValues() -> [Any] {
        var array = [Any]()
        while isAtEnd == false {
            if let thing = try? decode(String.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(Bool.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(Int.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(Double.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(Float.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(UInt8.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(UInt16.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(UInt32.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? decode(UInt64.self) {
                array.append(thing as AnyObject)
            } else if let thing = try? nestedContainer(keyedBy: DynamicKey.self) {
                array.append(thing.decodeDynamicKeyValues())
            } else if var thing = try? nestedUnkeyedContainer() {
                array.append(thing.decodeDynamicValues())
            } else if let isNil = try? decodeNil(), isNil {
                array.append(NSNull() as AnyObject)
            } else {
                print("Type not supported")
            }
        }
        return array
    }
    // swiftlint:enable cyclomatic_complexity

}
