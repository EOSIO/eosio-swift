//
//  RIPEMD160Tests.swift
//  EosioSwiftTests
//
//  Created by Steve McCoole on 3/7/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift

class RIPEMD160Tests: XCTestCase {
    let ripemd160TestStrings = [
        ("", "9c1185a5c5e9fc54612808977ee8f548b2258d31"),
        ("The quick brown fox jumps over the lazy dog", "37f332f68db77bd9d7edd4969571ad671cf9dd3b"),
        ("The quick brown fox jumps over the lazy cog", "132072df690933835eb8b6ad0b77e7b6f14acad7")
    ]

    func testEncodeRIPEMD160Strings() {
        for (decoded, encoded) in ripemd160TestStrings {

            let hash = RIPEMD160.hash(message: decoded)
            let result = hash.hexEncodedString()

            XCTAssertEqual(result, encoded, "Expected encoded string: \(encoded) received: \(result)")
        }
    }
}
