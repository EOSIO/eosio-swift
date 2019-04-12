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

    func serializeTransaction(json: String) throws  -> String
    func deserializeTransaction(hex: String) throws  -> String

    func serializeAbi(json: String) throws  -> String
    func deserializeAbi(hex: String) throws  -> String
}
