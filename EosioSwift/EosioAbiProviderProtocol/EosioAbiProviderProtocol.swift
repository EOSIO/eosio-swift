//
//  EosioAbiProviderProtocol.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/24/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation


public protocol EosioAbiProviderProtocol {
    
    /**
    Return a map of Abis as Data for all of the given accounts, keyed by the account name. An Abi for each account must be returned, otherwise an EosioResult.failure type will be returned.
    */
    func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName:Data],EosioError>) -> Void)
    
    
    /**
    Return the Abi as Data for the specified account name. An EosioResult.failure type will be returned if the specified Abi could not be found or decoded properly.
    */
    func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data,EosioError>) -> Void)
    
}
