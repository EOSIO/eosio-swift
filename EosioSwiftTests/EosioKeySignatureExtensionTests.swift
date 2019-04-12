//
//  EosioKeySignatureExtensionTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 3/11/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import XCTest
@testable import EosioSwift

class EosioKeySignatureExtensionTests: XCTestCase {

    let publicKey = "EOS5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eADEVm2"
    let publicKeyHex = "02257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd43"

    let publicKeyInvalid1 = "EQS5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eADEVm2"
    let publicKeyInvalid2 = "EOS5AzPqKAx4caCrRSAuyolY6rRKA3KJf4A1MY3paNVqV5eADEVm2"
    let publicKeyInvalid3 = "EOS5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eADEVm3"

    let publicKeyK1 = "PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"
    let publicKeyK1Hex = "02257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd43"

    let publicKeyK1Invalid1 = "PUD_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"
    let publicKeyK1Invalid2 = "PUB_X1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"
    let publicKeyK1Invalid3 = "PUB_K1_5AzPqKAx4caCrRSAuyolY6rRKA3KJf4A1MY3paNVqV5eGGP63Y"
    let publicKeyK1Invalid4 = "PUB_K1_5AzPqKAx4caCrRSAuyojY6rRKA3KJf4A1MY3paNVqV5eGGP64Y"

    let privateKeyHex = "c057a9462bc219abd32c6ca5c656cc8226555684d1ee8d53124da40330f656c1"
    let privateKey = "5KGziAsYALbLJiaaynE1GyG9fAq6p5n48K1B1JTQqCDfAJnioJD"
    let privateKeyK1 = "PVT_K1_5KGziAsYALbLJiaaynE1GyG9fAq6p5n48K1B1JTQqCDfAJnioJD"
    let privateKeyInvalid1 = "5KGziAsYALbLJiaaynE1GyG9fAq6p5n48K1B1JTQqCDfAJnioJC"
    let privateKeyInvalid2 = "PVT_K1_6KGziAsYALbLJiaaynE1GyG9fAq6p5n48K1B1JTQqCDfAJnioJD"

    let message = "Hello World".data(using: .utf8)!
    let signature0Hex = "304402207b80d705cc3f57f13000d79f6972c734a42d66aa42b8f698de998ff7594551f6022039b8d83f8ceba229e3b9e1d7efd844c978436e33b5cf79c19e92fbd69de7e4a5"
    let signature1Hex = "3044022061d3c08b3727396c56db35e94debf9c899c81cf888e0e9b5b7f1881e30b370620220035c9eb0f3f4e787784fcdfefd0147e222c18d25fe368b300cf583acedebbbc1"
    let signature0K1 = "SIG_K1_EsykzHxjT3BN8nUvwsiLVddddDi6WRuYaen7sfmJxE88EjLMp4kvSRjQE1iXuRfuwiaSUJLi1xFHjUVhfbBYJDVE27uGFU8R3E1Er"

    func test_Data_eosioPublicKey_legacy() {
        guard let data = try? Data(eosioPublicKey: publicKey) else {
            return XCTFail("Failed to convert public key to Data()")
        }
        XCTAssertEqual(data.hex, publicKeyHex)
    }

    func test_Data_eosioPublicKey_invalidLegacy_shouldFail() {
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyInvalid1))
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyInvalid2))
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyInvalid3))
    }

    func test_Data_eosioPublicKey_k1() {
        guard let data = try? Data(eosioPublicKey: publicKeyK1) else {
            return XCTFail("Failed to convert public K1 key to Data()")
        }
        XCTAssertEqual(data.hex, publicKeyHex)
    }

    func test_toEosioK1PublicKey() {
        let data = try? Data(hex: publicKeyK1Hex)
        XCTAssertEqual(data?.toEosioK1PublicKey, publicKeyK1)
    }

    func test_Data_eosioPublicKey_invalidK1_shouldFail() {
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyK1Invalid1))
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyK1Invalid2))
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyK1Invalid3))
        XCTAssertThrowsError(try Data(eosioPublicKey: publicKeyK1Invalid4))
    }

    func test_Data_eosioPrivateKey() {
        guard let data = try? Data(eosioPrivateKey: privateKey) else {
            return XCTFail("Failed to convert private key to Data()")
        }
        XCTAssertEqual(data.hex, privateKeyHex)
    }

    func test_Data_eosioPrivateKeyK1() {
        guard let data = try? Data(eosioPrivateKey: privateKeyK1) else {
            return XCTFail("Failed to convert public K1 key to Data()")
        }
        XCTAssertEqual(data.hex, privateKeyHex)
    }

    func test_Data_eosioPrivateKey_invalid_shouldFail() {
        XCTAssertThrowsError(try Data(eosioPrivateKey: privateKeyInvalid1))
        XCTAssertThrowsError(try Data(eosioPrivateKey: privateKeyInvalid2))
    }

    func test_toEosioK1Signature() {
        let data = try? Data(hex: signature0Hex)
        XCTAssertEqual(data?.toEosioK1Signature, signature0K1)
    }

    func test_Data_eosioSignature() {
        guard let data = try? Data(eosioSignature: signature0K1) else {
            return XCTFail("Failed to convert EOSIO signature to Data()")
        }
        XCTAssertEqual(data.hex, signature0Hex)
    }

    func test_compressedPublicKey() {
        let compressedPublicKey = "02257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd43"
        let unCompressedPublicKey = "04257784a3d0aceef73ea365ce01febaec1b671b971b9c9feb3f4901e7b773bd4366c7451a736e2921b3dfeefc2855e984d287d58a0dfb995045f339a0e8a2fd7a"
        let unCompressedKey = try? Data(hex: unCompressedPublicKey)
        XCTAssertEqual(unCompressedKey?.toCompressedPublicKey?.hex, compressedPublicKey)
    }

}
