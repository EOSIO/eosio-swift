//
//  EosioTransactionActionTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 2/6/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift
@testable import EosioSwiftFoundation
@testable import EosioSwiftC

class EosioTransactionActionTests: XCTestCase {
    
    
    func testNewTransferActionWithEosioNames() {
        XCTAssertNotNil(try? makeTransferActionWithEosioNames())
    }
    
    func testNewTransferActionWithStrings() {
        XCTAssertNotNil(try? makeTransferActionWithStrings())
    }
    
    func testNewTransferActionError() {
        do {
            try _ = makeTransferActionWithError()
            XCTFail()
        } catch {
            XCTAssertTrue(error.localizedDescription == "eosioNameError: eosio.token6 is not a valid eosio name.")
        }
    }
    
    func testActionSerializeData() {
        
        guard var action = try? makeTransferActionWithEosioNames() else {
            return XCTFail()
        }
        guard let tokenAbiJson = getTokenAbiJson() else {
            return XCTFail()
        }
        // serialize the data struct
        try? action.serializeData(abi: tokenAbiJson)
        guard let hexData = action.dataHex else {
            return XCTFail()
        }
        XCTAssertTrue(hexData == "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73")
    }
    
    
    func testActionDeserializeDataToJson() {
        guard let tokenAbiJson = getTokenAbiJson() else {
            return XCTFail()
        }
        
        // deserialize the hex data back to json
        let hexData = "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73"
        let abieos = AbiEos()
        guard let json1 = try? abieos.hexToJson(contract: "eosio.token", name: "transfer", hex: hexData, abi: tokenAbiJson) else {
            return XCTFail()
        }
        let json2 = """
        {"from":"todd","to":"brandon","quantity":"42.0000 SYS","memo":"Grasshopper Rocks"}
        """
        XCTAssertTrue(json1 == json2)
    }
    
    
    func testActionDeserializeData() {
        
        guard var action = try? makeTransferActionWithEosioNames() else {
            return XCTFail()
        }
        
        guard let tokenAbiJson = getTokenAbiJson() else {
            return XCTFail()
        }
        
        try? action.deserializeData(abi: tokenAbiJson)
        
        XCTAssertTrue(action.data["from"] as? String == "todd")
        XCTAssertTrue(action.data["to"] as? String   == "brandon")
        XCTAssertTrue(action.data["quantity"] as? String  == "42.0000 SYS")
        XCTAssertTrue(action.data["memo"] as? String  == "Grasshopper Rocks")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        
        guard let _ = try? jsonEncoder.encode(action) else {
            return XCTFail()
        }
    }
    
    
    func testActionEncode() {
        guard let action = try? makeTransferActionWithSerializedData() else {
            return XCTFail()
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys
        
        guard let json = try? jsonEncoder.encode(action) else {
            return XCTFail()
        }
        guard let json1 = String(data: json, encoding: .utf8) else {
            return XCTFail()
        }
        
        let json2 = """
        {"account":"eosio.token","authorization":[{"actor":"todd","permission":"active"}],"data":"00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73","name":"transfer"}
        """
        XCTAssertTrue(json1 == json2)
    }
    
    func testActionWithComplexData() {
        guard let complexData = try? makeComplexData() else {
            return XCTFail()
        }
        
        guard let action = try? EosioTransaction.Action(
            account: EosioName("eosio.token"),
            name: EosioName("transfer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: EosioName("todd"),
                permission: EosioName("active"))
            ],
            data: complexData
            ) else {
                return XCTFail()
        }
        
        guard let dataJson1 = action.dataJson else {
            return XCTFail()
        }
        let dataJson2 = """
        {"aa":"aa","bb":-42,"cc":999999999,"dd":true,"ee":"2009-01-03T18:15:05.000","ff":["aa","bbb","cccc"],"gg":[-7,0,7],"hh":{"a":"aaa","b":"bbb"},"ii":{"aa":{"bb":-7},"cc":{"dd":7}},"jj":[{"aaa":"bbb"},{"ccc":"ddd"}]}
        """
        
        XCTAssertTrue(dataJson1 == dataJson2)
    }
    
    func testActionDecode() {
        let json = """
        {"account":"eosio.token","authorization":[{"actor":"todd","permission":"active"}],"data":"00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73","name":"transfer"}
        """
        guard let jsonData = json.data(using: .utf8) else {
            return XCTFail()
        }
        
        let decoder = JSONDecoder()
        guard let action = try? decoder.decode(EosioTransaction.Action.self, from: jsonData) else {
            return XCTFail()
        }
        
        XCTAssertTrue(action.account.string == "eosio.token")
        XCTAssertTrue(action.name.string == "transfer")
        XCTAssertTrue(action.authorization[0].actor.string == "todd")
        XCTAssertTrue(action.authorization[0].permission.string == "active")
        XCTAssertTrue(action.dataHex == "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73")
    }
    
    
    
    struct Transfer: Codable {
        var from: EosioName
        var to: EosioName
        var quantity: String
        var memo: String
    }
    
    struct ComplexData: Codable {
        var aa: EosioName
        var bb: Int
        var cc: UInt64
        var dd: Bool
        var ee: Date
        var ff: [String]
        var gg: [Int]
        var hh: [String:EosioName]
        var ii: [String:[String:Int]]
        var jj: [[String:String]]
    }
    
    
    let tokenAbiB64 = "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA="
    
    func makeTransferActionWithEosioNames() throws -> EosioTransaction.Action {
        
        let action = try EosioTransaction.Action(
            account: EosioName("eosio.token"),
            name: EosioName("transfer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: EosioName("todd"),
                permission: EosioName("active"))
            ],
            data: Transfer(
                from: EosioName("todd"),
                to: EosioName("brandon"),
                quantity: "42.0000 SYS",
                memo: "Grasshopper Rocks")
        )
        return action
    }
    
    func makeTransferActionWithStrings() throws -> EosioTransaction.Action {
        
        let action = try EosioTransaction.Action(
            account: "eosio.token",
            name: "transfer",
            authorization: [EosioTransaction.Action.Authorization(
                actor: "todd",
                permission: "active")
            ],
            data: Transfer(
                from: EosioName("todd"),
                to: EosioName("brandon"),
                quantity: "42.0000 SYS",
                memo: "Grasshopper Rocks")
        )
        return action
    }
    
    func makeTransferActionWithError() throws -> EosioTransaction.Action {
        
        let action = try EosioTransaction.Action(
            account: "eosio.token6",
            name: "transfer",
            authorization: [EosioTransaction.Action.Authorization(
                actor: "todd",
                permission: "active")
            ],
            data: Transfer(
                from: EosioName("todd"),
                to: EosioName("brandon"),
                quantity: "42.0000 SYS",
                memo: "Grasshopper Rocks")
        )
        return action
    }
    
    
    func makeTransferActionWithSerializedData() throws -> EosioTransaction.Action {
        
        let action = try EosioTransaction.Action(
            account: "eosio.token",
            name: "transfer",
            authorization: [EosioTransaction.Action.Authorization(
                actor: "todd",
                permission: "active")
            ],
            dataSerialized: Data(hexString: "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73")!
        )
        return action
    }
    
    
    func getTokenAbiJson() -> String? {
        let hex = Data(base64Encoded: tokenAbiB64)!.hexEncodedString()
        let abieos = AbiEos()
        return try? abieos.hexToJson(contract: nil, type: "abi_def", hex: hex, abi: "abi.abi.json")
    }
    
    
    func makeComplexData() throws -> ComplexData {
        let complexData = try ComplexData(
            aa: EosioName("aa"),
            bb: -42,
            cc: 999999999,
            dd: true,
            ee: Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!,
            ff: ["aa","bbb","cccc"],
            gg: [-7,0,7],
            hh: [
                "a" : EosioName("aaa"),
                "b": EosioName("bbb")],
            ii: [
                "aa" : ["bb" : -7],
                "cc" : ["dd" : 7],
                ],
            jj: [
                ["aaa" : "bbb"],
                ["ccc" : "ddd"]
            ]
        )
        return complexData
    }
    
    
}

