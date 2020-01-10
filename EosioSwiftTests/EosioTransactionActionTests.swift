//
//  EosioTransactionActionTests.swift
//  EosioSwiftTests
//
//  Created by Serguei Vinnitskii on 3/19/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

// swiftlint:disable line_length identifier_name
import XCTest
@testable import EosioSwift

class EosioTransactionActionTests: XCTestCase {

    var transaction: EosioTransaction!
    //var rpcProvider =
    var action: EosioTransaction.Action!
    var authorization: EosioTransaction.Action.Authorization!
    override func setUp() {
        let transaction = EosioTransaction()
        let url = URL(string: "http://example.com")
        transaction.rpcProvider = EosioRpcProvider(endpoint: url!)
        transaction.serializationProvider = SerializationProviderMock()
    }

    func testAuthorizationInitWithString() {
        authorization = try? EosioTransaction.Action.Authorization(actor: "12character", permission: "12character")
        XCTAssertTrue(authorization != nil)
    }

    func testNewTransferActionWithEosioNames() {
        XCTAssertNotNil(try? makeTransferActionWithEosioNames())
    }

    func testNewTransferActionWithStrings() {
        XCTAssertNotNil(try? makeTransferActionWithStrings())
    }

    func testNewTransferActionError() {
        do {
            try _ = makeTransferActionWithError()
            XCTFail("Transfer succeeded despite being malformed")
        } catch let error as EosioError {
            XCTAssertTrue(error.reason == "eosio.token6 is not a valid eosio name.")
        } catch {
            XCTFail("Unknown error")
        }
    }

    func testActionEncode() {
        guard let action = try? makeTransferActionWithSerializedData() else {
            return XCTFail("Failed to make transfer action with serialized data")
        }

        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .sortedKeys

        guard let json = try? jsonEncoder.encode(action) else {
            return XCTFail("Failed to encode action")
        }
        guard let json1 = String(data: json, encoding: .utf8) else {
            return XCTFail("Failed to convert JSON to String()")
        }

        let json2 = """
        {"account":"eosio.token","authorization":[{"actor":"todd","permission":"active"}],"data":"00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73","name":"transfer"}
        """
        XCTAssertTrue(json1 == json2)
    }

    func testActionWithComplexData() {
        guard let complexData = try? makeComplexData() else {
            return XCTFail("Failed to make complex Data")
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
                return XCTFail("Failed to add action to transaction")
        }

        guard let dataJson1 = action.dataJson else {
            return XCTFail("Failed to extract JSON data from action")
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
            return XCTFail("Failed to convert JSON to Data()")
        }

        let decoder = JSONDecoder()
        guard let action = try? decoder.decode(EosioTransaction.Action.self, from: jsonData) else {
            return XCTFail("Failed to decode transaction Action from JSON Data")
        }

        XCTAssertTrue(action.account.string == "eosio.token")
        XCTAssertTrue(action.name.string == "transfer")
        XCTAssertTrue(action.authorization[0].actor.string == "todd")
        XCTAssertTrue(action.authorization[0].permission.string == "active")
        XCTAssertTrue(action.dataHex == "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73")
    }

    func testAddAuthorizationAtIndexShouldSucceed() {
        guard let action = try? makeTransferActionWithEosioNames() else {
            return XCTFail("Could not create an action")
        }

        guard let authorization = try? EosioTransaction.Action.Authorization(actor: "12character", permission: "12character") else {
            return XCTFail("Could not create an authorization")
        }

        action.add(authorization: authorization, at: 0)
        XCTAssertEqual(action.authorization.count, 2)
        XCTAssertEqual(action.authorization[0], authorization)
    }

    func testRemoveAuthorizationAtIndexShouldSucceed() {
        guard let action = try? makeTransferActionWithEosioNames() else {
            return XCTFail("Could not create an action")
        }

        let authorization = action.authorization[0]
        let removedAuthorization = action.removeAuthorization(at: 0)

        XCTAssertEqual(action.authorization.count, 0)
        XCTAssertEqual(authorization, removedAuthorization)
    }

    ///////////////////////////////// convenience methods /////////////////////////////////

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
        var hh: [String: EosioName]
        var ii: [String: [String: Int]]
        var jj: [[String: String]]
    }

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

    func makeComplexData() throws -> ComplexData {
        let complexData = try ComplexData(
            aa: EosioName("aa"),
            bb: -42,
            cc: 999999999,
            dd: true,
            ee: Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!,
            ff: ["aa", "bbb", "cccc"],
            gg: [-7, 0, 7],
            hh: [
                "a": EosioName("aaa"),
                "b": EosioName("bbb")],
            ii: [
                "aa": ["bb": -7],
                "cc": ["dd": 7]
            ],
            jj: [
                ["aaa": "bbb"],
                ["ccc": "ddd"]
            ]
        )
        return complexData
    }

}
