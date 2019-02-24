//
//  EosioTransactionTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 2/13/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift
@testable import EosioSwiftFoundation
@testable import EosioSwiftC

class EosioTransactionTests: XCTestCase {
    
    
    func testSerializeActionData() {
        do {
            let transaction = EosioTransaction()
            
            let action1 = try makeTransferAction(from: EosioName("todd"), to: EosioName("brandon"))
            let action2 = try makeTransferAction(from: EosioName("brandon"), to: EosioName("todd"))
            
            transaction.actions.append(action1)
            transaction.actions.append(action2)
            
            try transaction.abis.addAbi(name: try EosioName("eosio.token"), base64: tokenAbiB64)
            try transaction.serializeActionData()
          
            XCTAssertTrue(transaction.actionsWithoutSerializedData.count == 0)
        } catch {
            print(error)
            XCTFail()
        }
        
    }
    
    
    func testToEosioTransactionRequest() {
        do {
            let transaction = EosioTransaction()
            let action = try makeTransferAction(from: EosioName("todd"), to: EosioName("brandon"))
            transaction.actions.append(action)
            try transaction.abis.addAbi(name: EosioName("eosio.token"), base64: tokenAbiB64)
            transaction.refBlockNum = 100
            transaction.refBlockPrefix = 123456
            transaction.expiration = Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!
            let eosioTransactionRequest = try! transaction.toEosioTransactionRequest()
            XCTAssertTrue(eosioTransactionRequest.packedTrx == "29AB5F49640040E20100000000000100A6823403EA3055000000572D3CCDCD0100000000009012CD00000000A8ED32323200000000009012CD00000060D234CD3DA0680600000000000453595300000000114772617373686F7070657220526F636B7300")
            print(try transaction.toJson(prettyPrinted: true))
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    
    func testCalculateExpiration() {
        let transaction = EosioTransaction()
        transaction.calculateExpiration()
        XCTAssert(transaction.expiration > Date())
    }

    
    func testGetChainIdAndCalculateTapos() {
        let expect = expectation(description: "testGetChainIdAndCalculateTapos")
        let transaction = EosioTransaction()
        guard let endpoint = EosioEndpoint("mock://endpoint") else {
            return XCTFail()
        }
        transaction.rpcProvider = EosioRpcProviderMockImpl(endpoints: [endpoint], failoverRetries: 1)
        transaction.getChainIdAndCalculateTapos { (result) in
            switch result {
            case .error(let error):
                print(error)
                XCTFail()
            case .empty:
                XCTFail()
            case .success:
                XCTAssertEqual(transaction.refBlockNum, 28672)
                XCTAssertEqual(transaction.refBlockPrefix, 2249927103)
                XCTAssertEqual(transaction.chainId, "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17")
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 3)
    }
    
    
    struct Transfer: Codable {
        var from: EosioName
        var to: EosioName
        var quantity: String
        var memo: String
    }
    
    
    let tokenAbiB64 = "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA="
    
    func getTokenAbiJson() -> String? {
        let hex = Data(base64Encoded: tokenAbiB64)!.hexEncodedString()
        let abieos = AbiEos()
        return try? abieos.hexToJson(contract: nil, type: "abi_def", hex: hex, abi: "abi.abi.json")
    }
    
    
    func makeTransferAction(from: EosioName, to: EosioName) throws -> EosioTransaction.Action {
        
        let action = try EosioTransaction.Action(
            account: EosioName("eosio.token"),
            name: EosioName("transfer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: from,
                permission: EosioName("active"))
            ],
            data: Transfer(
                from: from,
                to: to,
                quantity: "42.0000 SYS",
                memo: "Grasshopper Rocks")
        )
        return action
    }
    
    
    
}
