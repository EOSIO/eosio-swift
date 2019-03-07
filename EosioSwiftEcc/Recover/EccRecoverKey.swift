//
//  EccRecoverKey.swift
//  EosioSwiftCommon
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright (c) 2018-2019 block.one
//

import Foundation
import EosioSwift
import openssl

public class EccRecoverKey {
    
    public init() {
        
    }
    
    /// Recover a public key from the private key
    ///
    /// - Parameters:
    ///   - privateKey: The private key
    ///   - curve: The curve `K1` or `R1`
    /// - Returns: The public key
    public func recoverPublicKey(privateKey: Data, curve: String) -> Data?  {
        guard curve == "R1" || curve == "K1" else { return nil }
        
        guard let privKeyBN = BN_new() else { return nil }
        let key = EC_KEY_new()
        let ctx = BN_CTX_new()
        
        var curveName: Int32
        if curve == "R1" {
            curveName = NID_X9_62_prime256v1
        } else if curve == "K1" {
            curveName = NID_secp256k1
        } else {
            return nil
        }
        
        let group = EC_GROUP_new_by_curve_name(curveName)
        EC_KEY_set_group(key, group)
        
        var recoveredPubKeyHex = ""
        privateKey.withUnsafeBytes { (pkbytes: UnsafePointer<UInt8>) -> Void in
        
            BN_bin2bn(pkbytes, Int32(privateKey.count), privKeyBN)
            EC_KEY_set_private_key(key, privKeyBN)
            let pubKeyPoint = EC_POINT_new(group)
            EC_POINT_mul(group, pubKeyPoint, privKeyBN, nil, nil, ctx)
            
            let xBN = BN_new()!
            let yBN = BN_new()!
            EC_POINT_get_affine_coordinates_GFp(group, pubKeyPoint, xBN, yBN, nil)
            let xHex = String(cString: BN_bn2hex(xBN))
            let yHex = String(cString: BN_bn2hex(yBN))
            BN_free(xBN)
            BN_free(yBN)
            recoveredPubKeyHex = "04" + xHex + yHex
        }
        return Data(hexString: recoveredPubKeyHex)
    }
    
    
    /// Recover a public key from a signature, message
    ///
    /// - Parameters:
    ///   - signatureDer: The signature in der format
    ///   - message: The message
    ///   - recid: The recovery id (0-3)
    ///   - curve: The curve `K1` or `R1`
    /// - Returns: The public key
    public func recoverPublicKey(signatureDer: Data, message: Data, recid: Int, curve: String = "R1") -> Data? {
        
        var curveName: Int32
        if curve == "R1" {
            curveName = NID_X9_62_prime256v1
        } else if curve == "K1" {
            curveName = NID_secp256k1
        } else {
            return nil
        }
        
        var recoveredPubKeyHex = ""
        signatureDer.withUnsafeBytes { (derBytes: UnsafePointer<UInt8>) -> Void in
            let recoveredKey = EC_KEY_new_by_curve_name(curveName)
            var sig = ECDSA_SIG_new()
            var mutableDerBytes: UnsafePointer<UInt8>? = derBytes
            sig = d2i_ECDSA_SIG(&sig, &mutableDerBytes, signatureDer.count)
            
            message.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) -> Void in
                
                ECDSA_SIG_recover_key_GFp(recoveredKey, sig, messageBytes, Int32(message.count), Int32(recid), 1)
                guard let recoveredPubKey = EC_KEY_get0_public_key(recoveredKey) else { return }
                let xBN = BN_new()!
                let yBN = BN_new()!
                let group = EC_GROUP_new_by_curve_name(curveName)
                EC_POINT_get_affine_coordinates_GFp(group, recoveredPubKey, xBN, yBN, nil)
                let xHex = String(cString: BN_bn2hex(xBN))
                let yHex = String(cString: BN_bn2hex(yBN))
                //print(xHex)
                //print(yHex)
                BN_free(xBN)
                BN_free(yBN)
                EC_GROUP_free(group)
                recoveredPubKeyHex = "04" + xHex + yHex
            }
            ECDSA_SIG_free(sig)
        }
        return Data(hexString: recoveredPubKeyHex)
    }
    
    
    /// Get the recovery id (recid) for a signature, message and target public key
    ///
    /// - Parameters:
    ///   - signatureDer: The signature in der format
    ///   - message: The message
    ///   - targetPublicKey: The target public key
    ///   - curve: The curve `K1` or `R1`
    /// - Returns: The recovery id (0-3)
    /// - Throws: If none of the possible recids recover the target public key
    public func recid(signatureDer: Data, message: Data, targetPublicKey: Data, curve: String = "R1") throws -> Int {
        for i in 0...3 {
            if let recoveredPublicKey = recoverPublicKey(signatureDer: signatureDer, message: message, recid: i, curve: curve) {
                if recoveredPublicKey == targetPublicKey {
                    return i
                }
            }
        }
        throw EosioError(.signingError, reason:  "Unable to find recid for \(targetPublicKey.hex)" )
    }
    
    
}
