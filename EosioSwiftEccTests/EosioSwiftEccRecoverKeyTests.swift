//
//  EosioSwiftEccRecoverKeyTests.swift
//  EosioSwiftEccTests

//  Created by Todd Bowden on 3/7/19
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import XCTest
@testable import EosioSwiftEcc

class EosioSwiftEccRecoverKeyTests: XCTestCase {

    let publicKeyHex = "04257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd4366c7451a736e2921b3dfeefc2855e984d287d58a0dfb995045f339a0e8a2fd7a"
    let privateKeyHex = "c057a9462bc219abd32c6ca5c656cc8226555684d1ee8d53124da40330f656c1"

    let message = "Hello World".data(using: .utf8)!
    let signature0Hex = "304402207b80d705cc3f57f13000d79f6972c734a42d66aa42b8f698de998ff7594551f6022039b8d83f8ceba229e3b9e1d7efd844c978436e33b5cf79c19e92fbd69de7e4a5"
    let signature1Hex = "3044022061d3c08b3727396c56db35e94debf9c899c81cf888e0e9b5b7f1881e30b370620220035c9eb0f3f4e787784fcdfefd0147e222c18d25fe368b300cf583acedebbbc1"

    func test_recoverPublicKey_from_private_key() {
        do {
            let privateKey = try Data(hex: privateKeyHex)
            let pubKey = try EccRecoverKey.recoverPublicKey(privateKey: privateKey, curve: .k1)
            XCTAssertEqual(pubKey.hex, publicKeyHex)
        } catch {
            XCTFail("Unexpected error thrown")
        }

    }

    func test_recid() {
        do {
            let signature0 = try Data(hex: signature0Hex)
            let signature1 = try Data(hex: signature1Hex)
            let publicKey = try Data(hex: publicKeyHex)

            let recid0 = try EccRecoverKey.recid(signatureDer: signature0, message: message.sha256, targetPublicKey: publicKey, curve: .k1)
            XCTAssertEqual(recid0, 0)

            let recid1 = try EccRecoverKey.recid(signatureDer: signature1, message: message.sha256, targetPublicKey: publicKey, curve: .k1)
            XCTAssertEqual(recid1, 1)

        } catch {
            XCTFail("Unexpected error thrown")
        }
    }

    func test_recoverPublicKey_from_signature_and_message() {
        do {

            let signature0 = try Data(hex: signature0Hex)
            let signature1 = try Data(hex: signature1Hex)

            let recoveredPubKey0 = try EccRecoverKey.recoverPublicKey(signatureDer: signature0, message: message.sha256, recid: 0, curve: .k1)
            XCTAssertEqual(publicKeyHex, recoveredPubKey0.hex)

            let recoveredPubKey1 = try EccRecoverKey.recoverPublicKey(signatureDer: signature1, message: message.sha256, recid: 1, curve: .k1)
            XCTAssertEqual(publicKeyHex, recoveredPubKey1.hex)

        } catch {
            print(error)
            XCTFail("Unexpected error thrown: \(error)")
        }

    }

}
