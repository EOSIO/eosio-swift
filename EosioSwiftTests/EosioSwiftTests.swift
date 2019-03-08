//
//  EosioSwiftTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 1/24/19.
//  Copyright © 2018-2019 block.one.
//

import XCTest
@testable import EosioSwift

class EosioSwiftTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

final class MockSerializationProvider:EosioSerializationProviderProtocol{
    var error: String?
    
    func jsonToHex(contract: String?, name: String, type: String?, json: String, abi: Any) throws -> String {
        <#code#>
    }
    
    func hexToJson(contract: String?, name: String, type: String?, hex: String, abi: Any) throws -> String {
        <#code#>
    }
    
    
}
