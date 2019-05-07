//
//  StringExtensionsTests.swift
//  EosioSwiftTests
//
//  Created by Farid Rahmani on 2/25/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest
@testable import EosioSwift

class StringExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initEncodeToJson_withValidJsonObject_shouldReturnCorrectJsonString() {
        let jsonObject = ["name": "Tom", "job_title": "Software Developer"]
        guard let jsonString = try? String(encodeToJson: jsonObject) else {
            return XCTFail("Failed to convert JSON to String()")
        }
        XCTAssertEqual(jsonString, "{\n  \"job_title\" : \"Software Developer\",\n  \"name\" : \"Tom\"\n}")
    }

    func test_initEncodeToJson_withInvalidJsonObject_shouldThrowAnError() {
        let obj = ["Salary": Float.infinity]
        XCTAssertThrowsError(try String(encodeToJson: obj))
    }

    func test_containsWords() {
        let string = "Hello world good day!"
        XCTAssertTrue(string.contains(words: "Hello"))
        XCTAssertTrue(string.contains(words: "Hello day!"))
        XCTAssertFalse(string.contains(words: "Hello bad day!"))
    }

}
