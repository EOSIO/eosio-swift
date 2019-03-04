//
//  DataExtensions.swift
//  EosioSwiftFoundation
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import CommonCrypto

public extension Data {
    
    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
    
    /**
        Returns Base16 encoded string representation of the data.
    */
    public func hexEncodedString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }
    
    
    /// Return the data as a hex encoded string
    public var hex: String {
        return self.hexEncodedString()
    }
    
    
    
    /// Init a `Data` object with a base64 string
    ///
    /// - Parameter base64: The data encoded as a base64 string
    /// - Throws: If the string is not a valid base64 string
    public init(base64: String) throws {
        var base64 = base64.replacingOccurrences(of: "=", with: "")
        base64 = base64 + String(repeating: "=", count: base64.count % 4)
        
        guard let data = Data(base64Encoded: base64) else {
            throw EosioError(.dataCodingError, reason: "\(base64) is not a valid base64 string")
        }
        self = data
    }
    
    /// Init a `Data` object with a hex string
    ///
    /// - Parameter hex: The data encoded as a hex string
    /// - Throws: If the string is not a valid hex string
    public init(hex: String) throws {
        guard let data = Data(hexString: hex) else {
            throw EosioError(.dataCodingError, reason: "\(hex) is not a valid hex string")
        }
        self = data
    }
    
    
    /**
        Initializes a data object from a Base16 encoded string.
 
        - Parameters:
            - hexString: A Base16 encoded string.
    */
    public init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    /**
        Returns the SHA256 hash of the data.
    */
    public var sha256: Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(self.count), &hash)
        }
        return Data(bytes: hash)
    }
    
}
