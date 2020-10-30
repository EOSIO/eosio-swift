//
//  EosioRpcProviderEndpointsForProtocol.swift
//  EosioSwift
//
//  Created by Brandon Fancher on 4/22/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

// MARK: - RPC methods used by `EosioTransaction`. These force conformance only to the protocols, not the entire response structs.
extension EosioRpcProvider: EosioRpcProviderProtocol {

    /// Call `chain/get_info`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameter completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcInfoResponseProtocol` and an optional `EosioError`.
    public func getInfoBase(completion: @escaping (EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_info", requestParameters: nil) {(result: EosioRpcInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_block_info`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcBlockRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcBlockResponseProtocol` and an optional `EosioError`.
    public func getBlockInfoBase(requestParameters: EosioRpcBlockInfoRequest, completion: @escaping (EosioResult<EosioRpcBlockInfoResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_block_info", requestParameters: requestParameters) {(result: EosioRpcBlockInfoResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_raw_abi`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRawAbiRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcRawAbiResponseProtocol` and an optional `EosioError`.
    public func getRawAbiBase(requestParameters: EosioRpcRawAbiRequest, completion: @escaping (EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_raw_abi", requestParameters: requestParameters) {(result: EosioRpcRawAbiResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/get_required_keys`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcRequiredKeysRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcRequiredKeysResponseProtocol` and an optional `EosioError`.
    public func getRequiredKeysBase(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/get_required_keys", requestParameters: requestParameters) {(result: EosioRpcRequiredKeysResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/push_transaction`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcPushTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcTransactionResponseProtocol` and an optional `EosioError`.
    public func pushTransactionBase(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/push_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }

    /// Call `chain/send_transaction`. This method is called by `EosioTransaction`, as it only enforces the response protocol, not the entire response struct.
    ///
    /// - Parameters:
    ///   - requestParameters: An `EosioRpcSendTransactionRequest`.
    ///   - completion: Called with the response, as an `EosioResult` consisting of a response conforming to `EosioRpcTransactionResponseProtocol` and an optional `EosioError`.
    public func sendTransactionBase(requestParameters: EosioRpcSendTransactionRequest, completion: @escaping (EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void) {
        getResource(rpc: "chain/send_transaction", requestParameters: requestParameters) {(result: EosioRpcTransactionResponse?, error: EosioError?) in
            completion(EosioResult(success: result, failure: error)!)
        }
    }
}
