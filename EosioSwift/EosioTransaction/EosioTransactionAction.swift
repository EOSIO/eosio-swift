//
//  EosioTransactionAction.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/5/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public extension EosioTransaction {
    
    /// Action class for `EosioTransaction`
    public class Action: Codable {
        
        /// Contract account name
        public private(set) var account: EosioName
        /// Contract action name
        public private(set) var name: EosioName
        /// Authorization (actor and permission)
        public private(set) var authorization: [Authorization]
        /// Action data
        public private(set) var data: [String:Any]
        
        /// Action data as a json string
        public var dataJson: String? {
            return data.jsonString
        }
        /// Action data in serialized form
        public private(set) var dataSerialized: Data?
        /// Action data in serialized form as a hex string
        public var dataHex: String? {
            return dataSerialized?.hexEncodedString()
        }
        /// Is the action data serialized?
        public var isDataSerialized: Bool {
            return dataSerialized != nil
        }
        
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case account
            case name
            case authorization
            case data
        }
        
        
        /// Init Action struct with strings and an Encodable struct for data. Strings will be used to init EosioNames.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - data: action data (codable struct)
        /// - Throws: if the strings are not valid eosio names or data cannot be encoded
        public convenience init(account: String, name: String, authorization: [Authorization], data: Encodable) throws {
            try self.init(account: EosioName(account), name: EosioName(name), authorization: authorization, data: data)
        }

        
        /// Init Action struct with `EosioName`s and an Encodable struct for data.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - data: action data (codable struct)
        /// - Throws: if the strings are not valid eosio names or data cannot be encoded
        public init(account: EosioName, name: EosioName, authorization: [Authorization], data: Encodable) throws {
            self.account = account
            self.name = name
            self.authorization = authorization
            self.data = try data.toJsonString().jsonToDictionary()
        }
        
        
        /// Init Action struct with strings and serialized data. Strings will be used to init EosioNames.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - dataSerialized: data in serialized form
        /// - Throws: if the strings are not valid eosio names
        public convenience init(account: String, name: String, authorization: [Authorization], dataSerialized: Data) throws {
            try self.init(account: EosioName(account), name: EosioName(name), authorization: authorization, dataSerialized: dataSerialized)
        }
        
        
        /// Init Action struct with `EosioName`s and serialized data.
        ///
        /// - Parameters:
        ///   - account: contract account name
        ///   - name: contract action name
        ///   - authorization: authorization (actor and permission)
        ///   - dataSerialized: data in serialized form
        public init(account: EosioName, name: EosioName, authorization: [Authorization], dataSerialized: Data) {
            self.account = account
            self.name = name
            self.authorization = authorization
            self.dataSerialized = dataSerialized
            self.data = [String:Any]()
        }
        
        
        /// Init with decoder. The data property must be a hex string.
        ///
        /// - Parameter decoder: the decoder
        /// - Throws: if the input cannot be decoded into a Action struct
        required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            account = try container.decode(EosioName.self, forKey: .account)
            name = try container.decode(EosioName.self, forKey: .name)
            authorization = try container.decode([Authorization].self, forKey: .authorization)
            self.data = [String:Any]()
            
            if let dataString = try? container.decode(String.self, forKey: .data) {
                if let ds = Data(hexString: dataString) {
                    dataSerialized = ds
                } else {
                    throw EosioError(.parsingError, reason: "\(dataString) is not a valid hex string")
                }
            } else {
                throw EosioError(.parsingError, reason: "Data property is not set for action \(account)::\(name)")
            }
        }
        
        
        /// Encode this action using the Encodable protocol
        ///
        /// - Parameter encoder: the encoder
        /// - Throws: if the action cannot be encoded
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(account, forKey: .account)
            try container.encode(name, forKey: .name)
            try container.encode(authorization, forKey: .authorization)
            try container.encode(dataHex ?? "", forKey: .data)
        }
        
        
        /// Serialize the data from the `data` dictionary using serializationProvider and an abi, then set the `dataSerialized` property
        ///
        /// - Parameter abi: the abi as a json string
         /// - Paramerter serializationProvider: an EosioSerializationProviderProtocol conforming implementation for the transformation
        /// - Throws: if the data cannot be serialized
        public func serializeData(abi: String, serializationProviderType: EosioSerializationProviderProtocol.Type) throws {
            if isDataSerialized { return }
            guard let json = dataJson else {
                throw EosioError(.serializationError, reason: "Cannot convert data to json")
            }
            let serializationProvider = serializationProviderType.init()
            let hex = try serializationProvider.jsonToHex(contract: account.string, name: name.string, type: nil, json: json, abi: abi)
            guard let binaryData = Data(hexString: hex) else {
                throw EosioError(.serializationError, reason: "Cannot decode hex \(hex)")
            }
            self.dataSerialized = binaryData
        }
        
        
        /// Deserialize the data from the `dataSerialized` property using serializationProvider and an abi, then set the `data` dictionary
        ///
        /// - Parameter abi: the abi as a json string
        /// - Paramerter serializationProvider: an EosioSerializationProviderProtocol conforming implementation for the transformation
        /// - Throws: if the data cannot be deserialized
        public func deserializeData(abi: String, serializationProviderType: EosioSerializationProviderProtocol.Type) throws {
            if data.count > 0 { return }
            guard let dataHex = dataHex else {
                throw EosioError(.parsingError, reason: "Serialized data not set for action \(account)::\(name)")
            }
            let serializationProvider = serializationProviderType.init()
            let json = try serializationProvider.hexToJson(contract: account.string, name: name.string, type: nil, hex: dataHex, abi: abi)
            data = try json.jsonToDictionary()
        }
        
    }
    
}


extension EosioTransaction.Action {
    
    /// Authorization struct for `EosioTransaction.Action`
    public struct Authorization: Codable, Equatable {
        public var actor: EosioName
        public var permission: EosioName
        
        
        /// Init Authorization with EosioNames
        ///
        /// - Parameters:
        ///   - actor: actor as EosioName
        ///   - permission: permission as EosioName
        init(actor: EosioName, permission: EosioName) {
            self.actor = actor
            self.permission = permission
        }
        
        
        /// Init Authorization with strings
        ///
        /// - Parameters:
        ///   - actor: actor as String
        ///   - permission: permission as String
        /// - Throws: if the strings are not valid EosioNames
        init(actor: String, permission: String) throws {
            try self.init(actor: EosioName(actor), permission: EosioName(permission))
        }
        
    }
    
}




