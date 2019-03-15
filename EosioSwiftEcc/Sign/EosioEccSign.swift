//
//  EccSign.swift
//  EosioSwiftEcc

//  Created by Todd Bowden on 3/8/19
//  Copyright (c) 2018-2019 block.one
//


import Foundation
import EosioSwift
import openssl

public class EosioEccSign {
    
    static let k1SignMaxAttempts = 100
    
    /// Sign data with a K1 key for validation on an eosio chain
    ///
    /// - Parameters:
    ///   - publicKey: The public key to recover
    ///   - privateKey: The private key used to sign
    ///   - data: The data to sign
    /// - Returns: A signature (header byte + r + s)
    /// - Throws: If the data cannot be signed or the public key cannot be recovered, or another error is encountered
    public class func signWithK1(publicKey: Data, privateKey: Data, data: Data) throws -> Data {
        let privKeyBN = BN_new()!
        let key = EC_KEY_new()
        let group = EC_GROUP_new_by_curve_name(NID_secp256k1);
        EC_KEY_set_group(key, group);
        
        privateKey.withUnsafeBytes { (pkbytes: UnsafePointer<UInt8>) -> Void in
            BN_bin2bn(pkbytes, Int32(privateKey.count), privKeyBN);
            EC_KEY_set_private_key(key, privKeyBN)
        }
        
        var digest = data.sha256
        
        var signature: Data?
        var signingError: Error?
        var attemptsRequired = 0
        
        for i in 1...k1SignMaxAttempts {
            var der = Data(count: 100)
            var numBytes: Int32 = 0
            digest.withUnsafeBytes { (digestBytes: UnsafePointer<UInt8>) -> Void in
                let sig = ECDSA_do_sign(digestBytes, Int32(digest.count), key)
                der.withUnsafeMutableBytes{ (derPointer: UnsafeMutablePointer<UInt8>) -> Void in
                    var derPointer: UnsafeMutablePointer<UInt8>? = derPointer
                    numBytes = i2d_ECDSA_SIG(sig, &derPointer);
                }
            }
            der = der.prefix(Int(numBytes))
            
            guard der.count >= 70 else { continue }
            
            guard let sig = EcdsaSignature(der: der, requireLowS: true, curve: "K1") else { continue }
            
            // Get recovery id (recid)
            let recover = EccRecoverKey()
            var recid = 0
            do {
                recid = try recover.recid(signatureDer: sig.der, message: data.sha256, targetPublicKey: publicKey, curve: "K1")
                let recPubKey = try recover.recoverPublicKey(signatureDer: sig.der, message: data.sha256, recid: recid)
                guard recPubKey.count == 65 else { continue }
            } catch {
                signingError = EosioError(.signingError, reason: error.eosioError.localizedDescription)
                continue
            }
            let headerByte: UInt8 = 27 + 4 + UInt8(recid)
            
            
            // Check for canonical
            // ref https://github.com/EOSIO/fc/blob/9a0ed1f85e38adc6ace8c944b5f5f725f4829ba2/src/crypto/elliptic_common.cpp#L161
            let c:Data = [headerByte] + sig.r + sig.s
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
        
        if let signature = signature {
            return signature
        } else {
            if let signingError = signingError {
                throw signingError
            } else {
                throw EosioError(.signingError, reason: "Unable to create canonical signature after \(k1SignMaxAttempts) attempts")
            }
        }
    }
    
    
    
}
