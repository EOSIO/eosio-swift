//
//  DictionaryExtensionTests.swift
//  EosioSwiftTests

//  Created by Paul Kim on 10/22/19
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest

class DictionaryExtensionTests: XCTestCase {

    func testJsonStringWithValidDictionaryReturnsCorrectJsonString() {
        let dict: [String: Any?] = ["string": "string",
                                   "integer": 1,
                                   "nil": nil,
                                   "array": ["a", "b", "c"],
                                   "dict": ["key": "value"]]
        let expectedJsonString = "{\"array\":[\"a\",\"b\",\"c\"],\"dict\":{\"key\":\"value\"},\"integer\":1,\"nil\":null,\"string\":\"string\"}"

        guard let resultingJsonString = dict.jsonString else {
            return XCTFail("jsonString on valid dictionary returns nil.")
        }
        XCTAssertEqual(resultingJsonString, expectedJsonString)
    }

    func testJsonStringWithInvalidDictionaryReturnsNil() {
        let dict: [String: Any?] = ["string": "string",
                                   "integer": 1,
                                   "nil": nil,
                                   "array": ["a", "b", "c"],
                                   "dict": ["key": "value"],
                                   "enum": Calendar.Identifier.gregorian]

        let resultingJsonString = dict.jsonString
        XCTAssertNil(resultingJsonString, "jsonString on invalid dictionary returns non-nil.")
    }

}
