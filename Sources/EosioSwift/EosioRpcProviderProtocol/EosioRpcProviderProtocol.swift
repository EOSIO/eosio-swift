//
//  RpcProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

// Protocol defining the endpoints required by the core EOSIO SDK for Swift library.

// This protocol is intended to define/enforce the minimum functionality and response
// information that is required by the internals of the EOSIO SDK for Swift library,
// not for a generic interface to multiple RPC provider impelementations by outside
// code. Therefore, they append 'Base' to the function names to separate them from the full
// response signature implementations that are provided by concrete RPC provider
// implementations.

// Previous versions of Swift did not flag the over lap between the signatures that
// return the protocol conforming response from the concrete response but starting
// with Swift 5.3 these types of conditions are now flagged by the compiler as
// ambiguious references, so the protocol has change to address this.

public protocol EosioRpcProviderProtocol {

    /// Calls /v1/chain/get_info.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getInfoBase(completion: @escaping(EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_block_info.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getBlockInfoBase(requestParameters: EosioRpcBlockInfoRequest, completion: @escaping(EosioResult<EosioRpcBlockInfoResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_block.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getBlockBase(requestParameters: EosioRpcBlockRequest, completion: @escaping (EosioResult<EosioRpcBlockResponse, EosioError>) -> Void)

    /// Calls /v1/chain/get_raw_abi.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getRawAbiBase(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_required_keys.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getRequiredKeysBase(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/push_transaction.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func pushTransactionBase(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/push_transaction.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func sendTransactionBase(requestParameters: EosioRpcSendTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void)

}
