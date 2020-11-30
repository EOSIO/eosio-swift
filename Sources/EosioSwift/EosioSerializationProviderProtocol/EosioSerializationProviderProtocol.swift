//
//  EosioSerializationProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 3/1/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// The protocol to which serialization provider implementations must conform.
/// Serialization providers are responsible for ABI-driven transaction and action
/// serialization and deserialization between JSON and binary data representations.
public protocol EosioSerializationProviderProtocol {
    /// Used to hold errors.
    var error: String? { get }

    /// Initializer for the `EosioSerializationProviderProtocol`.
    init()

    /// The method signature for general serialization requests to conforming serialization providers.
    /// Carries out JSON to binary conversion using ABIs.

    ///
    /// - Parameters:
    ///   - contract: An optional `String` representing contract name for the serialize action lookup for this conversion.
    ///   - name: An optional `String` representing an action name that is used in conjunction with contract (above) to derive the serialize type name.
    ///   - type: An optional `String` representing the type name for the action lookup for this serialize conversion.
    ///   - json: The JSON data `String` to serialize to binary.
    ///   - abi: A `String` representation of the ABI to use for conversion.
    /// - Returns: A `String` of binary serialized data.
    /// - Throws: If the data cannot be serialized for any reason.
    func serialize(contract: String?, name: String, type: String?, json: String, abi: String) throws  -> String

    /// The method signature for general deserialization requests to conforming serialization providers.
    /// Carries out binary to JSON conversion using ABIs.
    ///
    /// - Parameters:
    ///   - contract: An optional `String` representing contract name for the deserialize action lookup for this conversion.
    ///   - name: An optional `String` representing an action name that is used in conjunction with contract (above) to derive the deserialize type name.
    ///   - type: An optional `String` representing the type name for the action lookup for this deserialize conversion.
    ///   - hex: The binary data `String` to deserialize to a JSON String.
    ///   - abi: A `String` representation of the ABI to use for conversion.
    /// - Returns: A `String` of JSON data.
    /// - Throws: If the data cannot be deserialized for any reason.
    func deserialize(contract: String?, name: String, type: String?, hex: String, abi: String) throws  -> String

    /// The method signature for transaction serialization requests to conforming serialization providers.
    /// Convert JSON Transaction data representation to binary `String` representation of Transaction data.
    ///
    /// - Parameter json: The JSON representation of Transaction data to serialize.
    /// - Returns: A binary `String` representation of Transaction data.
    /// - Throws: If the data cannot be serialized for any reason.
    func serializeTransaction(json: String) throws  -> String

    /// The method signature for transaction deserialization requests to conforming serialization providers.
    /// Converts a binary `String` representation of Transaction data to JSON `String` of Transaction data.
    ///
    /// - Parameter hex: The binary Transaction data `String` to deserialize.
    /// - Returns: A `String` of JSON Transaction data.
    /// - Throws: If the data cannot be deserialized for any reason.
    func deserializeTransaction(hex: String) throws  -> String

    /// The method signature for ABI serialization requests to conforming serialization providers.
    /// Convert JSON ABI to a `String` binary representation of data.
    ///
    /// - Parameter json: The JSON data `String` to serialize.
    /// - Returns: A `String` representation of binary data.
    /// - Throws: If the data cannot be serialized for any reason.
    func serializeAbi(json: String) throws  -> String

    /// The method signature for ABI deserialization requests to conforming serialization providers.
    /// Converts a binary `String` hex representation of an ABI to a JSON `String`.
    ///
    /// - Parameter hex: The binary data `String` to deserialize.
    /// - Returns: A `String` of JSON data.
    /// - Throws: If the data cannot be deserialized for any reason.
    func deserializeAbi(hex: String) throws  -> String
}
