//
//  EccRecoverKey.swift
//  EosioSwiftCommon
//
//  Created by Todd Bowden on 7/11/18.
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import EosioSwift
import openssl

/// Utilities for recovering supported ECC keys.
public class EccRecoverKey {

    /// Default init.
    public init() {

    }

    /// Recover a public key from the private key.
    ///
    /// - Parameters:
    ///   - privateKey: The private key.
    ///   - curve: The curve `K1` or `R1`.
    /// - Returns: The public key.
    /// - Throws: If the public key cannot be recovered, or another error is encountered.
    public class func recoverPublicKey(privateKey: Data, curve: EllipticCurveType) throws -> Data {

        let privKeyBN = BN_new()!
        let key = EC_KEY_new()
        let ctx = BN_CTX_new()

        var curveName: Int32
        switch curve {
        case .r1:
            curveName = NID_X9_62_prime256v1
        case .k1:
            curveName = NID_secp256k1
        }

        let group = EC_GROUP_new_by_curve_name(curveName)
        EC_KEY_set_group(key, group)

        var recoveredPubKeyHex = ""
        try privateKey.withUnsafeBytes { rawBufferPointer in
            let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let pkbytes = bufferPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of privateKey is nil.")
            }

            BN_bin2bn(pkbytes, Int32(privateKey.count), privKeyBN)
            EC_KEY_set_private_key(key, privKeyBN)
            let pubKeyPoint = EC_POINT_new(group)
            EC_POINT_mul(group, pubKeyPoint, privKeyBN, nil, nil, ctx)

            let xBN = BN_new()!
            let yBN = BN_new()!
            EC_POINT_get_affine_coordinates_GFp(group, pubKeyPoint, xBN, yBN, nil)

            let xBNstr = BN_bn2hex(xBN)!
            let yBNstr = BN_bn2hex(yBN)!

            let xHex = String(cString: xBNstr)
            let xPad = max(64, xHex.count)
            let xHexPadded = String(repeatElement("0", count: xPad - xHex.count) + xHex)

            let yHex = String(cString: yBNstr)
            let yPad = max(64, yHex.count)
            let yHexPadded = String(repeatElement("0", count: yPad - yHex.count) + yHex)

            CRYPTO_free(xBNstr)
            CRYPTO_free(yBNstr)

            BN_free(xBN)
            BN_free(yBN)
            EC_POINT_free(pubKeyPoint)
            recoveredPubKeyHex = "04" + xHexPadded + yHexPadded
        }
        EC_GROUP_free(group)
        BN_CTX_free(ctx)
        EC_KEY_free(key)
        BN_free(privKeyBN)
        return try Data(hex: recoveredPubKeyHex)
    }

    /// Recover a public key from a signature, message.
    ///
    /// - Parameters:
    ///   - signatureDer: The signature in der format.
    ///   - message: The message.
    ///   - recid: The recovery id (0-3).
    ///   - curve: The curve `K1` or `R1`.
    /// - Returns: The public key.
    /// - Throws: If unable to recover the target public key.
    public class func recoverPublicKey(signatureDer: Data, message: Data, recid: Int, curve: EllipticCurveType = .r1) throws -> Data {

        var curveName: Int32
        switch curve {
        case .r1:
            curveName = NID_X9_62_prime256v1
        case .k1:
            curveName = NID_secp256k1
        }

        var recoveredPubKeyHex = ""
        try signatureDer.withUnsafeBytes { rawBufferPointer -> Void in
            let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let derBytes = bufferPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of signatureDer is nil.")
            }

            let recoveredKey = EC_KEY_new_by_curve_name(curveName)
            var sig = ECDSA_SIG_new()
            var mutableDerBytes: UnsafePointer<UInt8>? = derBytes
            sig = d2i_ECDSA_SIG(&sig, &mutableDerBytes, signatureDer.count)
            guard sig != nil else {
                throw EosioError(.keySigningError, reason: "Signature \(signatureDer.hex) is not valid" )
            }
            try message.withUnsafeBytes { rawBufferPointer in
                let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
                guard let messageBytes = bufferPointer.baseAddress else {
                    throw EosioError(.keySigningError, reason: "Base address of message is nil.")
                }

                ECDSA_SIG_recover_key_GFp(recoveredKey, sig, messageBytes, Int32(message.count), Int32(recid), 1)
                guard let recoveredPubKey = EC_KEY_get0_public_key(recoveredKey) else { return }
                let xBN = BN_new()!
                let yBN = BN_new()!
                let group = EC_GROUP_new_by_curve_name(curveName)
                EC_POINT_get_affine_coordinates_GFp(group, recoveredPubKey, xBN, yBN, nil)
                let xBNstr = BN_bn2hex(xBN)!
                let yBNstr = BN_bn2hex(yBN)!
                let xHex = String(cString: xBNstr)
                let yHex = String(cString: yBNstr)
                CRYPTO_free(xBNstr)
                CRYPTO_free(yBNstr)
                BN_free(xBN)
                BN_free(yBN)
                EC_GROUP_free(group)
                recoveredPubKeyHex = "04" + xHex + yHex
            }
            ECDSA_SIG_free(sig)
            EC_KEY_free(recoveredKey)
        }
        return try Data(hex: recoveredPubKeyHex)
    }

 /// Get the recovery id (recid) for a signature, message and target public key.
 ///
 /// - Parameters:
 ///   - signatureDer: The signature in der format.
 ///   - message: The message.
 ///   - targetPublicKey: The target public key.
 ///   - curve: The curve `K1` or `R1`.
 /// - Returns: The recovery id (0-3).
 /// - Throws: If none of the possible recids recover the target public key.
 public class func recid(signatureDer: Data, message: Data, targetPublicKey: Data, curve: EllipticCurveType = .r1) throws -> Int {
        for i in 0...3 {
            let recoveredPublicKey = try recoverPublicKey(signatureDer: signatureDer, message: message, recid: i, curve: curve)
            if recoveredPublicKey == targetPublicKey {
                return i
            }
        }
        throw EosioError(.keySigningError, reason: "Unable to find recid for \(targetPublicKey.hex)" )
    }

}
