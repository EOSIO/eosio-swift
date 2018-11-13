//
//  Data+Sha.swift
//  Keys
//
//  Created by Todd Bowden on 5/22/18.
//

import Foundation
import CommonCrypto

public extension Data {
    
    public var sha256: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(self.count), &hash)
        }
        return Data(bytes: hash)
    }
    
}
