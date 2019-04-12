//
//  ResponseModelsForAdditionalEndpoints.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/11/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct RawResponse: Codable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    enum CodingKeys: CodingKey {
    }
}

public typealias EosioRpcAccountResponse = RawResponse
public typealias EosioRpcCurrencyBalanceResponse = RawResponse
public typealias EosioRpcCurrencyStatsResponse = RawResponse
public typealias EosioRpcRawCodeAndAbiResponse = RawResponse
public typealias EosioRpcCodeResponse = RawResponse
public typealias EosioRpcTableRowsResponse = RawResponse
public typealias EosioRpcTableByScopeResponse = RawResponse
public typealias EosioRpcProducersResponse = RawResponse
public typealias EosioRpcControlledAccountsResponse = RawResponse
public typealias EosioRpcGetTransactionResponse = RawResponse
public typealias EosioRpcKeyAccountsResponse = RawResponse
public typealias EosioRpcActionsResponse = RawResponse
public typealias EosioRpcPushTransactionsResponse = RawResponse
public typealias EosioRpcBlockHeaderStateResponse = RawResponse
public typealias EosioRpcAbiResponse = RawResponse
