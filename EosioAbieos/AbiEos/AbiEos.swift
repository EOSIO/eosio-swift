//
//  ABIEOS.swift
//  EOSAPI
//
//  Created by Todd Bowden on 6/16/18.
//  Copyright © 2018 Block One. All rights reserved.
//

import Foundation
import AbiEos

class AbiEos {
    
    public class Error: EosioError { }
    
    private var context = abieos_create()
    private var abiJsonString = ""
    
    var error: String? {
        return String(validatingUTF8: abieos_get_error(context))
    }

    
    func refreshContext() {
        //abieos_destroy(context)
        //context = abieos_create()
    }
    
    func name64(string: String?) -> UInt64 {
        guard let string = string else { return 0 }
        return abieos_string_to_name(context, string)
    }
    
    func string(name64: UInt64) -> String? {
        return String(validatingUTF8: abieos_name_to_string(context, name64))
    }
    
    private func getAbiJsonString(contract:String?, name: String, abi: Any) throws -> String {
        var abiString = abi as? String ?? ""
        if abiString.suffix(8) == "abi.json" {
            let path = Bundle(for: AbiEos.self).url(forResource: abiString, withExtension: nil)?.path ?? ""
            abiString = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
        } else if let abiDict = abi as? [String:Any] {
            abiString = jsonString(dictionary: abiDict) ?? ""
        }
        guard abiString != "" else {
            throw Error(EosioErrorCode.vaultError, reason: "Json to hex -- No ABI provided for \(contract ?? "") \(name)")
        }
        return abiString
    }
    
    func jsonToHex(contract: String?, name: String, json: String, abi: Any, isReorderable: Bool = false) throws -> String {
        
        refreshContext()
        let contract64 = name64(string: contract)
        abiJsonString = try getAbiJsonString(contract: contract, name: name, abi: abi)
        
        // set the abi
        let setAbiResult = abieos_set_abi(context, contract64, abiJsonString)
        guard setAbiResult == 1 else {
            throw Error(EosioErrorCode.vaultError, reason: "Json to hex -- Unable to set ABI. \(self.error ?? "")")
        }
        
        var jsonToBinResult: Int32 = 0
        if isReorderable {
            jsonToBinResult = abieos_json_to_bin_reorderable(context, contract64, name, json)
        } else {
            jsonToBinResult = abieos_json_to_bin(context, contract64, name, json)
        }
        
        guard jsonToBinResult == 1 else {
            throw Error(EosioErrorCode.vaultError, reason: "Unable to pack json to bin. \(self.error ?? "")")
        }
        
        guard let hex = String(validatingUTF8: abieos_get_bin_hex(context)) else {
            throw Error(EosioErrorCode.vaultError, reason: "Unable to convert binary to hex")
        }
        return hex
    }
    
    
    func hexToJson(contract: String?, name: String, hex: String, abi: Any) throws -> String {
        let contract64 = name64(string: contract)
        abiJsonString = try getAbiJsonString(contract: contract, name: name, abi: abi)
        
        // set the abi
        let setAbiResult = abieos_set_abi(context, contract64, abiJsonString)
        guard setAbiResult == 1 else {
            throw Error(EosioErrorCode.vaultError, reason: "Hex to json -- Unable to set ABI. \(self.error ?? "")")
        }
     
        if let json = abieos_hex_to_json(context, contract64, name, hex) {
            if let string = String(validatingUTF8: json) {
                return string
            } else {
                throw Error(EosioErrorCode.vaultError, reason: "Unable to convert c string json to String.)")
            }
        } else {
            throw Error(EosioErrorCode.vaultError, reason: "Unable to unpack hex to json. \(self.error ?? "")")
        }
        
    }
    
    private func jsonString(dictionary: [String:Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    
    
}
