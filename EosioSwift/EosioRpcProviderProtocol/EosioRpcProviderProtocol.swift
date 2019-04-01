//
//  RpcProviderProtocol.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public protocol EosioRpcProviderProtocol {
    
    
    
    /** Calls /v1/chain/get_info */
    func getInfo(completion: @escaping(EosioResult<EosioRpcInfoResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/get_block` */
    func getBlock(requestParameters: EosioRpcBlockRequest, completion: @escaping(EosioResult<EosioRpcBlockResponse, EosioError>) -> Void)

    /** Calls `/v1/chain/get_raw_abi` */
    func getRawAbi(requestParameters: EosioRpcRawAbiRequest, completion: @escaping(EosioResult<EosioRpcRawAbiResponse, EosioError>) -> Void)

    /** Calls `/v1/chain/get_required_keys` */
    func getRequiredKeys(requestParameters: EosioRpcRequiredKeysRequest, completion: @escaping(EosioResult<EosioRpcRequiredKeysResponse, EosioError>) -> Void)
    
    /** Calls `/v1/chain/push_transaction` */
    func pushTransaction(requestParameters: EosioRpcPushTransactionRequest, completion: @escaping(EosioResult<EosioRpcTransactionResponse, EosioError>) -> Void)
    
}



