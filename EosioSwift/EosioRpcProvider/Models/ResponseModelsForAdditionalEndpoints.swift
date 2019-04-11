//
//  ResponseModelsForAdditionalEndpoints.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/11/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

public struct RawResponseBase: Codable, EosioRpcResponseProtocol {
    public var _rawResponse: Any?

    enum CodingKeys: CodingKey {
    }
}

public typealias EosioRpcAccountResponse = RawResponseBase
public typealias EosioRpcCurrencyBalanceResponse = RawResponseBase
public typealias EosioRpcCurrencyStatsResponse = RawResponseBase
public typealias EosioRpcRawCodeAndAbiResponse = RawResponseBase
public typealias EosioRpcCodeResponse = RawResponseBase
public typealias EosioRpcTableRowsResponse = RawResponseBase
public typealias EosioRpcTableByScopeResponse = RawResponseBase
public typealias EosioRpcProducersResponse = RawResponseBase
public typealias EosioRpcControlledAccountsResponse = RawResponseBase
public typealias EosioRpcGetTransactionResponse = RawResponseBase
public typealias EosioRpcKeyAccountsResponse = RawResponseBase
public typealias EosioRpcActionsResponse = RawResponseBase
