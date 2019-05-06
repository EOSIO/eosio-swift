//
//  DataExtensionsTests.swift
//  EosioSwiftTests
//
//  Created by Farid Rahmani on 2/21/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest
@testable import EosioSwift

class DataExtensionsTests: XCTestCase {

    func test_hexEncodedString_shouldReturnCorrectHexEncodedString() {
        let hex = "this is some sample string".data(using: .utf8)!.hexEncodedString()
        XCTAssertEqual(hex, "7468697320697320736f6d652073616d706c6520737472696e67")
    }

    func test_initWithBase64_withValidBase64StringArgument_shouldSucceed() {
        XCTAssertNoThrow(try Data(base64: "VGhpcyBpcyBzb21lIHNhbXBsZSB0ZXh0"))
    }

    func test_initWithBase64_withInvalidStringArgument_shouldThrowAnError() {
        XCTAssertThrowsError(try Data(base64: "some invalid string"))
    }

    func test_initWithHex_withValidHexStringArgument_shouldSucceed() {
        XCTAssertNoThrow(try Data(hex: "b630face96ba9b661ed026eb740e8995abf73c0169e801878713c9dea049b972"))
    }

    func test_initWithHex_withInvalidHexStringArgument_shouldThrowAnError() {
        XCTAssertThrowsError(try Data(hex: "some non-hex string"))
    }

    func test_initWithHexString_withValidHexString_shouldSucceed() {
        let data = Data(hexString: "b630face96ba9b661ed026eb740e8995abf73c0169e801878713c9dea049b972")
        XCTAssertNotNil(data)
    }

    func test_initWithHexString_withInvalidStringArgument_shouldReturnNil() {
        let data = Data(hexString: "Some invalid string")
        XCTAssertNil(data)
    }

    func test_sha256_shouldReturnCorrectHash() {
        let hashedData = "Some sample text".data(using: .utf8)!.sha256
        let hexString = hashedData.hexEncodedString()
        XCTAssertEqual(hexString, "b630face96ba9b661ed026eb740e8995abf73c0169e801878713c9dea049b972")
    }

}
