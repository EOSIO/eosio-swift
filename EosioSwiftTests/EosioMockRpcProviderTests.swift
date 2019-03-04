//
//  EosioMockRpcProviderTests.swift
//  EosioSwiftTests
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import XCTest
import EosioSwift

class EosioMockRpcProviderTests: XCTestCase {
    
    var rpcProvider: EosioRpcProviderProtocol? = nil
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let endpoint = EosioEndpoint("https://api.testnet.dev.b1ops.net")
        rpcProvider = EosioRpcProviderMockImpl(endpoints: [endpoint!], failoverRetries: 3)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rpcProvider = nil
    }
    
    func testGetInfo() {
        let expect = expectation(description: "testGetInfo")
        rpcProvider?.getInfo() { response in
            switch response {
            case .success(let infoResponse):
                XCTAssertTrue(infoResponse.serverVersion == "0f6695cb")
                XCTAssertTrue(infoResponse.headBlockNum == 25260035)
                XCTAssertTrue(infoResponse.headBlockId == "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05")
            case .failure(let err):
                print(err.description)
                XCTFail()
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 30)
    }
    
    func testGetBlock() {
        let expect = expectation(description: "testGetBlock")
        rpcProvider?.getBlock(blockNum: 25260032) { response in
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
    
    func testGetRawAbiToken() {
        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio.token")
            rpcProvider?.getRawAbi(account: name) { response in
                switch response {
                case .success(let infoResponse):
                    XCTAssertTrue(infoResponse.accountName == "eosio.token")
                    XCTAssertTrue(infoResponse.codeHash == "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348")
                    XCTAssertTrue(infoResponse.abiHash == "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
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
    
    func testGetRawAbiEosio() {
        do {
            let expect = expectation(description: "testGetRawAbi")
            let name = try EosioName("eosio")
            rpcProvider?.getRawAbi(account: name) { response in
                switch response {
                case .success(let infoResponse):
                    XCTAssertTrue(infoResponse.accountName == "eosio")
                    XCTAssertTrue(infoResponse.codeHash == "add7914493bb911bbc179b19115032bbaae1f567f733391060edfaf79a6c8096")
                    XCTAssertTrue(infoResponse.abiHash == "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
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
    
}

