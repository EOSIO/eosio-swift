//
//  DynamicKey.swift
//  EosioSwift
//
//  Created by Steve McCoole on 4/22/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

struct DynamicKey: CodingKey {

    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int? { return nil }

    init?(intValue: Int) { return nil }

}

extension KeyedDecodingContainer where Key == DynamicKey {

    // swiftlint:disable cyclomatic_complexity
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
            } else if let _ = try? decodeNil(forKey: key) {
                dict[key.stringValue] = NSNull() as AnyObject
            } else {
                print("Key \(key.stringValue) type not supported")
            }
        }
        return dict
    }
    // swiftlint:enable cyclomatic_complexity

}

extension UnkeyedDecodingContainer {

    // swiftlint:disable cyclomatic_complexity
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
            } else if let _ = try? decodeNil() {
                array.append(NSNull() as AnyObject)
            } else {
                print("Type not supported")
            }
        }
        return array
    }
    // swiftlint:enable cyclomatic_complexity

}
