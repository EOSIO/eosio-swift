//
//  File.swift
//  
//
//  Created by Steve McCoole on 9/25/20.
//
// These tests are set up to run against a local blockchain instance running on your development machine.  They are disabled by default because they
// likely will not match whatever contracts or abi's that you have set up.  They are here as an example of how you can do local testing of transaction
// submission and response handling without having to write app UI.
//

import XCTest
@testable import EosioSwiftAbieosSerializationProvider
@testable import EosioSwift
@testable import EosioSwiftSoftkeySignatureProvider

class ActionReturnTests: XCTestCase {
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
        let url = URL(string: "http://10.0.0.112:8888")!
        rpcProvider = EosioRpcProvider(endpoint: url)
        transaction.rpcProvider = rpcProvider
        transaction.serializationProvider = EosioAbieosSerializationProvider()
        transaction.signatureProvider = try EosioSoftkeySignatureProvider(privateKeys: ["5JuH9fCXmU3xbj8nRmhPZaVrxxXrdPaRmZLW1cznNTmTQR2Kg5Z"])
         */
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func skip_testActionReturn() throws {
        let action = try EosioTransaction.Action(
            account: EosioName("returnvalue"),
            name: EosioName("actionresret"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: EosioName("bob"),
                permission: EosioName("active"))
            ],
            data: [String: Any]()
        )
        transaction.add(action: action)
       
        let expect = expectation(description: "testActionReturn")
        
        transaction.signAndBroadcast { result in
            switch result {
            case .success:
                print("Transaction successful, action return value is: \(String(describing: action.returnValue))")
                let returnValue = action.returnValue as? Int32
                XCTAssertNotNil(returnValue)
                XCTAssert(returnValue == 10)
            case .failure(let error):
                print("Transaction failed, error: \(error)")
                XCTFail("Transaction error: \(error)")
            }
            expect.fulfill()
        }
        
        // If success I have a transaction id.
        
        wait(for: [expect], timeout: 30)
        
    }
    
    func skip_testNoActionReturn() throws {
        let action = try EosioTransaction.Action(
            account: EosioName("eosio.token"),
            name: EosioName("transfer"),
            authorization: [EosioTransaction.Action.Authorization(
                actor: EosioName("bob"),
                permission: EosioName("active"))
            ],
            data: Transfer(from: EosioName("bob"),
                           to: EosioName("alice"),
                           quantity: "42.0000 SYS",
                           memo: "This is only a test")
        )
        transaction.add(action: action)
       
        let expect = expectation(description: "testNoActionReturn")
        
        transaction.signAndBroadcast { result in
            switch result {
            case .success:
                print("Transaction successful, action return value is: \(String(describing: action.returnValue))")
                XCTAssertNil(action.returnValue)
            case .failure(let error):
                print("Transaction failed, error: \(error)")
                XCTFail("Transaction error: \(error)")
            }
            expect.fulfill()
        }
        
        // If success I have a transaction id.
        
        wait(for: [expect], timeout: 30)
        
    }
    
}
