//
//  GetKvTableRowsTests.swift
//  
//
//  Created by Steve McCoole on 11/2/20.
//

import XCTest
@testable import EosioSwiftAbieosSerializationProvider
@testable import EosioSwift
@testable import EosioSwiftSoftkeySignatureProvider

class GetKvTableRowsTests: XCTestCase {
    var transaction = EosioTransaction()
    var rpcProvider: EosioRpcProvider!
    
    struct Transfer: Codable {
        var from: EosioName
        var to: EosioName // swiftlint:disable:this identifier_name
        var quantity: String
        var memo: String
    }
    
    override func setUpWithError() throws {
        /*
        transaction = EosioTransaction()
        let url = URL(string: "http://my.test.blockchain")!
        rpcProvider = EosioRpcProvider(endpoint: url)
        transaction.rpcProvider = rpcProvider
        transaction.serializationProvider = EosioAbieosSerializationProvider()
        transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["MyTestKey"])
         */
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func skip_testGetKvTableRows() throws {
        let tablesRequest = EosioRpcKvTableRowsRequest(code: "kvaddrbook",
                                                       table: "kvaddrbook",
                                                       indexName: "accname",
                                                       encodeType: .name,
                                                       json: true,
                                                       lowerBound: "jane",
                                                       reverse: false)
        
        let expect = expectation(description: "testGetKvTableRows")
        
        rpcProvider.getKvTableRows(requestParameters: tablesRequest) { result in
            switch result {
            case .failure(let error):
                XCTFail("Should not fail getKvTableRows call: \(error.localizedDescription)")
            case .success(let response):
                let rows = response.rows
                XCTAssertNotNil(rows)
                XCTAssert(rows.count == 4)
                response.rows.forEach { row in
                    print("row: \(row)")
                }
                if let entry1: [String: Any] = rows[0] as? [String: Any] {
                    XCTAssertEqual("jane", entry1["account_name"] as? String ?? "")
                    XCTAssertEqual("Jane", entry1["first_name"] as? String ?? "")
                    XCTAssertEqual("Doe", entry1["last_name"] as? String ?? "")
                } else {
                    XCTFail("Should be able to get entry as [String: Any]")
                }
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 30)
    }
    
}

