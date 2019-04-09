//
//  ABIEOS.swift
//  EosioSwiftAbieos
//
//  Created by Todd Bowden on 6/16/18.
//  Copyright © 2018-2019 block.one.
//

import Foundation
import EosioSwift

public class AbiEos: EosioSerializationProviderProtocol {

    public class Error: EosioError { }

    private var context = abieos_create()
    private var abiJsonString = ""

    public var error: String? {
        return String(validatingUTF8: abieos_get_error(context))
    }

    required public init() {

    }

    deinit {
        abieos_destroy(context)
    }

    public func name64(string: String?) -> UInt64 {
        guard let string = string else { return 0 }
        return abieos_string_to_name(context, string)
    }

    public func string(name64: UInt64) -> String? {
        return String(validatingUTF8: abieos_name_to_string(context, name64))
    }

    private func refreshContext() {
        if context != nil {
            abieos_destroy(context)
        }
        context = abieos_create()
    }

    private func getAbiJsonFile(fileName: String) throws -> String {
        var abiString = ""
        let path = Bundle(for: AbiEos.self).url(forResource: fileName, withExtension: nil)?.path ?? ""
        abiString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
        guard abiString != "" else {
            throw Error(.serializationProviderError, reason: "Json to hex -- No ABI file found for \(fileName)")
        }
        return abiString
    }

    public func serializeTransaction(json: String) throws -> String {
        let transactionJson = try getAbiJsonFile(fileName: "transaction.abi.json")
        return try serialize(contract: nil, name: "", type: "transaction", json: json, abi: transactionJson)
    }

    public func serializeAbi(json: String) throws -> String {
        let abiJson = try getAbiJsonFile(fileName: "abi.abi.json")
        return try serialize(contract: nil, name: "", type: "abi_def", json: json, abi: abiJson)
    }

    public func serialize(contract: String?, name: String = "", type: String? = nil, json: String, abi: String) throws -> String {

        refreshContext()

        let contract64 = name64(string: contract)
        abiJsonString = abi

        // set the abi
        let setAbiResult = abieos_set_abi(context, contract64, abiJsonString)
        guard setAbiResult == 1 else {
            throw Error(.serializationProviderError, reason: "Json to hex -- Unable to set ABI. \(self.error ?? "")")
        }

        // get the type name for the action
        guard let type = type ?? getType(action: name, contract: contract64) else {
            throw Error(.serializationProviderError, reason: "Unable find type for action \(name). \(self.error ?? "")")
        }

        var jsonToBinResult: Int32 = 0
        jsonToBinResult = abieos_json_to_bin_reorderable(context, contract64, type, json)

        guard jsonToBinResult == 1 else {
            throw Error(.serializationProviderError, reason: "Unable to pack json to bin. \(self.error ?? "")")
        }

        guard let hex = String(validatingUTF8: abieos_get_bin_hex(context)) else {
            throw Error(.serializationProviderError, reason: "Unable to convert binary to hex")
        }
        return hex
    }

    public func deserializeTransaction(hex: String) throws -> String {
        let transactionJson = try getAbiJsonFile(fileName: "transaction.abi.json")
        return try deserialize(contract: nil, name: "", type: "transaction", hex: hex, abi: transactionJson)
    }

    public func deserializeAbi(hex: String) throws -> String {
        let abiJson = try getAbiJsonFile(fileName: "abi.abi.json")
        return try deserialize(contract: nil, name: "", type: "abi_def", hex: hex, abi: abiJson)
    }

    public func deserialize(contract: String?, name: String = "", type: String? = nil, hex: String, abi: String) throws -> String {

        refreshContext()

        let contract64 = name64(string: contract)
        abiJsonString = abi

        // set the abi
        let setAbiResult = abieos_set_abi(context, contract64, abiJsonString)
        guard setAbiResult == 1 else {
            throw Error(.serializationProviderError, reason: "Hex to json -- Unable to set ABI. \(self.error ?? "")")
        }

        // get the type name for the action
        guard let type = type ?? getType(action: name, contract: contract64) else {
            throw Error(.serializationProviderError, reason: "Unable find type for action \(name). \(self.error ?? "")")
        }

        if let json = abieos_hex_to_json(context, contract64, type, hex) {
            if let string = String(validatingUTF8: json) {
                return string
            } else {
                throw Error(.serializationProviderError, reason: "Unable to convert c string json to String.)")
            }
        } else {
            throw Error(.serializationProviderError, reason: "Unable to unpack hex to json. \(self.error ?? "")")
        }

    }

    // get the type name for the action and contract
    private func getType(action: String, contract: UInt64) -> String? {
        let action64 = name64(string: action)
        if let type = abieos_get_type_for_action(context, contract, action64) {
            return String(validatingUTF8: type)
        } else {
            return nil
        }
    }

    private func jsonString(dictionary: [String: Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

}
