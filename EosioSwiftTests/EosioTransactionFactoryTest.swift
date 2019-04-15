//
//  EosioTransactionFactoryTest.swift
//  EosioSwiftTests
//
//  Created by Serguei Vinnitskii on 4/15/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import XCTest
@testable import EosioSwift

class EosioTransactionFactoryTest: XCTestCase {

    var rpcProvider: RPCProviderMock!
    var signatureProvider: SignatureProviderMock!
    var serializationProvider: SerializationProviderMock!

    override func setUp() {
        rpcProvider = RPCProviderMock(endpoint: URL(string: "http://example.com")!)
        serializationProvider = SerializationProviderMock()
        signatureProvider = SignatureProviderMock()
    }

    func testTransactionFactory() {

        let myTestNet = EosioTransactionFactory(rpcProvider: rpcProvider,
                                              signatureProvider: signatureProvider,
                                              serializationProvider: serializationProvider)
        let transaction = myTestNet.newTransaction()

        XCTAssertTrue(transaction.rpcProvider as? RPCProviderMock === self.rpcProvider)
        XCTAssertTrue(transaction.signatureProvider as? SignatureProviderMock === self.signatureProvider)
        XCTAssertTrue(transaction.serializationProvider as? SerializationProviderMock === self.serializationProvider)
        transaction.sign(publicKeys: ["PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"]) { (_) in
            XCTAssertEqual(transaction.signatures,
            ["SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"])
        }
    }
}
