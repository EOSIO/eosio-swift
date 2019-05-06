//
//  RpcProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

// Protocol defining the endpoints required by the core EOSIO SDK for Swift library.
public protocol EosioRpcProviderProtocol {

    /// Calls /v1/chain/get_info.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getInfo(completion: @escaping(EosioResult<EosioRpcInfoResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_block.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping(EosioResult<EosioRpcBlockResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_raw_abi.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawAbiResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/get_required_keys.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeysResponseProtocol, EosioError>) -> Void)

    /// Calls /v1/chain/push_transaction.
    ///
    /// - Parameter completion: Completion called with an `EosioResult`.
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponseProtocol, EosioError>) -> Void)

}
