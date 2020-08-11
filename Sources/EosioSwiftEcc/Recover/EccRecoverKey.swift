//
//  EccRecoverKey.swift
//  EosioSwiftCommon
//
//  Created by Todd Bowden on 7/11/18.
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import EosioSwift
import libtom

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

        // This is important or we will fault trying to invoke the math libraries!
        crypt_mp_init("ltm")

        var pubKeyData = Data()
        try privateKey.withUnsafeBytes { rawBufferPointer in
            let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let pkbytes = bufferPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of privateKey is nil.")
            }

            var key: ecc_key = ecc_key()
            switch curve {
            case .k1:
                var keyCurve: UnsafePointer<ltc_ecc_curve>?
                guard ecc_find_curve("SECP256K1", &keyCurve) == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Curve not found.")
                }
                guard ecc_set_curve(keyCurve, &key) == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Cannot set curve on key.")
                }
            case .r1:
                var keyCurve: UnsafePointer<ltc_ecc_curve>?
                guard ecc_find_curve("SECP256R1", &keyCurve) == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Curve not found.")
                }
                guard ecc_set_curve(keyCurve, &key) == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Cannot set curve on key.")
                }
            }

            guard ecc_set_key(pkbytes, UInt(privateKey.count), Int32(PK_PRIVATE.rawValue), &key) == CRYPT_OK else {
                throw EosioError(.keySigningError, reason: "Cannot load private key and create public key.")
            }

            let bufSize = Int(ECC_BUF_SIZE)
            let outbuf = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
            var outbufLen = UInt(bufSize)
            outbuf.initialize(repeating: 0, count: bufSize)
            defer {
                outbuf.deinitialize(count: bufSize)
                outbuf.deallocate()
            }

            guard ecc_get_key(outbuf, &outbufLen, Int32(PK_PUBLIC.rawValue), &key) == CRYPT_OK else {
                throw EosioError(.keySigningError, reason: "Cannot export public key.")
            }
            
            pubKeyData = Data(bytes: outbuf, count: Int(outbufLen))
        }
        return pubKeyData
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
    public class func recoverPublicKey(signatureDer: Data,
                                        message: Data,
                                        recid: Int,
                                        curve: EllipticCurveType = .r1) throws -> Data {

        // This is important or we will fault trying to invoke the math libraries!
        crypt_mp_init("ltm")

        var pubKeyData = Data()
        try signatureDer.withUnsafeBytes { rawSigPointer in
            let sigPointer = rawSigPointer.bindMemory(to: UInt8.self)
            guard let sigbytes = sigPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of signatureDer is nil.")
            }

            // Unfortunately there doesn't seem to be a way to avoid the nesting.
            try message.withUnsafeBytes { rawMessagePointer in
                let messagePointer = rawMessagePointer.bindMemory(to: UInt8.self)
                guard let msgbytes = messagePointer.baseAddress else {
                    throw EosioError(.keySigningError, reason: "Base address of message is nil.")
                }

                var key: ecc_key = ecc_key()
                switch curve {
                case .k1:
                    var keyCurve: UnsafePointer<ltc_ecc_curve>?
                    guard ecc_find_curve("SECP256K1", &keyCurve) == CRYPT_OK else {
                        throw EosioError(.keySigningError, reason: "Curve not found.")
                    }
                    guard ecc_set_curve(keyCurve, &key) == CRYPT_OK else {
                        throw EosioError(.keySigningError, reason: "Cannot set curve on key.")
                    }
                case .r1:
                    var keyCurve: UnsafePointer<ltc_ecc_curve>?
                    guard ecc_find_curve("SECP256R1", &keyCurve) == CRYPT_OK else {
                        throw EosioError(.keySigningError, reason: "Curve not found.")
                    }
                    guard ecc_set_curve(keyCurve, &key) == CRYPT_OK else {
                        throw EosioError(.keySigningError, reason: "Cannot set curve on key.")
                    }
                }

                let result = ecc_recover_key(sigbytes,
                                UInt(signatureDer.count),
                                msgbytes,
                                UInt(message.count),
                                Int32(recid),
                                LTC_ECCSIG_ANSIX962,
                                &key)
                guard result == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Error extracting key from signature.")
                }

                let bufSize = Int(ECC_BUF_SIZE)
                let outbuf = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
                var outbufLen = UInt(bufSize)
                outbuf.initialize(repeating: 0, count: bufSize)
                defer {
                    outbuf.deinitialize(count: bufSize)
                    outbuf.deallocate()
                }

                guard ecc_get_key(outbuf, &outbufLen, Int32(PK_PUBLIC.rawValue), &key) == CRYPT_OK else {
                    throw EosioError(.keySigningError, reason: "Cannot export public key.")
                }

                pubKeyData = Data(bytes: outbuf, count: Int(outbufLen))
            }
        }
        return pubKeyData
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
