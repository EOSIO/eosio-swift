//
//  EcdsaSignature.swift
//  EosioVault
//
//  Created by Todd Bowden on 8/17/18.
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

// swiftlint:disable identifier_name shorthand_operator

import Foundation
import BigInt

/// EcdsaSignature manages an ECDSA signature with an option to convert a high `s` to low `s`.
public struct EcdsaSignature {
    /// A r curve data format.
    public var r: Data
    /// A s curve data format.
    public var s: Data
    /// A signature in der format.
    public var der: Data {
        var der = Data(capacity: 1 + 1 + 2 + 32 + 2 + 32)
        der = der + [0x30]
        der = der + [0x44]
        der = der + [0x02] + [0x20]
        der = der + r
        der = der + [0x02] + [0x20]
        der = der + s
        return der
    }

    /// Init an EcdsaSignature.
    ///
    /// - Parameters:
    ///   - der: A signature in der format.
    ///   - requireLowS: Option to convert a high `s` to low `s`.
    ///   - curve: The curve (`R1` or `K1`).
    public init?(der: Data?, requireLowS: Bool = true, curve: EllipticCurveType = .r1) { // swiftlint:disable:this cyclomatic_complexity
        guard let der = der else { return nil }
        guard der.count > 8 else { return nil }
        guard der[0] == 0x30 else { return nil }
        guard der[1] == der.count - 2 else { return nil }
        guard der[2] == 0x02 else { return nil }
        let rLen = Int(der[3])
        let rIndex = 4
        r = der[rIndex..<rIndex+rLen].suffix(32)
        guard r.count == 32 else { return nil }
        guard der[rLen+4] == 0x02 else { return nil }
        let sLen = Int(der[rLen+5])
        let sIndex = rLen+6
        s = der[sIndex..<sIndex+sLen].suffix(32)
        guard s.count == 32 else { return nil }

        if requireLowS && curve == .r1 {
            // n for r1 curve. reference: http://www.secg.org/SEC2-Ver-1.0.pdf
            guard let r1n = BigUInt(hex: "FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551") else { return nil }
            let s = BigUInt(self.s)
            if s > (r1n / 2) {
                self.s = (r1n - s).serialize()
            }
        }

        if requireLowS && curve == .k1 {
            // n for k1 curve
            guard let k1n = BigUInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364140") else { return nil }
            let s = BigUInt(self.s)
            if s > (k1n / 2) {
                self.s = (k1n - s).serialize()
            }
        }
    }

    /// Init an EcdsaSignature.
    ///
    /// - Parameters:
    ///   - r: A r curve data format.
    ///   - s: A s curve data format.
    public init(r: Data, s: Data) {
        self.r = r
        self.s = s
    }

}

fileprivate extension BigUInt {
    init?(hex: String) {
        guard let data = try? Data(hex: hex) else { return nil }
        self = BigUInt(data)
    }
}
