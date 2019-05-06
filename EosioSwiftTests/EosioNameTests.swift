//
//  EosioNameTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 2/3/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest
@testable import EosioSwift

class EosioNameTests: XCTestCase {

    struct TestStruct: Codable {
        var name: EosioName
    }

    func testValidEosioNames() {
        XCTAssertNotNil(try? EosioName("a"))
        XCTAssertNotNil(try? EosioName("ab"))
        XCTAssertNotNil(try? EosioName("abc"))
        XCTAssertNotNil(try? EosioName("abc12345"))
        XCTAssertNotNil(try? EosioName("1"))
        XCTAssertNotNil(try? EosioName("12345"))
        XCTAssertNotNil(try? EosioName("a.b"))
        XCTAssertNotNil(try? EosioName("a.b.c"))
        XCTAssertNotNil(try? EosioName("a.1.b.c.d"))
        XCTAssertNotNil(try? EosioName("abcd.12345"))
        XCTAssertNotNil(try? EosioName("abcd.12345.z"))
    }

    func testInvalidEosioNames() {
        XCTAssertNil(try? EosioName(""))
        XCTAssertNil(try? EosioName("."))
        XCTAssertNil(try? EosioName(".a"))
        XCTAssertNil(try? EosioName("1."))
        XCTAssertNil(try? EosioName("0"))
        XCTAssertNil(try? EosioName("6"))
        XCTAssertNil(try? EosioName("A"))
        XCTAssertNil(try? EosioName("a..b"))
        XCTAssertNil(try? EosioName("a1..b"))
        XCTAssertNil(try? EosioName("a...b"))
        XCTAssertNil(try? EosioName("a.1..b"))
        XCTAssertNil(try? EosioName("abc123456"))
        XCTAssertNil(try? EosioName("abC12345"))
        XCTAssertNil(try? EosioName("abc12345."))
        XCTAssertNil(try? EosioName("abc1234..5"))
        XCTAssertNil(try? EosioName("abc.def.12345"))
        XCTAssertNil(try? EosioName("abc.!"))
        XCTAssertNil(try? EosioName("@"))
    }

    func testDeocdeEncodeEosioName() {
        let decoder = JSONDecoder()

        let jsonValid = """
        {"name":"abc"}
        """
        guard let structValid = try? decoder.decode(TestStruct.self, from: jsonValid.data(using: .utf8)!) else {
            return XCTFail("Failed to decode JSON")
        }
        XCTAssert(structValid.name.string == "abc")
        XCTAssert(try structValid.name == EosioName("abc"))

        let jsonInvalid = """
        {"name":"abc."}
        """
        XCTAssertNil(
            try? decoder.decode(TestStruct.self, from: jsonInvalid.data(using: .utf8)!)
        )

        let encoder = JSONEncoder()

        guard let json = try? encoder.encode(structValid) else {
            return XCTFail("Failed to encode JSON")
        }
        XCTAssert(String(data: json, encoding: .utf8) == jsonValid)
    }

}
