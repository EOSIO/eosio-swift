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
    func jsonToHex(contract: String?, name: String, type: String?, json: String, abi: Any) throws  -> String
    func hexToJson(contract: String?, name: String, type: String?, hex: String, abi: Any) throws  -> String
}
