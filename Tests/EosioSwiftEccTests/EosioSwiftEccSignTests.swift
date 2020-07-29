//
//  EosioSwiftEccSignTests.swift
//  EosioSwiftEccTests

//  Created by Todd Bowden on 3/8/19
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

import XCTest
@testable import EosioSwiftEcc

class EosioSwiftEccsignTests: XCTestCase {

    let publicKeyHex = "04257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd4366c7451a736e2921b3dfeefc2855e984d287d58a0dfb995045f339a0e8a2fd7a"
    let privateKeyHex = "c057a9462bc219abd32c6ca5c656cc8226555684d1ee8d53124da40330f656c1"

    let message = "Hello World".data(using: .utf8)!

    func test_signWithK1() {
        do {
            let publicKey = try Data(hex: publicKeyHex)
            let privateKey = try Data(hex: privateKeyHex)
            for _ in 1...10 {
                let sig = try EosioEccSign.signWithK1(publicKey: publicKey, privateKey: privateKey, data: message)
                guard sig.count == 65 else {
                    return XCTFail("sig.count not equal to 65")
                }
                let derSig = EcdsaSignature(r: sig[1...32], s: sig[33...64]).der
                let recid = Int(sig[0] - 31)

                let recoveredPubKey = try EccRecoverKey.recoverPublicKey(signatureDer: derSig, message: message.sha256, recid: recid, curve: .k1)
                XCTAssertEqual(recoveredPubKey.hex, publicKeyHex)
            }

        } catch {
            XCTFail("Unexpected error thrown")
        }

    }

}
