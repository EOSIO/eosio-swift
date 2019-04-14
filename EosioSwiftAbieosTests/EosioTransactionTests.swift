//
//  EosioTransactionTests.swift
//  EosioSwiftAbieosTests
//
//  Created by Todd Bowden on 2/13/19.
//  Copyright © 2018-2019 block.one.
//

// swiftlint:disable line_length
import XCTest
@testable import EosioSwift
@testable import EosioSwiftAbieosSerializationProvider

class EosioTransactionTests: XCTestCase {

    var transaction: EosioTransaction!
    var rpcProvider: RpcMockProvider!
    override func setUp() {
        transaction = EosioTransaction()
        transaction.serializationProvider = EosioAbieosSerializationProvider()
        let url = URL(string: "http://example.com")
        rpcProvider = RpcMockProvider(endpoint: url!)
    }

    override func tearDown() {
        transaction = nil
    }

    func testSerializeActionData() {
        do {
            let action1 = try makeTransferAction(from: EosioName("todd"), to: EosioName("brandon"))
            let action2 = try makeTransferAction(from: EosioName("brandon"), to: EosioName("todd"))
            let action3 = try makeVoteProducerAction(voter: EosioName("todd"))

            transaction.actions.append(action1)
            transaction.actions.append(action2)
            transaction.actions.append(action3)

            try transaction.abis.addAbi(name: try EosioName("eosio.token"), base64: tokenAbiB64)
            try transaction.abis.addAbi(name: try EosioName("eosio"), base64: eosioAbiB64)
            try transaction.serializeActionData()

            XCTAssertTrue(transaction.actionsWithoutSerializedData.count == 0)
        } catch {
            XCTFail("\(error)")
        }

    }

    func testAsyncSerializeActionData() {
        let expect = expectation(description: "testAsyncSerializeActionData")
        transaction.chainId = "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17"
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else {
            return XCTFail("Failed to create transfer action")
        }
        guard let action2 = try? makeVoteProducerAction(voter: EosioName("todd")) else {
            return XCTFail("Failed to create a vote action")
        }
        transaction.actions.append(action1)
        transaction.actions.append(action2)

        transaction.rpcProvider = rpcProvider
        transaction.serializeActionData { [weak self] (result) in
            guard let self = self else {
                XCTFail("Self is not present")
                return
            }
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success:
                XCTAssertTrue(self.transaction.actionsWithoutSerializedData.count == 0)
                XCTAssertEqual(self.transaction.actions[0].dataSerialized?.hex, "00000000009012cd00000060d234cd3da0680600000000000453595300000000114772617373686f7070657220526f636b73")
                XCTAssertEqual(self.transaction.actions[1].dataSerialized?.hex, "00000000009012cd00000000009012cd0300000857219de8ad00001057219de8ad00001857219de8ad")
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 3)
    }

    func testToEosioTransactionRequest() {
        do {
            let action = try makeTransferAction(from: EosioName("todd"), to: EosioName("brandon"))
            transaction.actions.append(action)
            try transaction.abis.addAbi(name: EosioName("eosio.token"), base64: tokenAbiB64)
            transaction.refBlockNum = 100
            transaction.refBlockPrefix = 123456
            transaction.expiration = Date(yyyyMMddTHHmmss: "2009-01-03T18:15:05.000")!
            let serializedTransaction = try transaction.serializeTransaction()
            let expectedData = try Data(hex: "29AB5F49640040E20100000000000100A6823403EA3055000000572D3CCDCD0100000000009012CD00000000A8ED32323200000000009012CD00000060D234CD3DA0680600000000000453595300000000114772617373686F7070657220526F636B7300")
            XCTAssertEqual(serializedTransaction, expectedData)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAsyncToEosioTransactionRequest() {
        let expect = expectation(description: "testAsyncToEosioTransactionRequest")
        transaction.chainId = "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17"
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else {
            return XCTFail("Failed to create transfer action")
        }
        guard let action2 = try? makeVoteProducerAction(voter: EosioName("todd")) else {
            return XCTFail("Failed to create vote action")
        }
        transaction.actions.append(action1)
        transaction.actions.append(action2)
        transaction.expiration = Date(yyyyMMddTHHmmss: "3009-01-03T18:15:05.000")!

        var data: Data?
        do {
            data = try Data(hex: "29E24FA20070BF291B86000000000200A6823403EA3055000000572D3CCDCD0100000000009012CD00000000A8ED32323200000000009012CD00000060D234CD3DA0680600000000000453595300000000114772617373686F7070657220526F636B730000000000EA30557015D289DEAA32DD0100000000009012CD00000000A8ED32322900000000009012CD00000000009012CD0300000857219DE8AD00001057219DE8AD00001857219DE8AD00")
        } catch {
            XCTFail("Failed to create data from hex")
        }

        guard let expectedData = data else {
            XCTFail("Failed to create data()")
            return
        }

        transaction.rpcProvider = rpcProvider
        transaction.serializeTransaction(completion: { result in
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let serializedTransaction):

                XCTAssertEqual(serializedTransaction, expectedData)
                expect.fulfill()
            }
        })
        wait(for: [expect], timeout: 3)
    }

    func testPrepare() {
        let expect = expectation(description: "testPrepare")
        transaction.rpcProvider = rpcProvider
        guard let expDate = Date(yyyyMMddTHHmmss: "2019-02-21T18:31:41.500") else {
            return XCTFail("Failed to create Date()")
        }
        transaction.prepare { [weak self] (result) in
            guard let self = self else {
                XCTFail("Self is not present")
                return
            }
            print("expiration date: \(self.transaction.expiration)")
            XCTAssert(self.transaction.expiration > expDate)
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success:
                XCTAssertEqual(self.transaction.refBlockNum, 28672)
                XCTAssertEqual(self.transaction.refBlockPrefix, 2249927103)
                XCTAssertEqual(self.transaction.chainId, "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17")
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 3)
    }

    func testGetBlockAndSetTapos() {
        let expect = expectation(description: "testGetChainIdAndCalculateTapos")
        transaction.rpcProvider = rpcProvider
        transaction.getBlockAndSetTapos(blockNum: 28672) { [weak self] (result) in
            guard let self = self else {
                XCTFail("Self is not present")
                return
            }
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success:
                XCTAssertEqual(self.transaction.refBlockNum, 28672)
                XCTAssertEqual(self.transaction.refBlockPrefix, 2249927103)
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 3)
    }

    func testGetAbis() {
        let expect = expectation(description: "testGetAbis")
        transaction.chainId = "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17"
        guard let action1 = try? makeTransferAction(from: EosioName("todd"), to: EosioName("brandon")) else {
            return XCTFail("Failed to create transfer action")
        }
        guard let action2 = try? makeVoteProducerAction(voter: EosioName("todd")) else {
            return XCTFail("Failed to create vote action")
        }
        transaction.actions.append(action1)
        transaction.actions.append(action2)
        transaction.rpcProvider = rpcProvider
        transaction.getAbis { [weak self] (result) in
            guard let self = self else {
                XCTFail("Self is not present")
                return
            }
            switch result {
            case .failure(let error):
                print(error)
                XCTFail("Failed get_abis")
            case .success:
                XCTAssertEqual(try? self.transaction.abis.hashAbi(name: EosioName("eosio.token")), "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                XCTAssertEqual(try? self.transaction.abis.hashAbi(name: EosioName("eosio")), "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 3)
    }

    struct Transfer: Codable {
        var from: EosioName
        var to: EosioName // swiftlint:disable:this identifier_name
        var quantity: String
        var memo: String
    }

    struct VoteProducer: Codable {
        var voter: EosioName
        var proxy: EosioName
        var producers: [EosioName]
    }

    func getTokenAbiJson() -> String? {
        let hex = Data(base64Encoded: tokenAbiB64)!.hexEncodedString()
        let serializer = EosioAbieosSerializationProvider()
        return try? serializer.deserializeAbi(hex: hex)
    }

    func makeTransferAction(from: EosioName, to: EosioName) throws -> EosioTransaction.Action { // swiftlint:disable:this identifier_name

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

    func makeVoteProducerAction(voter: EosioName) throws -> EosioTransaction.Action {

        let producer1 = try EosioName("producer1")
        let producer2 = try EosioName("producer2")
        let producer3 = try EosioName("producer3")

        let action = try EosioTransaction.Action(
            account: EosioName("eosio"),
            name: EosioName("voteproducer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: voter,
                permission: EosioName("active"))
            ],
            data: VoteProducer(
                voter: voter,
                proxy: voter,
                producers: [producer1, producer2, producer3]
            )
        )
        return action

    }

    let tokenAbiB64 = "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA="

    let eosioAbiB64 = "DmVvc2lvOjphYmkvMS4xADYIYWJpX2hhc2gAAgVvd25lcgRuYW1lBGhhc2gLY2hlY2tzdW0yNTYJYXV0aG9yaXR5AAQJdGhyZXNob2xkBnVpbnQzMgRrZXlzDGtleV93ZWlnaHRbXQhhY2NvdW50cxlwZXJtaXNzaW9uX2xldmVsX3dlaWdodFtdBXdhaXRzDXdhaXRfd2VpZ2h0W10KYmlkX3JlZnVuZAACBmJpZGRlcgRuYW1lBmFtb3VudAVhc3NldAdiaWRuYW1lAAMGYmlkZGVyBG5hbWUHbmV3bmFtZQRuYW1lA2JpZAVhc3NldAliaWRyZWZ1bmQAAgZiaWRkZXIEbmFtZQduZXduYW1lBG5hbWUMYmxvY2tfaGVhZGVyAAgJdGltZXN0YW1wBnVpbnQzMghwcm9kdWNlcgRuYW1lCWNvbmZpcm1lZAZ1aW50MTYIcHJldmlvdXMLY2hlY2tzdW0yNTYRdHJhbnNhY3Rpb25fbXJvb3QLY2hlY2tzdW0yNTYMYWN0aW9uX21yb290C2NoZWNrc3VtMjU2EHNjaGVkdWxlX3ZlcnNpb24GdWludDMyDW5ld19wcm9kdWNlcnMScHJvZHVjZXJfc2NoZWR1bGU/FWJsb2NrY2hhaW5fcGFyYW1ldGVycwARE21heF9ibG9ja19uZXRfdXNhZ2UGdWludDY0GnRhcmdldF9ibG9ja19uZXRfdXNhZ2VfcGN0BnVpbnQzMhltYXhfdHJhbnNhY3Rpb25fbmV0X3VzYWdlBnVpbnQzMh5iYXNlX3Blcl90cmFuc2FjdGlvbl9uZXRfdXNhZ2UGdWludDMyEG5ldF91c2FnZV9sZWV3YXkGdWludDMyI2NvbnRleHRfZnJlZV9kaXNjb3VudF9uZXRfdXNhZ2VfbnVtBnVpbnQzMiNjb250ZXh0X2ZyZWVfZGlzY291bnRfbmV0X3VzYWdlX2RlbgZ1aW50MzITbWF4X2Jsb2NrX2NwdV91c2FnZQZ1aW50MzIadGFyZ2V0X2Jsb2NrX2NwdV91c2FnZV9wY3QGdWludDMyGW1heF90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGW1pbl90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGG1heF90cmFuc2FjdGlvbl9saWZldGltZQZ1aW50MzIeZGVmZXJyZWRfdHJ4X2V4cGlyYXRpb25fd2luZG93BnVpbnQzMhVtYXhfdHJhbnNhY3Rpb25fZGVsYXkGdWludDMyFm1heF9pbmxpbmVfYWN0aW9uX3NpemUGdWludDMyF21heF9pbmxpbmVfYWN0aW9uX2RlcHRoBnVpbnQxNhNtYXhfYXV0aG9yaXR5X2RlcHRoBnVpbnQxNgZidXlyYW0AAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFcXVhbnQFYXNzZXQLYnV5cmFtYnl0ZXMAAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFYnl0ZXMGdWludDMyC2NhbmNlbGRlbGF5AAIOY2FuY2VsaW5nX2F1dGgQcGVybWlzc2lvbl9sZXZlbAZ0cnhfaWQLY2hlY2tzdW0yNTYMY2xhaW1yZXdhcmRzAAEFb3duZXIEbmFtZQljb25uZWN0b3IAAgdiYWxhbmNlBWFzc2V0BndlaWdodAdmbG9hdDY0CmRlbGVnYXRlYncABQRmcm9tBG5hbWUIcmVjZWl2ZXIEbmFtZRJzdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQSc3Rha2VfY3B1X3F1YW50aXR5BWFzc2V0CHRyYW5zZmVyBGJvb2wTZGVsZWdhdGVkX2JhbmR3aWR0aAAEBGZyb20EbmFtZQJ0bwRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldApkZWxldGVhdXRoAAIHYWNjb3VudARuYW1lCnBlcm1pc3Npb24EbmFtZRJlb3Npb19nbG9iYWxfc3RhdGUVYmxvY2tjaGFpbl9wYXJhbWV0ZXJzDQxtYXhfcmFtX3NpemUGdWludDY0GHRvdGFsX3JhbV9ieXRlc19yZXNlcnZlZAZ1aW50NjQPdG90YWxfcmFtX3N0YWtlBWludDY0HWxhc3RfcHJvZHVjZXJfc2NoZWR1bGVfdXBkYXRlFGJsb2NrX3RpbWVzdGFtcF90eXBlGGxhc3RfcGVydm90ZV9idWNrZXRfZmlsbAp0aW1lX3BvaW50DnBlcnZvdGVfYnVja2V0BWludDY0D3BlcmJsb2NrX2J1Y2tldAVpbnQ2NBN0b3RhbF91bnBhaWRfYmxvY2tzBnVpbnQzMhV0b3RhbF9hY3RpdmF0ZWRfc3Rha2UFaW50NjQbdGhyZXNoX2FjdGl2YXRlZF9zdGFrZV90aW1lCnRpbWVfcG9pbnQbbGFzdF9wcm9kdWNlcl9zY2hlZHVsZV9zaXplBnVpbnQxNhp0b3RhbF9wcm9kdWNlcl92b3RlX3dlaWdodAdmbG9hdDY0D2xhc3RfbmFtZV9jbG9zZRRibG9ja190aW1lc3RhbXBfdHlwZRNlb3Npb19nbG9iYWxfc3RhdGUyAAURbmV3X3JhbV9wZXJfYmxvY2sGdWludDE2EWxhc3RfcmFtX2luY3JlYXNlFGJsb2NrX3RpbWVzdGFtcF90eXBlDmxhc3RfYmxvY2tfbnVtFGJsb2NrX3RpbWVzdGFtcF90eXBlHHRvdGFsX3Byb2R1Y2VyX3ZvdGVwYXlfc2hhcmUHZmxvYXQ2NAhyZXZpc2lvbgV1aW50OBNlb3Npb19nbG9iYWxfc3RhdGUzAAIWbGFzdF92cGF5X3N0YXRlX3VwZGF0ZQp0aW1lX3BvaW50HHRvdGFsX3ZwYXlfc2hhcmVfY2hhbmdlX3JhdGUHZmxvYXQ2NA5leGNoYW5nZV9zdGF0ZQADBnN1cHBseQVhc3NldARiYXNlCWNvbm5lY3RvcgVxdW90ZQljb25uZWN0b3IEaW5pdAACB3ZlcnNpb24JdmFydWludDMyBGNvcmUGc3ltYm9sCmtleV93ZWlnaHQAAgNrZXkKcHVibGljX2tleQZ3ZWlnaHQGdWludDE2CGxpbmthdXRoAAQHYWNjb3VudARuYW1lBGNvZGUEbmFtZQR0eXBlBG5hbWULcmVxdWlyZW1lbnQEbmFtZQhuYW1lX2JpZAAEB25ld25hbWUEbmFtZQtoaWdoX2JpZGRlcgRuYW1lCGhpZ2hfYmlkBWludDY0DWxhc3RfYmlkX3RpbWUKdGltZV9wb2ludApuZXdhY2NvdW50AAQHY3JlYXRvcgRuYW1lBG5hbWUEbmFtZQVvd25lcglhdXRob3JpdHkGYWN0aXZlCWF1dGhvcml0eQdvbmJsb2NrAAEGaGVhZGVyDGJsb2NrX2hlYWRlcgdvbmVycm9yAAIJc2VuZGVyX2lkB3VpbnQxMjgIc2VudF90cngFYnl0ZXMQcGVybWlzc2lvbl9sZXZlbAACBWFjdG9yBG5hbWUKcGVybWlzc2lvbgRuYW1lF3Blcm1pc3Npb25fbGV2ZWxfd2VpZ2h0AAIKcGVybWlzc2lvbhBwZXJtaXNzaW9uX2xldmVsBndlaWdodAZ1aW50MTYNcHJvZHVjZXJfaW5mbwAIBW93bmVyBG5hbWULdG90YWxfdm90ZXMHZmxvYXQ2NAxwcm9kdWNlcl9rZXkKcHVibGljX2tleQlpc19hY3RpdmUEYm9vbAN1cmwGc3RyaW5nDXVucGFpZF9ibG9ja3MGdWludDMyD2xhc3RfY2xhaW1fdGltZQp0aW1lX3BvaW50CGxvY2F0aW9uBnVpbnQxNg5wcm9kdWNlcl9pbmZvMgADBW93bmVyBG5hbWUNdm90ZXBheV9zaGFyZQdmbG9hdDY0GWxhc3Rfdm90ZXBheV9zaGFyZV91cGRhdGUKdGltZV9wb2ludAxwcm9kdWNlcl9rZXkAAg1wcm9kdWNlcl9uYW1lBG5hbWURYmxvY2tfc2lnbmluZ19rZXkKcHVibGljX2tleRFwcm9kdWNlcl9zY2hlZHVsZQACB3ZlcnNpb24GdWludDMyCXByb2R1Y2Vycw5wcm9kdWNlcl9rZXlbXQZyZWZ1bmQAAQVvd25lcgRuYW1lDnJlZnVuZF9yZXF1ZXN0AAQFb3duZXIEbmFtZQxyZXF1ZXN0X3RpbWUOdGltZV9wb2ludF9zZWMKbmV0X2Ftb3VudAVhc3NldApjcHVfYW1vdW50BWFzc2V0C3JlZ3Byb2R1Y2VyAAQIcHJvZHVjZXIEbmFtZQxwcm9kdWNlcl9rZXkKcHVibGljX2tleQN1cmwGc3RyaW5nCGxvY2F0aW9uBnVpbnQxNghyZWdwcm94eQACBXByb3h5BG5hbWUHaXNwcm94eQRib29sC3JtdnByb2R1Y2VyAAEIcHJvZHVjZXIEbmFtZQdzZWxscmFtAAIHYWNjb3VudARuYW1lBWJ5dGVzBWludDY0BnNldGFiaQACB2FjY291bnQEbmFtZQNhYmkFYnl0ZXMKc2V0YWxpbWl0cwAEB2FjY291bnQEbmFtZQlyYW1fYnl0ZXMFaW50NjQKbmV0X3dlaWdodAVpbnQ2NApjcHVfd2VpZ2h0BWludDY0B3NldGNvZGUABAdhY2NvdW50BG5hbWUGdm10eXBlBXVpbnQ4CXZtdmVyc2lvbgV1aW50OARjb2RlBWJ5dGVzCXNldHBhcmFtcwABBnBhcmFtcxVibG9ja2NoYWluX3BhcmFtZXRlcnMHc2V0cHJpdgACB2FjY291bnQEbmFtZQdpc19wcml2BXVpbnQ4BnNldHJhbQABDG1heF9yYW1fc2l6ZQZ1aW50NjQKc2V0cmFtcmF0ZQABD2J5dGVzX3Blcl9ibG9jawZ1aW50MTYMdW5kZWxlZ2F0ZWJ3AAQEZnJvbQRuYW1lCHJlY2VpdmVyBG5hbWUUdW5zdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQUdW5zdGFrZV9jcHVfcXVhbnRpdHkFYXNzZXQKdW5saW5rYXV0aAADB2FjY291bnQEbmFtZQRjb2RlBG5hbWUEdHlwZQRuYW1lCXVucmVncHJvZAABCHByb2R1Y2VyBG5hbWUKdXBkYXRlYXV0aAAEB2FjY291bnQEbmFtZQpwZXJtaXNzaW9uBG5hbWUGcGFyZW50BG5hbWUEYXV0aAlhdXRob3JpdHkMdXBkdHJldmlzaW9uAAEIcmV2aXNpb24FdWludDgOdXNlcl9yZXNvdXJjZXMABAVvd25lcgRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldAlyYW1fYnl0ZXMFaW50NjQMdm90ZXByb2R1Y2VyAAMFdm90ZXIEbmFtZQVwcm94eQRuYW1lCXByb2R1Y2VycwZuYW1lW10Kdm90ZXJfaW5mbwAKBW93bmVyBG5hbWUFcHJveHkEbmFtZQlwcm9kdWNlcnMGbmFtZVtdBnN0YWtlZAVpbnQ2NBBsYXN0X3ZvdGVfd2VpZ2h0B2Zsb2F0NjQTcHJveGllZF92b3RlX3dlaWdodAdmbG9hdDY0CGlzX3Byb3h5BGJvb2wJcmVzZXJ2ZWQxBnVpbnQzMglyZXNlcnZlZDIGdWludDMyCXJlc2VydmVkMwVhc3NldAt3YWl0X3dlaWdodAACCHdhaXRfc2VjBnVpbnQzMgZ3ZWlnaHQGdWludDE2HwAAAEBJM5M7B2JpZG5hbWUAAABIUy91kzsJYmlkcmVmdW5kAAAAAABIc70+BmJ1eXJhbQAAsMr+SHO9PgtidXlyYW1ieXRlcwAAvIkqRYWmQQtjYW5jZWxkZWxheQCA0zVcXelMRAxjbGFpbXJld2FyZHMAAAA/KhumokoKZGVsZWdhdGVidwAAQMvaqKyiSgpkZWxldGVhdXRoAAAAAAAAkN10BGluaXQAAAAALWsDp4sIbGlua2F1dGgAAECemiJkuJoKbmV3YWNjb3VudAAAAAAAIhrPpAdvbmJsb2NrAAAAAODSe9WkB29uZXJyb3IAAAAAAKSpl7oGcmVmdW5kAACuQjrRW5m6C3JlZ3Byb2R1Y2VyAAAAAL7TW5m6CHJlZ3Byb3h5AACuQjrRW7e8C3JtdnByb2R1Y2VyAAAAAECaG6PCB3NlbGxyYW0AAAAAALhjssIGc2V0YWJpAAAAzk66aLLCCnNldGFsaW1pdHMAAAAAQCWKssIHc2V0Y29kZQAAAMDSXFOzwglzZXRwYXJhbXMAAAAAYLtbs8IHc2V0cHJpdgAAAAAASHOzwgZzZXRyYW0AAIDK5kpzs8IKc2V0cmFtcmF0ZQDAj8qGqajS1Ax1bmRlbGVnYXRlYncAAEDL2sDp4tQKdW5saW5rYXV0aAAAAEj0Vqbu1Al1bnJlZ3Byb2QAAEDL2qhsUtUKdXBkYXRlYXV0aAAwqcNuq5tT1Qx1cGR0cmV2aXNpb24AcBXSid6qMt0Mdm90ZXByb2R1Y2VyAA0AAACgYdPcMQNpNjQAAAhhYmlfaGFzaAAATlMvdZM7A2k2NAAACmJpZF9yZWZ1bmQAAAAgTXOiSgNpNjQAABNkZWxlZ2F0ZWRfYmFuZHdpZHRoAAAAAERzaGQDaTY0AAASZW9zaW9fZ2xvYmFsX3N0YXRlAAAAQERzaGQDaTY0AAATZW9zaW9fZ2xvYmFsX3N0YXRlMgAAAGBEc2hkA2k2NAAAE2Vvc2lvX2dsb2JhbF9zdGF0ZTMAAAA4uaOkmQNpNjQAAAhuYW1lX2JpZAAAwFchneitA2k2NAAADXByb2R1Y2VyX2luZm8AgMBXIZ3orQNpNjQAAA5wcm9kdWNlcl9pbmZvMgAAyApeI6W5A2k2NAAADmV4Y2hhbmdlX3N0YXRlAAAAAKepl7oDaTY0AAAOcmVmdW5kX3JlcXVlc3QAAAAAq3sV1gNpNjQAAA51c2VyX3Jlc291cmNlcwAAAADgqzLdA2k2NAAACnZvdGVyX2luZm8AAAAA="

}

class RpcMockProvider: EosioRpcProviderProtocol {
    var url: URL
    required init(endpoint: URL) {
        self.url = endpoint
    }
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        let res = createInfoResponse()
        var result: EosioResult<EosioRpcInfoResponseProtocol, EosioError>
        if let res = res {
            result = EosioResult.success(res)
        } else {
            result = EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't parse data."))
        }
        completion(result)
    }
    public func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void) {
        let res = createBlockResponse()
        var result: EosioResult<EosioRpcBlockResponseProtocol, EosioError>
        if let res = res {
            result = EosioResult.success(res)
        } else {
            result = EosioResult.failure(EosioError(.rpcProviderError, reason: "Can't get block"))
        }
        completion(result)
    }
    public func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        let res = createRawAbiResponse(account: requestParameters.accountName)
        var result: EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>
        if let res = res {
            result = EosioResult.success(res)
        } else {
            result = EosioResult.failure(EosioError(.rpcProviderError, reason: "GetRawAbi Error"))
        }
        completion(result)
    }
    public func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
    }
    public func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
    }
    private func createInfoResponse() -> EosioRpcInfoResponse? {
        let json = """
        {
            "server_version": "0f6695cb",
            "chain_id": "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17",
            "head_block_num": 25260035,
            "last_irreversible_block_num": 25259987,
            "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
            "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
            "head_block_time": "2019-02-21T18:31:41.500",
            "head_block_producer": "blkproducer2",
            "virtual_block_cpu_limit": 200000000,
            "virtual_block_net_limit": 1048576000,
            "block_cpu_limit": 199900,
            "block_net_limit": 1048576,
            "server_version_string": "v1.3.0"
        }
        """
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(EosioRpcInfoResponse.self, from: json.data(using: .utf8)!) else {
            return nil
        }
        return response
    }
    private func createBlockResponse() -> EosioRpcBlockResponse? {
        let json = """
            {
                "timestamp": "2019-02-21T18:31:40.000",
                "producer": "blkproducer2",
                "confirmed": 0,
                "previous": "01816fffa4548475add3c45d0e0620f59468a6817426137b37851c23ccafa9cc",
                "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
                "action_mroot": "de5493939e3abdca80deeab2fc9389cc43dc1982708653cfe6b225eb788d6659",
                "schedule_version": 3,
                "new_producers": null,
                "header_extensions": [],
                "producer_signature": "SIG_K1_KZ3ptku7orAgcyMzd9FKW4jPC9PvjW9BGadFoyxdJFWM44VZdjW28DJgDe6wkNHAxnpqCWSzaBHB1AfbXBUn3HDzetemoA",
                "transactions": [],
                "block_extensions": [],
                "id": "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116",
                "block_num": 25260032,
                "ref_block_prefix": 2249927103
            }
        """
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(EosioRpcBlockResponse.self, from: json.data(using: .utf8)!) else {
            return nil
        }
        return response
    }
    private func createRawAbiResponse(account: EosioName) -> EosioRpcRawAbiResponse? {
        let json: String
        // swiftlint:disable line_length
        switch account.string {
        case "eosio.token":
            json = """
            {
            "account_name": "eosio.token",
            "code_hash": "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348",
            "abi_hash": "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248",
            "abi": "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA=="
            }
            """
        case "eosio":
            json = """
            {
            "account_name": "eosio",
            "code_hash": "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096",
            "abi_hash": "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441",
            "abi": "DmVvc2lvOjphYmkvMS4xADYIYWJpX2hhc2gAAgVvd25lcgRuYW1lBGhhc2gLY2hlY2tzdW0yNTYJYXV0aG9yaXR5AAQJdGhyZXNob2xkBnVpbnQzMgRrZXlzDGtleV93ZWlnaHRbXQhhY2NvdW50cxlwZXJtaXNzaW9uX2xldmVsX3dlaWdodFtdBXdhaXRzDXdhaXRfd2VpZ2h0W10KYmlkX3JlZnVuZAACBmJpZGRlcgRuYW1lBmFtb3VudAVhc3NldAdiaWRuYW1lAAMGYmlkZGVyBG5hbWUHbmV3bmFtZQRuYW1lA2JpZAVhc3NldAliaWRyZWZ1bmQAAgZiaWRkZXIEbmFtZQduZXduYW1lBG5hbWUMYmxvY2tfaGVhZGVyAAgJdGltZXN0YW1wBnVpbnQzMghwcm9kdWNlcgRuYW1lCWNvbmZpcm1lZAZ1aW50MTYIcHJldmlvdXMLY2hlY2tzdW0yNTYRdHJhbnNhY3Rpb25fbXJvb3QLY2hlY2tzdW0yNTYMYWN0aW9uX21yb290C2NoZWNrc3VtMjU2EHNjaGVkdWxlX3ZlcnNpb24GdWludDMyDW5ld19wcm9kdWNlcnMScHJvZHVjZXJfc2NoZWR1bGU/FWJsb2NrY2hhaW5fcGFyYW1ldGVycwARE21heF9ibG9ja19uZXRfdXNhZ2UGdWludDY0GnRhcmdldF9ibG9ja19uZXRfdXNhZ2VfcGN0BnVpbnQzMhltYXhfdHJhbnNhY3Rpb25fbmV0X3VzYWdlBnVpbnQzMh5iYXNlX3Blcl90cmFuc2FjdGlvbl9uZXRfdXNhZ2UGdWludDMyEG5ldF91c2FnZV9sZWV3YXkGdWludDMyI2NvbnRleHRfZnJlZV9kaXNjb3VudF9uZXRfdXNhZ2VfbnVtBnVpbnQzMiNjb250ZXh0X2ZyZWVfZGlzY291bnRfbmV0X3VzYWdlX2RlbgZ1aW50MzITbWF4X2Jsb2NrX2NwdV91c2FnZQZ1aW50MzIadGFyZ2V0X2Jsb2NrX2NwdV91c2FnZV9wY3QGdWludDMyGW1heF90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGW1pbl90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGG1heF90cmFuc2FjdGlvbl9saWZldGltZQZ1aW50MzIeZGVmZXJyZWRfdHJ4X2V4cGlyYXRpb25fd2luZG93BnVpbnQzMhVtYXhfdHJhbnNhY3Rpb25fZGVsYXkGdWludDMyFm1heF9pbmxpbmVfYWN0aW9uX3NpemUGdWludDMyF21heF9pbmxpbmVfYWN0aW9uX2RlcHRoBnVpbnQxNhNtYXhfYXV0aG9yaXR5X2RlcHRoBnVpbnQxNgZidXlyYW0AAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFcXVhbnQFYXNzZXQLYnV5cmFtYnl0ZXMAAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFYnl0ZXMGdWludDMyC2NhbmNlbGRlbGF5AAIOY2FuY2VsaW5nX2F1dGgQcGVybWlzc2lvbl9sZXZlbAZ0cnhfaWQLY2hlY2tzdW0yNTYMY2xhaW1yZXdhcmRzAAEFb3duZXIEbmFtZQljb25uZWN0b3IAAgdiYWxhbmNlBWFzc2V0BndlaWdodAdmbG9hdDY0CmRlbGVnYXRlYncABQRmcm9tBG5hbWUIcmVjZWl2ZXIEbmFtZRJzdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQSc3Rha2VfY3B1X3F1YW50aXR5BWFzc2V0CHRyYW5zZmVyBGJvb2wTZGVsZWdhdGVkX2JhbmR3aWR0aAAEBGZyb20EbmFtZQJ0bwRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldApkZWxldGVhdXRoAAIHYWNjb3VudARuYW1lCnBlcm1pc3Npb24EbmFtZRJlb3Npb19nbG9iYWxfc3RhdGUVYmxvY2tjaGFpbl9wYXJhbWV0ZXJzDQxtYXhfcmFtX3NpemUGdWludDY0GHRvdGFsX3JhbV9ieXRlc19yZXNlcnZlZAZ1aW50NjQPdG90YWxfcmFtX3N0YWtlBWludDY0HWxhc3RfcHJvZHVjZXJfc2NoZWR1bGVfdXBkYXRlFGJsb2NrX3RpbWVzdGFtcF90eXBlGGxhc3RfcGVydm90ZV9idWNrZXRfZmlsbAp0aW1lX3BvaW50DnBlcnZvdGVfYnVja2V0BWludDY0D3BlcmJsb2NrX2J1Y2tldAVpbnQ2NBN0b3RhbF91bnBhaWRfYmxvY2tzBnVpbnQzMhV0b3RhbF9hY3RpdmF0ZWRfc3Rha2UFaW50NjQbdGhyZXNoX2FjdGl2YXRlZF9zdGFrZV90aW1lCnRpbWVfcG9pbnQbbGFzdF9wcm9kdWNlcl9zY2hlZHVsZV9zaXplBnVpbnQxNhp0b3RhbF9wcm9kdWNlcl92b3RlX3dlaWdodAdmbG9hdDY0D2xhc3RfbmFtZV9jbG9zZRRibG9ja190aW1lc3RhbXBfdHlwZRNlb3Npb19nbG9iYWxfc3RhdGUyAAURbmV3X3JhbV9wZXJfYmxvY2sGdWludDE2EWxhc3RfcmFtX2luY3JlYXNlFGJsb2NrX3RpbWVzdGFtcF90eXBlDmxhc3RfYmxvY2tfbnVtFGJsb2NrX3RpbWVzdGFtcF90eXBlHHRvdGFsX3Byb2R1Y2VyX3ZvdGVwYXlfc2hhcmUHZmxvYXQ2NAhyZXZpc2lvbgV1aW50OBNlb3Npb19nbG9iYWxfc3RhdGUzAAIWbGFzdF92cGF5X3N0YXRlX3VwZGF0ZQp0aW1lX3BvaW50HHRvdGFsX3ZwYXlfc2hhcmVfY2hhbmdlX3JhdGUHZmxvYXQ2NA5leGNoYW5nZV9zdGF0ZQADBnN1cHBseQVhc3NldARiYXNlCWNvbm5lY3RvcgVxdW90ZQljb25uZWN0b3IEaW5pdAACB3ZlcnNpb24JdmFydWludDMyBGNvcmUGc3ltYm9sCmtleV93ZWlnaHQAAgNrZXkKcHVibGljX2tleQZ3ZWlnaHQGdWludDE2CGxpbmthdXRoAAQHYWNjb3VudARuYW1lBGNvZGUEbmFtZQR0eXBlBG5hbWULcmVxdWlyZW1lbnQEbmFtZQhuYW1lX2JpZAAEB25ld25hbWUEbmFtZQtoaWdoX2JpZGRlcgRuYW1lCGhpZ2hfYmlkBWludDY0DWxhc3RfYmlkX3RpbWUKdGltZV9wb2ludApuZXdhY2NvdW50AAQHY3JlYXRvcgRuYW1lBG5hbWUEbmFtZQVvd25lcglhdXRob3JpdHkGYWN0aXZlCWF1dGhvcml0eQdvbmJsb2NrAAEGaGVhZGVyDGJsb2NrX2hlYWRlcgdvbmVycm9yAAIJc2VuZGVyX2lkB3VpbnQxMjgIc2VudF90cngFYnl0ZXMQcGVybWlzc2lvbl9sZXZlbAACBWFjdG9yBG5hbWUKcGVybWlzc2lvbgRuYW1lF3Blcm1pc3Npb25fbGV2ZWxfd2VpZ2h0AAIKcGVybWlzc2lvbhBwZXJtaXNzaW9uX2xldmVsBndlaWdodAZ1aW50MTYNcHJvZHVjZXJfaW5mbwAIBW93bmVyBG5hbWULdG90YWxfdm90ZXMHZmxvYXQ2NAxwcm9kdWNlcl9rZXkKcHVibGljX2tleQlpc19hY3RpdmUEYm9vbAN1cmwGc3RyaW5nDXVucGFpZF9ibG9ja3MGdWludDMyD2xhc3RfY2xhaW1fdGltZQp0aW1lX3BvaW50CGxvY2F0aW9uBnVpbnQxNg5wcm9kdWNlcl9pbmZvMgADBW93bmVyBG5hbWUNdm90ZXBheV9zaGFyZQdmbG9hdDY0GWxhc3Rfdm90ZXBheV9zaGFyZV91cGRhdGUKdGltZV9wb2ludAxwcm9kdWNlcl9rZXkAAg1wcm9kdWNlcl9uYW1lBG5hbWURYmxvY2tfc2lnbmluZ19rZXkKcHVibGljX2tleRFwcm9kdWNlcl9zY2hlZHVsZQACB3ZlcnNpb24GdWludDMyCXByb2R1Y2Vycw5wcm9kdWNlcl9rZXlbXQZyZWZ1bmQAAQVvd25lcgRuYW1lDnJlZnVuZF9yZXF1ZXN0AAQFb3duZXIEbmFtZQxyZXF1ZXN0X3RpbWUOdGltZV9wb2ludF9zZWMKbmV0X2Ftb3VudAVhc3NldApjcHVfYW1vdW50BWFzc2V0C3JlZ3Byb2R1Y2VyAAQIcHJvZHVjZXIEbmFtZQxwcm9kdWNlcl9rZXkKcHVibGljX2tleQN1cmwGc3RyaW5nCGxvY2F0aW9uBnVpbnQxNghyZWdwcm94eQACBXByb3h5BG5hbWUHaXNwcm94eQRib29sC3JtdnByb2R1Y2VyAAEIcHJvZHVjZXIEbmFtZQdzZWxscmFtAAIHYWNjb3VudARuYW1lBWJ5dGVzBWludDY0BnNldGFiaQACB2FjY291bnQEbmFtZQNhYmkFYnl0ZXMKc2V0YWxpbWl0cwAEB2FjY291bnQEbmFtZQlyYW1fYnl0ZXMFaW50NjQKbmV0X3dlaWdodAVpbnQ2NApjcHVfd2VpZ2h0BWludDY0B3NldGNvZGUABAdhY2NvdW50BG5hbWUGdm10eXBlBXVpbnQ4CXZtdmVyc2lvbgV1aW50OARjb2RlBWJ5dGVzCXNldHBhcmFtcwABBnBhcmFtcxVibG9ja2NoYWluX3BhcmFtZXRlcnMHc2V0cHJpdgACB2FjY291bnQEbmFtZQdpc19wcml2BXVpbnQ4BnNldHJhbQABDG1heF9yYW1fc2l6ZQZ1aW50NjQKc2V0cmFtcmF0ZQABD2J5dGVzX3Blcl9ibG9jawZ1aW50MTYMdW5kZWxlZ2F0ZWJ3AAQEZnJvbQRuYW1lCHJlY2VpdmVyBG5hbWUUdW5zdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQUdW5zdGFrZV9jcHVfcXVhbnRpdHkFYXNzZXQKdW5saW5rYXV0aAADB2FjY291bnQEbmFtZQRjb2RlBG5hbWUEdHlwZQRuYW1lCXVucmVncHJvZAABCHByb2R1Y2VyBG5hbWUKdXBkYXRlYXV0aAAEB2FjY291bnQEbmFtZQpwZXJtaXNzaW9uBG5hbWUGcGFyZW50BG5hbWUEYXV0aAlhdXRob3JpdHkMdXBkdHJldmlzaW9uAAEIcmV2aXNpb24FdWludDgOdXNlcl9yZXNvdXJjZXMABAVvd25lcgRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldAlyYW1fYnl0ZXMFaW50NjQMdm90ZXByb2R1Y2VyAAMFdm90ZXIEbmFtZQVwcm94eQRuYW1lCXByb2R1Y2VycwZuYW1lW10Kdm90ZXJfaW5mbwAKBW93bmVyBG5hbWUFcHJveHkEbmFtZQlwcm9kdWNlcnMGbmFtZVtdBnN0YWtlZAVpbnQ2NBBsYXN0X3ZvdGVfd2VpZ2h0B2Zsb2F0NjQTcHJveGllZF92b3RlX3dlaWdodAdmbG9hdDY0CGlzX3Byb3h5BGJvb2wJcmVzZXJ2ZWQxBnVpbnQzMglyZXNlcnZlZDIGdWludDMyCXJlc2VydmVkMwVhc3NldAt3YWl0X3dlaWdodAACCHdhaXRfc2VjBnVpbnQzMgZ3ZWlnaHQGdWludDE2HwAAAEBJM5M7B2JpZG5hbWUAAABIUy91kzsJYmlkcmVmdW5kAAAAAABIc70+BmJ1eXJhbQAAsMr+SHO9PgtidXlyYW1ieXRlcwAAvIkqRYWmQQtjYW5jZWxkZWxheQCA0zVcXelMRAxjbGFpbXJld2FyZHMAAAA/KhumokoKZGVsZWdhdGVidwAAQMvaqKyiSgpkZWxldGVhdXRoAAAAAAAAkN10BGluaXQAAAAALWsDp4sIbGlua2F1dGgAAECemiJkuJoKbmV3YWNjb3VudAAAAAAAIhrPpAdvbmJsb2NrAAAAAODSe9WkB29uZXJyb3IAAAAAAKSpl7oGcmVmdW5kAACuQjrRW5m6C3JlZ3Byb2R1Y2VyAAAAAL7TW5m6CHJlZ3Byb3h5AACuQjrRW7e8C3JtdnByb2R1Y2VyAAAAAECaG6PCB3NlbGxyYW0AAAAAALhjssIGc2V0YWJpAAAAzk66aLLCCnNldGFsaW1pdHMAAAAAQCWKssIHc2V0Y29kZQAAAMDSXFOzwglzZXRwYXJhbXMAAAAAYLtbs8IHc2V0cHJpdgAAAAAASHOzwgZzZXRyYW0AAIDK5kpzs8IKc2V0cmFtcmF0ZQDAj8qGqajS1Ax1bmRlbGVnYXRlYncAAEDL2sDp4tQKdW5saW5rYXV0aAAAAEj0Vqbu1Al1bnJlZ3Byb2QAAEDL2qhsUtUKdXBkYXRlYXV0aAAwqcNuq5tT1Qx1cGR0cmV2aXNpb24AcBXSid6qMt0Mdm90ZXByb2R1Y2VyAA0AAACgYdPcMQNpNjQAAAhhYmlfaGFzaAAATlMvdZM7A2k2NAAACmJpZF9yZWZ1bmQAAAAgTXOiSgNpNjQAABNkZWxlZ2F0ZWRfYmFuZHdpZHRoAAAAAERzaGQDaTY0AAASZW9zaW9fZ2xvYmFsX3N0YXRlAAAAQERzaGQDaTY0AAATZW9zaW9fZ2xvYmFsX3N0YXRlMgAAAGBEc2hkA2k2NAAAE2Vvc2lvX2dsb2JhbF9zdGF0ZTMAAAA4uaOkmQNpNjQAAAhuYW1lX2JpZAAAwFchneitA2k2NAAADXByb2R1Y2VyX2luZm8AgMBXIZ3orQNpNjQAAA5wcm9kdWNlcl9pbmZvMgAAyApeI6W5A2k2NAAADmV4Y2hhbmdlX3N0YXRlAAAAAKepl7oDaTY0AAAOcmVmdW5kX3JlcXVlc3QAAAAAq3sV1gNpNjQAAA51c2VyX3Jlc291cmNlcwAAAADgqzLdA2k2NAAACnZvdGVyX2luZm8AAAAA="
            }
            """
        default:
            return nil
        }
        // swiftlint:enable line_length
        let decoder = JSONDecoder()
        guard let response = try? decoder.decode(EosioRpcRawAbiResponse.self, from: json.data(using: .utf8)!) else {
            return nil
        }
        return response
    }
}
