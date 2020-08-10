//
//  DataExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import CommonCrypto
import UIExtensions

public extension Data {

    /// Init a `Data` object with a base64 string.
    ///
    /// - Parameter base64: The data encoded as a base64 string.
    /// - Throws: If the string is not a valid base64 string.
    init(base64: String) throws {
        var base64 = base64.replacingOccurrences(of: "=", with: "")
        base64 += String(repeating: "=", count: base64.count % 4)

        guard let data = Data(base64Encoded: base64) else {
            throw EosioError(.serializeError, reason: "\(base64) is not a valid base64 string")
        }
        self = data
    }

    /// Init a `Data` object with a hex string.
    ///
    /// - Parameter hex: The data encoded as a hex string.
    /// - Throws: If the string is not a valid hex string.
    static func construct(hex: String) throws -> Data {
        guard let data = Data(hex: hex) else {
            throw EosioError(.serializeError, reason: "\(hex) is not a valid hex string")
        }

        return data
    }

    /// Returns the SHA256 hash of the data.
    var sha256: Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes { ptr in
            guard let baseAddress = ptr.baseAddress else { return }
            _ = CC_SHA256(baseAddress, CC_LONG(self.count), &hash)
        }
        return Data(hash)
    }

    /// Returns the current Data as a base58 encoded String.
    var base58EncodedString: String {
        return String(base58Encoding: self)
    }

    /// Decodes the given base58 String and returns it as Data, if valid.
    ///
    /// - Parameter base58: A Base58 encoded string.
    /// - Returns: The base58 String as Data.
    static func decode(base58: String) -> Data? {
        return Data(base58Decoding: base58)
    }
}
