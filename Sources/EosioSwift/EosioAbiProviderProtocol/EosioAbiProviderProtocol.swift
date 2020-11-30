//
//  EosioAbiProviderProtocol.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/24/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Protocol for fetching and caching ABIs.
public protocol EosioAbiProviderProtocol {

    /// Get all ABIs for the given accounts, keyed by account name.
    ///
    /// - Parameters:
    ///   - chainId: The chain ID.
    ///   - accounts: An array of account names as `EosioName`s.
    ///   - completion: Calls the completion with an `EosioResult` containing a map of ABIs as Data for all of the given accounts, keyed by the account name. An ABI for each account must be
    ///     returned, otherwise an `EosioResult.failure` type will be returned.
    func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName: Data], EosioError>) -> Void)

    /// Get the ABI as `Data` for the specified account name.
    ///
    /// - Parameters:
    ///   - chainId: The chain ID.
    ///   - account: The account name as an `EosioName`.
    ///   - completion: Calls the completion with an `EosioResult` containing the ABI as Data. An `EosioResult.failure` type will be returned if the specified ABI could not be found or
    ///     decoded properly.
    func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data, EosioError>) -> Void)
}
