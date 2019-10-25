//
//  DataExtensions.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import CommonCrypto

public extension Data {

    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }

    /// Get a hex-encoded string representation of the data.
    ///
    /// - Returns: Base16 encoded string representation of the data.
    func hexEncodedString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }

    /// Return the data as a hex encoded string
    var hex: String {
        return self.hexEncodedString()
    }

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
    init(hex: String) throws {
        guard let data = Data(hexString: hex) else {
            throw EosioError(.serializeError, reason: "\(hex) is not a valid hex string")
        }
        self = data
    }

    /// Initializes a data object from a Base16 encoded string.
    ///
    /// - Parameter hexString: A Base16 encoded string.
    init?(hexString: String) {
        guard let hexData = hexString.data(using: .ascii) else { return nil }

        let len = hexString.count / 2
        var data: Data?

        hexData.withUnsafeBytes { ptr in
            var dataPtrOffset = 0

            guard let baseAddress = ptr.baseAddress else { return }
            let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: len)

            for offset in stride(from: 0, to: hexString.count, by: 2) {
                let bytes = Data(bytes: baseAddress+offset, count: 2)

                guard let string = String(data: bytes, encoding: .ascii) else {
                    dataPtr.deallocate()
                    return
                }

                guard let num = UInt8(string, radix: 16) else {
                    dataPtr.deallocate()
                    return
                }
                dataPtr[dataPtrOffset] = num
                dataPtrOffset += 1
            }

            data = Data(bytesNoCopy: dataPtr, count: len, deallocator: .free)
        }

        guard let validData = data else { return nil }
        self = validData
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
