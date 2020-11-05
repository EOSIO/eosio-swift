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
        let url = URL(string: "https://my.test.blockchain")!
        rpcProvider = EosioRpcProvider(endpoint: url)
        transaction.rpcProvider = rpcProvider
        transaction.serializationProvider = EosioAbieosSerializationProvider()
        transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"])
        */
         
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func skip_testGetKvTableRows() throws {
        let tablesRequest = EosioRpcKvTableRowsRequest(code: "todo",
                                                       table: "todo",
                                                       indexName: "uuid",
                                                       encodeType: .string,
                                                       json: true,
                                                       indexValue: "bf581bee-9f2c-447b-94ad-78e4984b6f51")
        
        let expect = expectation(description: "testGetKvTableRows")
        
        rpcProvider.getKvTableRows(requestParameters: tablesRequest) { result in
            switch result {
            case .failure(let error):
                XCTFail("Should not fail getKvTableRows call: \(error.localizedDescription)")
            case .success(let response):
                let rows = response.rows
                XCTAssertNotNil(rows)
                XCTAssert(rows.count > 0)
                response.rows.forEach { row in
                    print("row: \(row)")
                }
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 30)
    }
    
}

