//
//  EosioSerializationProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 3/1/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public protocol EosioSerializationProviderProtocol {
    var error: String? { get }
    
    init()
    
    func serialize(contract: String?, name: String, type: String?, json: String, abi: String) throws  -> String
    func deserialize(contract: String?, name: String, type: String?, hex: String, abi: String) throws  -> String
    
    func serializeTransaction(contract: String?, name: String, type: String?, json: String) throws  -> String
    func deserializeTransaction(contract: String?, name: String, type: String?, hex: String) throws  -> String
    
    func serializeAbi(contract: String?, name: String, type: String?, json: String) throws  -> String
    func deserializeAbi(contract: String?, name: String, type: String?, hex: String) throws  -> String
}
