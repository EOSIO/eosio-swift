//
//  EncodableExtensionTests.swift
//  EosioSwiftFoundationTests
//
//  Created by Todd Bowden on 2/11/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

import XCTest
@testable import EosioSwift

class EncodableExtensionTests: XCTestCase {
    

    
    func testToJsonString() {
        let encodableStruct = makeEncodableStruct()
        guard let json1 = try? encodableStruct.toJsonString(convertToSnakeCase: false, prettyPrinted: false) else {
            return XCTFail()
        }
    
        let json2 = """
        {"aaAa":"aa","b_bb":-42,"cCcc":999999999,"ddDd":true,"eeee":"2009-01-03T18:15:05.000","ffff":["aa","bbb","cccc"],"g_Gg":[-7,0,7],"hh_h":{"a":0,"b":21},"iiii":{"aa":{"bb":-7},"cc":{"dd":7}},"jjjj":[{"aaa":"bbb"},{"ccc":"ddd"}]}
        """
        XCTAssertTrue(json1 == json2)
    }
    
    func testToJsonStringSnakeCase() {
        let encodableStruct = makeEncodableStruct()
        guard let json1 = try? encodableStruct.toJsonString(convertToSnakeCase: true, prettyPrinted: false) else {
            return XCTFail()
        }
      
        let json2 = """
        {"aa_aa":"aa","b_bb":-42,"c_ccc":999999999,"dd_dd":true,"eeee":"2009-01-03T18:15:05.000","ffff":["aa","bbb","cccc"],"g__gg":[-7,0,7],"hh_h":{"a":0,"b":21},"iiii":{"aa":{"bb":-7},"cc":{"dd":7}},"jjjj":[{"aaa":"bbb"},{"ccc":"ddd"}]}
        """
        XCTAssertTrue(json1 == json2)
    }
    
    func testToDictionary() {
        let encodableStruct = makeEncodableStruct()
        guard let dict = encodableStruct.toDictionary() else {
            return XCTFail()
        }
        XCTAssertTrue(dict["aaAa"] as? String == "aa")
        XCTAssertTrue(dict["b_bb"] as? Int == -42)
        XCTAssertTrue(dict["cCcc"] as? UInt64 == 999999999)
        XCTAssertTrue(dict["ddDd"] as? Bool == true)
        let dateString = dict["eeee"] as! String
        XCTAssertTrue(Date(yyyyMMddTHHmmss: dateString)! == Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!)
        XCTAssertTrue(dict["ffff"] as? [String] == ["aa","bbb","cccc"])
        XCTAssertTrue(dict["g_Gg"] as? [Int] == [-7,0,7])
        XCTAssertTrue(dict["hh_h"] as? [String:Int] == [
            "a" : 0,
            "b": 21
        ])
        XCTAssertTrue(dict["iiii"] as? [String:[String:Int]] == [
            "aa" : ["bb" : -7],
            "cc" : ["dd" : 7]
        ])
        XCTAssertTrue(dict["jjjj"] as? [[String:String]] == [
            ["aaa" : "bbb"],
            ["ccc" : "ddd"]
        ])
    }
    
    struct EncodableStruct: Encodable {
        var aaAa: String
        var b_bb: Int
        var cCcc: UInt64
        var ddDd: Bool
        var eeee: Date
        var ffff: [String]
        var g_Gg: [Int]
        var hh_h: [String:Int]
        var iiii: [String:[String:Int]]
        var jjjj: [[String:String]]
    }
    
    
    func makeEncodableStruct() -> EncodableStruct {
        let complexData = EncodableStruct(
            aaAa: "aa",
            b_bb: -42,
            cCcc: 999999999,
            ddDd: true,
            eeee: Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!,
            ffff: ["aa","bbb","cccc"],
            g_Gg: [-7,0,7],
            hh_h: [
                "a" : 0,
                "b": 21],
            iiii: [
                "aa" : ["bb" : -7],
                "cc" : ["dd" : 7]
                ],
            jjjj: [
                ["aaa" : "bbb"],
                ["ccc" : "ddd"]
            ]
        )
        return complexData
    }
    
}
