//
//  EosioTransactionAbis.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/16/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public extension EosioTransaction {

    /// Manages Application Binary Interfaces (ABIs) associated with an `EosioTransaction` instance
    class Abis {

        private var abis = [EosioName: Data]()
        public var serializationProvider: EosioSerializationProviderProtocol?

        /// Validate an abi
        /// - Parameter hex: The abi as a hex string
        /// - Throws: If the abi is not valid
        public func validateAbi(hex: String) throws {
            guard let serializer = self.serializationProvider else {
                preconditionFailure("A serializationProvider must be set!")
            }
            _ = try serializer.deserializeAbi(hex: hex)
        }

        /// Add an abi encoded as base64
        /// - Parameters:
        ///   - name: The contract name
        ///   - hex: The abi as a base64 string
        /// - Throws: If the base64 string is not valid or the abi is not valid
        public func addAbi(name: EosioName, base64: String) throws {
            let hex = try Data(base64: base64).hex
            try addAbi(name: name, hex: hex)
        }

        /// Add an abi encoded as hex
        /// - Parameters:
        ///   - name: The contract name
        ///   - hex: The abi as a hex string
        /// - Throws: If the hex string is not valid or the abi is not valid
        public func addAbi(name: EosioName, hex: String) throws {
            let abi = try Data(hex: hex)
            try validateAbi(hex: hex)
            abis[name] = abi
        }

        /// Add an abi as Data
        /// - Parameters:
        ///   - name: The contract name
        ///   - data: The abi as Data
        /// - Throws: If the abi is not valid
        public func addAbi(name: EosioName, data: Data) throws {
            try validateAbi(hex: data.hex)
            abis[name] = data
        }

        /// Array of contract names missing an abi
        /// - Parameter names: Contract names to look for
        /// - Returns: Contract names missing an abi
        public func missingAbis(names: [EosioName]) -> [EosioName] {
            return names.filter({ (name) -> Bool in
                abis[name] == nil
            })
        }

        /// Get the hash of the abi for a contract name
        /// - Parameter name: The contract name
        /// - Returns: The sha256 hash of the abi
        /// - Throws: If the abi is not available or not valid
        public func hashAbi(name: EosioName) throws -> String {
            guard let abi = abis[name] else {
                throw EosioError(.abiProviderError, reason: "No abi available for \(name)")
            }
            return abi.sha256.hex
        }

        /// Hash of abis
        /// - Returns: Dictionary of the sha256 hashes of the abis, keyed by contract name
        public func hashAbis() -> [EosioName: String] {
            return abis.mapValues({ (data) -> String in
                return data.sha256.hex
            })
        }

        /// Get the hex abi for a contract name
        /// - Parameter name: The contract name
        /// - Returns: The abi as hex
        /// - Throws: If the abi is not available or not valid
        public func hexAbi(name: EosioName) throws -> String {
            guard let hexAbi = abis[name]?.hex else {
                throw EosioError(.abiProviderError, reason: "No abi available for \(name)")
            }
            return hexAbi
        }

        /// The abis encoded as hex
        /// - Returns: Dictionary of the abis encoded as hex, keyed by contract name
        public func hexAbis() -> [EosioName: String] {
            return abis.mapValues({ (data) -> String in
                return data.hex
            })
        }

        /// The abis as json
        /// - Returns: Dictionary of the abis as json, keyed by contract name
        public func jsonAbis() throws -> [EosioName: String] {
            return try hexAbis().mapValues({ (hex) -> String in
                guard let serializer = self.serializationProvider else {
                    preconditionFailure("A serializationProvider must be set!")
                }
                return try serializer.deserializeAbi(hex: hex)
            })
        }

        /// Get the json abi for a contract name
        /// - Parameter name: The contract name
        /// - Returns: The abi as json
        /// - Throws: If the abi is not available or not valid
        public func jsonAbi(name: EosioName) throws -> String {
            let hexAbi = try self.hexAbi(name: name)
            guard let serializer = self.serializationProvider else {
                preconditionFailure("A serializationProvider must be set!")
            }
            return try serializer.deserializeAbi(hex: hexAbi)
        }

    }

}
