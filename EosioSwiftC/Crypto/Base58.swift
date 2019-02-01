//
//  Base58.swift
//  EosioSwiftC
//
//  Created by Steve McCoole on 11/8/18.
//  Copyright © 2018 Block One. All rights reserved.
//


import Foundation
import Crypto

public extension Data {
    
    public var base58EncodedString: String {
        var mult = 2
        while true {
            var enc = Data(repeating: 0, count: self.count * mult)
            
            let s = self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> String? in
                var size = enc.count
                let success = enc.withUnsafeMutableBytes { ptr -> Bool in
                    return b58enc(ptr, &size, bytes, self.count)
                }
                
                if success {
                    return String(data: enc.subdata(in: 0..<(size-1)), encoding: .utf8)!
                }
                else {
                    return nil
                }
            }
            
            if let s = s {
                return s
            }
            
            mult += 1
        }
    }
    
    
    public static func decode(base58: String) -> Data? {
        let source = base58.data(using: .utf8)!
        
        var bin = [UInt8](repeating: 0, count: source.count)
        
        var size = bin.count
        let success = source.withUnsafeBytes { (sourceBytes: UnsafePointer<CChar>) -> Bool in
            if b58tobin(&bin, &size, sourceBytes, source.count) {
                return true
            }
            return false
        }
        
        if success {
            return Data(bytes: bin[(bin.count - size)..<bin.count])
        }
        return nil
    }
}

public extension String {
    
    var isValidBase58: Bool {
        if let _ = Data.decode(base58: self) {
            return true
        } else {
            return false
        }
    }
    
}
