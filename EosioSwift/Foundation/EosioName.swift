//
//  EosioName.swift
//
//  Created by Todd Bowden on 1/31/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

/// The EosioName struct provides validation that an eosio name is valid,
/// throwing errors on attemps to create an invalid name.
///
/// Eosio names are a max of 12 characters, `a-z`, `1-5` & `.`
/// Names may not begin or end with a period `.` or have two periods `..` in a row.
public struct EosioName: Codable, CustomStringConvertible, Equatable, Hashable {
    
  
    /// - Returns: The eosio name as a String
    public var description: String {
        return string
    }
    
    
    /// - Returns: The eosio name as a String
    private (set) public var string = ""
    
    
    /// Init with a String
    ///
    /// - Parameter name: an eosio name as a string
    /// - Throws: if not a valid eosio name
    public init(_ name: String) throws  {
        guard name.isValidEosioName else {
            throw EosioError(.eosioNameError, reason: "\(name) is not a valid eosio name.")
        }
        self.string = name
    }
    
    
    /// Init with a decoder
    ///
    /// - Parameter decoder: the docoder
    /// - Throws: if not a valid eosio name
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self).lowercased()
        guard string.isValidEosioName else {
            throw EosioError(.eosioNameError, reason: "\(string) is not a valid eosio name.")
        }
        self.string = string
    }

    
    /// Encode the eosio name to String
    ///
    /// - Parameter encoder: the encoder
    /// - Throws: if the name cannot be encoded
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
    
}


public extension String {
 
    /// - Returns: `true` if a string is a valid eosio name
    public var isValidEosioName: Bool {
        let pattern: String = "^[a-z1-5]{1,2}$|^[a-z1-5]{1}((?!\\.\\.)[a-z1-5\\.]){1,10}[a-z1-5]{1}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let match = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return match.count > 0
    }
}
