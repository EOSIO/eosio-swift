//
//  Recover.swift
//  EosioVault
//
//  Created by Todd Bowden on 7/11/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation
import Recover

public class RecoverKey {
    
    class Error: EosioError { }
    
    public init() {
        
    }
    
    public func recoverPublicKey(privateKey: Data, curve: String) -> Data?  {
        guard curve == "R1" || curve == "K1" else { return nil }
        
        let privKeyBN = BN_new()!
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
        
        let group = EC_GROUP_new_by_curve_name(curveName);
        EC_KEY_set_group(key, group);
        
        var recoveredPubKeyHex = ""
        privateKey.withUnsafeBytes { (pkbytes: UnsafePointer<UInt8>) -> Void in
        
            BN_bin2bn(pkbytes, Int32(privateKey.count), privKeyBN);
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
            print(recoveredPubKeyHex)
        }
        return Data(hexString: recoveredPubKeyHex)
    }
    
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
            //print(message.hexEncodedString())
            //print(message.count)
            
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
    
    public func recid(signatureDer: Data, message: Data, targetPublicKey: Data, curve: String = "R1") throws -> Int {
        for i in 0..<4 {
            if let recoveredKey = recoverPublicKey(signatureDer: signatureDer, message: message, recid: i, curve: curve) {
                //print("Recovered Key: \(recoveredKey.hexEncodedString())")
                if recoveredKey == targetPublicKey {
                    return i
                }
            }
        }
        throw Error(EosioErrorCode.signingError, reason:  "Unable to find recid for \(targetPublicKey.hexEncodedString())" )
    }
    
    
}
