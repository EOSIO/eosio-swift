//
//  EccSign.swift
//  EosioSwiftEcc

//  Created by Todd Bowden on 3/8/19
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

// swiftlint:disable identifier_name
import Foundation
import EosioSwift
import Recover
import libtom

/// EosioEccSign manages ECC signing.
public class EosioEccSign {

    static let k1SignMaxAttempts = 100

    public class func signWithK1_2(publicKey: Data, privateKey: Data, data: Data) throws -> Data {

        register_all_ciphers()
        register_all_hashes()
        register_all_prngs()

        // This is important or we will fault trying to invoke the math libraries!
        crypt_mp_init("ltm")

        var yarrowState = prng_state()
        guard rng_make_prng(128, find_prng("yarrow"), &yarrowState, nil) == CRYPT_OK else {
            throw EosioError(.keySigningError, reason: "Error initializing signing.")
        }
        
        var key: ecc_key = ecc_key()

        let digest = data.sha256
        var recid = Int32(0)
        var signature: Data?
        var attemptsRequired = 0

        try privateKey.withUnsafeBytes { rawBufferPointer in
            let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let pkbytes = bufferPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of privateKey is nil.")
            }

            var keyCurve: UnsafePointer<ltc_ecc_curve>?
            guard ecc_find_curve("SECP256K1", &keyCurve) == CRYPT_OK else {
                throw EosioError(.keySigningError, reason: "Curve not found.")
            }
            guard ecc_set_curve(keyCurve, &key) == CRYPT_OK else {
                throw EosioError(.keySigningError, reason: "Cannot set curve on key.")
            }

            guard ecc_set_key(pkbytes, UInt(privateKey.count), Int32(PK_PRIVATE.rawValue), &key) == CRYPT_OK else {
                throw EosioError(.keySigningError, reason: "Cannot load private key and create public key.")
            }

            try digest.withUnsafeBytes { rawBufferPointer in
                let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
                guard let digestBytes = bufferPointer.baseAddress else {
                    throw EosioError(.keySigningError, reason: "Base address of digest is nil.")
                }

                let bufSize = Int(1000)
                let outbuf = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
                var outbufLen = UInt(bufSize)
                defer {
                    outbuf.deinitialize(count: bufSize)
                    outbuf.deallocate()
                }

                for i in 1...k1SignMaxAttempts {
                    outbuf.initialize(repeating: 0, count: bufSize)
                    let sigResult = ecc_sign_hash_ex(digestBytes,
                                                     UInt(digest.count),
                                                     outbuf,
                                                     &outbufLen,
                                                     &yarrowState,
                                                     find_prng("yarrow"),
                                                     LTC_ECCSIG_RFC7518,
                                                     &recid,
                                                     &key)
                    guard sigResult == CRYPT_OK else {
                        throw EosioError(.keySigningError, reason: "Error in keysigning attemp.")
                    }
                    let sig = Data(bytes: outbuf, count: Int(outbufLen))

                    // Check for canonical
                    // ref https://github.com/EOSIO/fc/blob/9a0ed1f85e38adc6ace8c944b5f5f725f4829ba2/src/crypto/elliptic_common.cpp#L161
                    let headerByte: UInt8 = 27 + 4 + UInt8(recid)
                    let c: Data = [headerByte] + sig
                    let isCanonical =
                        c[1] & 0x80 == 0 &&
                        !(c[1] == 0 && (c[2] & 0x80 == 0)) &&
                        c[33] & 0x80 == 0 &&
                        !(c[33] == 0 && (c[34] & 0x80 == 0))

                    if isCanonical {
                        signature = [headerByte] + sig
                        attemptsRequired = i
                        break
                    }
                }
            }
        }

        print("attempts required = \(attemptsRequired)")

        if let signature = signature {
            return signature
        } else {
            throw EosioError(.keySigningError, reason: "Unable to create canonical signature after \(k1SignMaxAttempts) attempts")
        }

    }

    /// Sign data with a K1 key for validation on an eosio chain.
    ///
    /// - Parameters:
    ///   - publicKey: The public key to recover.
    ///   - privateKey: The private key used to sign.
    ///   - data: The data to sign.
    /// - Returns: A signature (header byte + r + s).
    /// - Throws: If the data cannot be signed or the public key cannot be recovered, or another error is encountered.
    public class func signWithK1(publicKey: Data, privateKey: Data, data: Data) throws -> Data { // swiftlint:disable:this function_body_length
        let privKeyBN = BN_new()!
        let key = EC_KEY_new()
        let group = EC_GROUP_new_by_curve_name(NID_secp256k1)
        EC_KEY_set_group(key, group)

        try privateKey.withUnsafeBytes { rawBufferPointer in
            let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
            guard let pkbytes = bufferPointer.baseAddress else {
                throw EosioError(.keySigningError, reason: "Base address of privateKey is nil.")
            }

            BN_bin2bn(pkbytes, Int32(privateKey.count), privKeyBN)
            EC_KEY_set_private_key(key, privKeyBN)
        }

        let digest = data.sha256

        var signature: Data?
        var signingError: Error?
        var attemptsRequired = 0

        for i in 1...k1SignMaxAttempts {
            var der = Data(count: 100)
            var numBytes: Int32 = 0
            try digest.withUnsafeBytes { rawBufferPointer in
                let bufferPointer = rawBufferPointer.bindMemory(to: UInt8.self)
                guard let digestBytes = bufferPointer.baseAddress else {
                    throw EosioError(.keySigningError, reason: "Base address of digest is nil.")
                }

                let sig = ECDSA_do_sign(digestBytes, Int32(digest.count), key)
                der.withUnsafeMutableBytes { mutableRawBufferPointer in
                    let mutableBufferPointer = mutableRawBufferPointer.bindMemory(to: UInt8.self)
                    var derPointer: UnsafeMutablePointer<UInt8>? = mutableBufferPointer.baseAddress
                    numBytes = i2d_ECDSA_SIG(sig, &derPointer)
                }
                ECDSA_SIG_free(sig)
            }

            der = der.prefix(Int(numBytes))

            guard der.count >= 70 else { continue }

            guard let sig = EcdsaSignature(der: der, requireLowS: true, curve: EllipticCurveType.k1) else { continue }

            // Get recovery id (recid)
            var recid = 0
            do {
                recid = try EccRecoverKey.recid(signatureDer: sig.der, message: data.sha256, targetPublicKey: publicKey, curve: .k1)
                let recPubKey = try EccRecoverKey.recoverPublicKey(signatureDer: sig.der, message: data.sha256, recid: recid)
                guard recPubKey.count == 65 else { continue }
            } catch {
                signingError = EosioError(.keySigningError, reason: error.eosioError.localizedDescription)
                continue
            }
            let headerByte: UInt8 = 27 + 4 + UInt8(recid)

            // Check for canonical
            // ref https://github.com/EOSIO/fc/blob/9a0ed1f85e38adc6ace8c944b5f5f725f4829ba2/src/crypto/elliptic_common.cpp#L161
            let c: Data = [headerByte] + sig.r + sig.s
            let isCanonical =
                c[1] & 0x80 == 0 &&
                    !(c[1] == 0 && (c[2] & 0x80 == 0)) &&
                    c[33] & 0x80 == 0 &&
                    !(c[33] == 0 && (c[34] & 0x80 == 0))

            if isCanonical {
                signature = [headerByte] + sig.r + sig.s
                attemptsRequired = i
                break
            }
        }
        print("attempts required = \(attemptsRequired)")

        EC_GROUP_free(group)
        EC_KEY_free(key)
        BN_free(privKeyBN)

        if let signature = signature {
            return signature
        } else {
            if let signingError = signingError {
                throw signingError
            } else {
                throw EosioError(.keySigningError, reason: "Unable to create canonical signature after \(k1SignMaxAttempts) attempts")
            }
        }
    }

}
