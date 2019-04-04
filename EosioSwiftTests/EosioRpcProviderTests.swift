//
//  EosioRpcProviderTests.swift
//  EosioSwiftTests
//
//  Created by Ben Martell on 4/3/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import XCTest
@testable import EosioSwift
import OHHTTPStubs

class EosioRpcProviderTests: XCTestCase {

    var rpcProvider: EosioRpcProviderProtocol? = nil
    
    override func setUp() {
        super.setUp()
        let url = URL(string: "https://api.testnet.dev.b1ops.net")
        rpcProvider = EosioRpcProvider(endpoint: url!)
        
        // display stub intercept occurance during testing.
        OHHTTPStubs.onStubActivation { (request, stub, rsponse) in
            print("\(request.url!) stubbed by \(stub.name!).")
        }
    }

    override func tearDown() {
        super.tearDown()
        
        // This needs to always happen: remove all stubs on tear down
        OHHTTPStubs.removeAllStubs()
    }
    
    func testGetBlock() {
        
        //This is a simple example of how a stub intercept works. This is the "happy path" example. Not that this NOT ONLY provides a response but is also validating the URL being called is actually correct (see the OHHTTPStubsTestBlock matchers in the OHHTTPStubs documentation at: https://github.com/AliSoftware/OHHTTPStubs/blob/master/README.md or simpley control click on isAbsoluteURLString and  jump to definiction below to see that and other matchers that are available.
        
        (stub(condition: isAbsoluteURLString("https://api.testnet.dev.b1ops.net/v1/chain/get_block")) { _ in
            
            //here we set the response to the request along with the HTTP staus code desired.
            let json = self.createBlockResponseJson()
            let data = json.data(using: .utf8)
            return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
        }).name = "Get Block stub"
        
        // Rest of standard testing stuff.
        let expect = expectation(description: "testGetBlock")
        
        let requestParameters = EosioRpcBlockRequest(block_num_or_id: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success(let infoResponse):
                XCTAssertTrue(infoResponse.blockNum == 25260032)
                XCTAssertTrue(infoResponse.refBlockPrefix == 2249927103)
                XCTAssertTrue(infoResponse.id == "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116")
            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    
    func testGetBlockServerError() {
        
        (stub(condition: isAbsoluteURLString("https://api.testnet.dev.b1ops.net/v1/chain/get_block")) { _ in
            
            //here we set the response to the request along with the HTTP staus code desired.
            let error = NSError(domain:NSURLErrorDomain, code:500, userInfo:nil)
            return OHHTTPStubsResponse(error:error)
        }).name = "Get Block Error stub"
        
        let expect = expectation(description: "testGetBlockError")
        
        let requestParameters = EosioRpcBlockRequest(block_num_or_id: 25260032)
        rpcProvider?.getBlock(requestParameters: requestParameters) { response in
            switch response {
            case .success( _):
               XCTFail()
            case .failure(let err):
                XCTAssertTrue(err.description == "Error was was encountered in RpcProvider.")
                if let origErr = err.originalError {
                     XCTAssertTrue(origErr.code == 500)
                } else {
                     XCTFail()
                }
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

    
}
