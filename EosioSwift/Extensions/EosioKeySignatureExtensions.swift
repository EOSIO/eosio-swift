//
//  EosioKeySignatureExtensions.swift
//  EosioSwift
//
//  Created by Todd Bowden on 5/5/18.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

// swiftlint:disable large_tuple
import Foundation

public extension String {

    /// Returns a tuple breaking an EOSIO key formatted xxx_xx_xxxxxxx into components.
    func eosioComponents() throws -> (prefix: String, version: String, body: String) {
        let components = self.components(separatedBy: "_")

        if components.count == 3 {
            return (prefix: components[0], version: components[1], body: components[2])

        } else if components.count == 1 {  // legacy format
            guard self.count > 3 else {
                throw EosioError(.signatureProviderError, reason: "\(self) is not a valid eosio key")
            }
            let eos = "EOS"
            let prefix = String(self.prefix(eos.count))
            let rest = String(self.suffix(self.count-eos.count))
            if prefix == eos {
                return (prefix: eos, version: "K1", body: rest)
            } else {
                return (prefix: "", version: "K1", body: self)
            }

        } else {
            throw EosioError(.signatureProviderError, reason: "\(self) is not a valid eosio key")
        }
    }
}

public extension Data {

    private func addPrefix(_ prefix: UInt8) -> Data {
        return [prefix] + self
    }

    private var append4ByteDoubleSha256Suffix: Data {
        let hash = self.sha256.sha256
        return self + hash.prefix(4)
    }

    /// Compresses a public key.
    var toCompressedPublicKey: Data? {
        guard self.count == 65 else { return nil }
        let uncompressedKey = self
        guard uncompressedKey[0] == 4 else { return nil }
        let x = uncompressedKey[1...32] // swiftlint:disable:this identifier_name
        let yLastByte = uncompressedKey[64]
        let flag: UInt8 = 2 + (yLastByte % 2)
        let compressedKey = Data([flag]) + x
        return compressedKey
    }

    /// Returns an EOSIO public key as a string formatted PUB_R1_xxxxxxxxxxxxxxxxxxx.
    var toEosioR1PublicKey: String {
        let keyR1 = self + "R1".data(using: .utf8)!
        let check = RIPEMD160.hash(message: keyR1).prefix(4)
        return "PUB_R1_" + (self + check).base58EncodedString
    }

    /// Returns an EOSIO public key as a string formatted PUB_K1_xxxxxxxxxxxxxxxxxxx.
    var toEosioK1PublicKey: String {
        let keyK1 = self + "K1".data(using: .utf8)!
        let check = RIPEMD160.hash(message: keyK1).prefix(4)
        return "PUB_K1_" + (self + check).base58EncodedString
    }

    /// Returns a legacy EOSIO public key as a string formatted EOSxxxxxxxxxxxxxxxxxxx.
    var toEosioLegacyPublicKey: String {
        let check = RIPEMD160.hash(message: self).prefix(4)
        return "EOS" + (self + check).base58EncodedString
    }

    /// Returns an EOSIO public key as a string formatted PUB_[curve]_xxxxxxxxxxxxxxxxxxx.
    func toEosioPublicKey(curve: String) throws -> String {
        if curve.uppercased() == "R1" {
            return self.toEosioR1PublicKey
        }
        if curve.uppercased() == "K1" {
            return self.toEosioK1PublicKey
        }
        throw EosioError(.signatureProviderError, reason: "Curve \(curve) is not supported")
    }

    /// Returns an EOSIO signature as a string formatted SIG_R1_xxxxxxxxxxxxxxxxxxx.
    var toEosioR1Signature: String {
        let r1 = Data(self) + "R1".data(using: .utf8)! // swiftlint:disable:this identifier_name
        let check = Data(RIPEMD160.hash(message: r1).prefix(4))
        return "SIG_R1_" + (Data(self) + check).base58EncodedString
    }

    /// Returns an EOSIO signature as a string formatted SIG_K1_xxxxxxxxxxxxxxxxxxx.
    var toEosioK1Signature: String {
        let k1 = Data(self) + "K1".data(using: .utf8)! // swiftlint:disable:this identifier_name
        let check = Data(RIPEMD160.hash(message: k1).prefix(4))
        return "SIG_K1_" + (Data(self) + check).base58EncodedString
    }

    /// Returns an EOSIO private key as a string formatted PVT_R1_xxxxxxxxxxxxxxxxxxx
    var toEosioR1PrivateKey: String {
        let r1 = Data(self) + "R1".data(using: .utf8)! // swiftlint:disable:this identifier_name
        let check = Data(RIPEMD160.hash(message: r1).prefix(4))
        return "PVT_R1_" + ((self + check).base58EncodedString)
    }

    /// Returns an EOSIO private key as a string formatted PVT_K1_xxxxxxxxxxxxxxxxxxx
    var toEosioK1PrivateKey: String {
        return "PVT_K1_" + self.addPrefix(0x80).append4ByteDoubleSha256Suffix.base58EncodedString
    }

    /// Init data signature from EOSIO R1 signature string.
    init(eosioR1Signature: String) throws {
        let components = try eosioR1Signature.eosioComponents()
        guard components.prefix == "SIG" else {
            throw EosioError(.signatureProviderError, reason: "\(eosioR1Signature) does not begin with SIG")
        }
        guard components.version == "R1" else {
            throw EosioError(.signatureProviderError, reason: "\(eosioR1Signature) is not of type R1")
        }
        guard let sigAndChecksum = Data.decode(base58: components.body) else {
            throw EosioError(.signatureProviderError, reason: "\(components.body) is not a valid base58 string")
        }
        // get the key, checksum and hash
        let sig = sigAndChecksum.prefix(sigAndChecksum.count-4)
        let checksum = sigAndChecksum.suffix(4)
        let hash = RIPEMD160.hash(message: sig + "R1".data(using: .utf8)!)

        // if the checksum and hash do not match, throw an error
        guard checksum == hash.prefix(4) else {
            throw EosioError(.signatureProviderError, reason: "Checksum \(checksum) is not equal to hash \(hash.prefix(4))")
        }
        // all done, set self to the key
        self = sig
    }

    /// Init data signature from EOSIO signature string.
    init(eosioSignature: String) throws {
        let components = try eosioSignature.eosioComponents()
        guard let sigAndChecksum = Data.decode(base58: components.body) else {
            throw EosioError(.signatureProviderError, reason: "\(components.body) is not a valid base58 string")
        }
        // get the sig, checksum and hash
        let sig = sigAndChecksum.prefix(sigAndChecksum.count-4)
        let checksum = sigAndChecksum.suffix(4)
        guard let versionData = components.version.data(using: .utf8) else {
            throw EosioError(.signatureProviderError, reason: "\(components.version) is not a valid signature type")
        }
        let hash = RIPEMD160.hash(message: sig + versionData)

        // if the checksum and hash do not match, throw an error
        guard checksum == hash.prefix(4) else {
            throw EosioError(.signatureProviderError, reason: "Checksum \(checksum) is not equal to hash \(hash.prefix(4))")
        }
        // all done, set self to the sig
        self = sig
    }

    /// Create a Data object in compressed ANSI X9.63 format from an EOSIO public key.
    init(eosioPublicKey: String) throws {
        guard eosioPublicKey.count > 0 else {
            throw EosioError(.signatureProviderError, reason: "Empty string is not a valid eosio key")
        }
        let components = try eosioPublicKey.eosioComponents()

        // decode the basse58 string into Data with the last 4 bytes being the checksum, throw error if not a valid b58 string
        guard let keyAndChecksum = Data.decode(base58: components.body) else {
            throw EosioError(.signatureProviderError, reason: "\(components.body) is not valid base 58")
        }

        // get the key, checksum and hash
        let key = keyAndChecksum.prefix(keyAndChecksum.count-4)
        let checksum = keyAndChecksum.suffix(4)
        var keyToHash = key
        if components.prefix == "PUB" || components.version == "R1" {
            keyToHash = key + components.version.data(using: .utf8)!
        }
        let hash = RIPEMD160.hash(message: keyToHash)

        // if the checksum and hash do not match, throw an error
        guard checksum == hash.prefix(4) else {
            throw EosioError(.signatureProviderError, reason: "Public key: \(key.hex) with checksum: \(checksum.hex) does not match \(hash.prefix(4).hex)")
        }
        // all done, set self to the key
        self = key
    }

    /// Create a Data object from an EOSIO private key.
    init(eosioPrivateKey: String) throws {
        guard eosioPrivateKey.count > 0 else {
            throw EosioError(.signatureProviderError, reason: "Empty string is not an EOS private key")
        }
        let components = try eosioPrivateKey.eosioComponents()

        // decode the basse58 string into Data with the last 4 bytes being the checksum, throw error if not a valid b58 string
        guard let keyAndChecksum = Data.decode(base58: components.body) else {
            throw EosioError(.signatureProviderError, reason: "\(components.body) is not valid base 58")
        }
        guard keyAndChecksum.count > 4 else {
            throw EosioError(.signatureProviderError, reason: "\(components.body) is not valid key")
        }

        // get the key, checksum and hash
        var key = keyAndChecksum.prefix(keyAndChecksum.count-4)
        let checksum = keyAndChecksum.suffix(4)
        var hash: Data
        var keyToHash: Data
        if components.version == "R1" {
            keyToHash = key + "R1".data(using: .utf8)!
            hash = RIPEMD160.hash(message: keyToHash)
        } else if components.version == "K1" {
            keyToHash = key
            hash = keyToHash.sha256.sha256
        } else {
            throw EosioError(.signatureProviderError, reason: "\(eosioPrivateKey) is not valid key")
        }

        // if the checksum and hash do not match, throw an error
        guard checksum == hash.prefix(4) else {
            throw EosioError(.signatureProviderError, reason: "Private key: \(key.hex) with checksum: \(checksum.hex) does not match \(hash.prefix(4).hex)")
        }

        if key.count == 33 {
            guard key.prefix(1) == Data([0x80]) else {
                throw EosioError(.signatureProviderError, reason: "33 byte private key: \(key.hex) does not begin with 80")
            }
            key = key.suffix(key.count-1)
        }
        guard key.count == 32 else {
            throw EosioError(.signatureProviderError, reason: "Private key: \(key.hex) should be 32 bytes")
        }
        self = key
    }

}
