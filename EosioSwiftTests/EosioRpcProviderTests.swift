//
//  EosioRpcProviderTests.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/3/19.
//  Copyright © 2019 block.one. All rights reserved.
//

// swiftlint:disable function_body_length line_length

import Foundation
import XCTest
@testable import EosioSwift
import OHHTTPStubs

class EosioRpcProviderTests: XCTestCase {

    var rpcProvider: EosioRpcProviderProtocol?

    override func setUp() {
        super.setUp()
        let url = URL(string: "https://localhost")
        rpcProvider = EosioRpcProvider(endpoint: url!)

        OHHTTPStubs.onStubActivation { (request, stub, _) in
            print("\(request.url!) stubbed by \(stub.name!).")
        }
    }

    override func tearDown() {
        super.tearDown()

        //remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }

    /**
     * Test RPC protocol provider implementation error handling.
     *
     */
    func testServerErrorHandled() {

        (stub(condition: isHost("localhost")) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: 500, userInfo: nil)
            return OHHTTPStubsResponse(error: error)
        }).name = "Server Error stub"

        let expect = expectation(description: "testServerError")

        let requestParameters = EosioRpcBlockRequest(block_num_or_id: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success:
                XCTFail()
            case .failure(let err):
                XCTAssertTrue(err.description == "Error was was encountered in RpcProvider.")
                XCTAssertNotNil(err.originalError)
                XCTAssertTrue(err.originalError!.code == 500)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)

    }

    /**
     * Test getBlock() protocol implementation.
     *
     */
    func testGetInfo() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_info")) { _ in
            let json = self.createInfoResponseJson()
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Info stub"

        let expect = expectation(description: "testGetInfo")
        rpcProvider?.getInfo { response in
            switch response {
            case .success(let infoResponse):
                guard let rpcInfoResponse = infoResponse as? EosioRpcInfoResponse else {
                    XCTFail()
                }
                XCTAssertTrue(rpcInfoResponse.serverVersion == "0f6695cb")
                XCTAssertTrue(rpcInfoResponse.headBlockNum == 25260035)
                XCTAssertTrue(rpcInfoResponse.headBlockId == "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05")
            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /**
     * Test getBlock() protocol implementation.
     *
     */
    func testGetBlock() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_block")) { _ in
            let json = self.createBlockResponseJson()
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Block stub"

        let expect = expectation(description: "testGetBlock")

        let requestParameters = EosioRpcBlockRequest(block_num_or_id: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let blockResponse):
                guard let rpcBlockResponse = blockResponse as? EosioRpcBlockResponse else {
                    XCTFail()
                }
                XCTAssertTrue(rpcBlockResponse.blockNum == 25260032)
                XCTAssertTrue(rpcBlockResponse.refBlockPrefix == 2249927103)
                XCTAssertTrue(rpcBlockResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /**
     * Test getRawAbi() protocol implementation with name.
     *
     */
    func testGetRawAbiEosio() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_abi")) { _ in
            let name = try? EosioName("eosio")
            let json = self.createRawApiResponseJson(account: name!)
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get RawAbi Name stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio")
            let requestParameters = EosioRpcRawAbiRequest(account_name: name)
            rpcProvider?.getRawAbi(requestParameters: requestParameters) { response in
                switch response {
                case .success(let rawAbiResponse):
                    guard let rpcRawAbiResponse = rawAbiResponse as? EosioRpcRawAbiResponse else {
                        XCTFail()
                    }
                    XCTAssertTrue(rpcRawAbiResponse.accountName == "eosio")
                    XCTAssertTrue(rpcRawAbiResponse.codeHash == "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096")
                    XCTAssertTrue(rpcRawAbiResponse.abiHash == "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
                case .failure(let err):
                    print(err.description)
                    XCTFail()
                }
                expect.fulfill()
            }
            wait(for: [expect], timeout: 30)
        } catch {
            print(error)
            XCTFail()
        }
    }

    /**
     * Test getRawAbi() protocol implementation with token.
     *
     */
    func testGetRawAbiToken() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_raw_abi")) { _ in
            let token = try? EosioName("eosio.token")
            let json = self.createRawApiResponseJson(account: token!)
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get RawAbi Token stub"

        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio.token")
            let requestParameters = EosioRpcRawAbiRequest(account_name: name)
            rpcProvider?.getRawAbi(requestParameters: requestParameters) { response in
                switch response {
                case .success(let rawAbiResponse):
                    guard let rpcRawAbiResponse = rawAbiResponse as? EosioRpcRawAbiResponse else {
                        XCTFail()
                    }
                    XCTAssertTrue(rpcRawAbiResponse.accountName == "eosio.token")
                    XCTAssertTrue(rpcRawAbiResponse.codeHash == "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348")
                    XCTAssertTrue(rpcRawAbiResponse.abiHash == "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                case .failure(let err):
                    print(err.description)
                    XCTFail()
                }
                expect.fulfill()
            }
            wait(for: [expect], timeout: 30)
        } catch {
            print(error)
            XCTFail()
        }
    }

    /**
     * Test getRequiredKeys() protocol implementation.
     *
     */
    func testGetRequiredKeys() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/get_required_keys")) { _ in
            let json = self.createRequiredKeysResponseJson()
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Required Keys stub"

        let expect = expectation(description: "testGetRequiredKeys")

        let transaction = EosioTransaction()
        let requestParameters = EosioRpcRequiredKeysRequest(availableKeys: ["PUB_K1_5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCw1oi9eG"], transaction: transaction)

        rpcProvider?.getRequiredKeys(requestParameters: requestParameters) { response in
            switch response {
            case .success(let requiredKeysResponse):
                guard let rpcRequiredKeysResponse = requiredKeysResponse as? EosioRpcRequiredKeysResponse else {
                    XCTFail()
                }
                XCTAssertTrue(rpcRequiredKeysResponse.requiredKeys.count == 1)
                XCTAssertTrue(rpcRequiredKeysResponse.requiredKeys[0] == "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba")

            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    /**
     * Test pushTransaction() protocol implementation.
     *
     */
    func testPushTransaction() {

        (stub(condition: isAbsoluteURLString("https://localhost/v1/chain/push_transaction")) { _ in
            let json = self.createPushTransActionResponseJson()
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Push Transaction stub"

        let expect = expectation(description: "testPushTransaction")

        let requestParameters = EosioRpcPushTransactionRequest(signatures: ["SIG_K1_JzFA9ffefWfrTBvpwMwZi81kR6tvHF4mfsRekVXrBjLWWikg9g1FrS9WupYuoGaRew5mJhr4d39tHUjHiNCkxamtEfxi68"], compression: 0, packedContextFreeData: "", packedTrx: "C62A4F5C1CEF3D6D71BD000000000290AFC2D800EA3055000000405DA7ADBA0072CBDD956F52ACD910C3C958136D72F8560D1846BC7CF3157F5FBFB72D3001DE4597F4A1FDBECDA6D59C96A43009FC5E5D7B8F639B1269C77CEC718460DCC19CB30100A6823403EA3055000000572D3CCDCD0143864D5AF0FE294D44D19C612036CBE8C098414C4A12A5A7BB0BFE7DB155624800A6823403EA3055000000572D3CCDCD0100AEAA4AC15CFD4500000000A8ED32323B00AEAA4AC15CFD4500000060D234CD3DA06806000000000004454F53000000001A746865206772617373686F70706572206C69657320686561767900")

        rpcProvider?.pushTransaction(requestParameters: requestParameters) { response in
            switch response {
            case .success(let pushedTransactionResponse):
                XCTAssertTrue(pushedTransactionResponse.transactionId == "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a")
            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }

    private func createBlockResponseJson() -> String {
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

        return json
    }

    private func createInfoResponseJson() -> String {
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
        return json
    }

    private func createRawApiResponseJson(account: EosioName) -> String {
        let json: String

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
            json = """
            {
            "code": 500,
            "message": "Internal Service Error",
            "error": {
            "code": 0,
            "name": "exception",
            "what": "unspecified",
            "details": [
            {
            "message": "unknown key (eosio::chain::name): ",
            "file": "http_plugin.cpp",
            "line_number": 584,
            "method": "handle_exception"
            }
            ]
            }
            }
            """
        }
        return json
    }

    private func createRequiredKeysResponseJson() -> String {

        let json = """
        {
            "required_keys": [
                               "EOS5j67P1W2RyBXAL8sNzYcDLox3yLpxyrxgkYy1xsXzVCvzbYpba"
                             ]
        }
        """
        return json

    }

    private func createPushTransActionResponseJson() -> String {

        let json = """
        {
           "transaction_id": "ae735820e26a7b771e1b522186294d7cbba035d0c31ca88237559d6c0a3bf00a"
        }
        """
        return json

    }
}
