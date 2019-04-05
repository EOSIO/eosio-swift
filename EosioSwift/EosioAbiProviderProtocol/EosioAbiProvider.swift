//
//  EosioAbiProvider.swift
//  EosioSwift
//
//  Created by Todd Bowden on 2/24/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation


public class EosioAbiProvider: EosioAbiProviderProtocol {
    
    private let rpcProvider: EosioRpcProviderProtocol
    private var abis = [String:Data]()
    private let lock = String()
    
    public init(rpcProvider: EosioRpcProviderProtocol) {
        self.rpcProvider = rpcProvider
    }
    
    private func getCachedAbi(chainId: String, account: EosioName) -> Data? {
        return abis[chainId + account.string]
    }
    
    private func cacheAbi(_ abi: Data,  chainId: String, account: EosioName)  {
        objc_sync_enter(self.lock)
        abis[chainId + account.string] = abi
        objc_sync_exit(self.lock)
    }
    
    /**
    Return a map of Abis as Data for all of the given accounts, keyed by the account name. An Abi for each account must be returned, otherwise an EosioResult.failure type will be returned.
    */
    public func getAbis(chainId: String, accounts: [EosioName], completion: @escaping (EosioResult<[EosioName:Data], EosioError>) -> Void) {
        let accounts = Array(Set(accounts)) // remove any duplicate account names
        var responseAbis = [EosioName:Data]()
        var optionalError: EosioError? = nil
        let dispatchGroup = DispatchGroup()

        for account in accounts {
            dispatchGroup.enter()
            getAbi(chainId: chainId, account: account) { (response) in
                switch response {
                case .success(let abi):
                    responseAbis[account] = abi
                    dispatchGroup.leave()
                case .failure(let error):
                    if optionalError == nil { optionalError = error }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let validError = optionalError {
                completion(.failure(validError))
            } else {
                completion(.success(responseAbis))
            }
        }
    }
    
    
    /**
    Return the Abi as Data for the specified account name. An EosioResult.failure type will be returned if the specified Abi could not be found or decoded properly.
    */
    public func getAbi(chainId: String, account: EosioName, completion: @escaping (EosioResult<Data, EosioError>) -> Void) {
        if let abi = getCachedAbi(chainId: chainId, account: account) {
            return completion(.success(abi))
        }
        
        let requestParameters = EosioRpcRawAbiRequest(account_name: account)
        rpcProvider.getRawAbi(requestParameters: requestParameters) { (response) in
            switch response {
            case .success(let abiResponse):
                do {
                    let abi = try Data(base64: abiResponse.abi)
                    let computedHash = abi.sha256.hex.lowercased()
                    let declaredHash = abiResponse.abiHash.lowercased()
                    guard computedHash == declaredHash else {
                        let errorReason = "Computed hash of abi for \(account) \(computedHash) does not match declared hash \(declaredHash)"
                        return completion(.failure(EosioError(.getRawAbiError, reason: errorReason)))
                    }
                    guard account.string == abiResponse.accountName else {
                        let errorReason = "Requested account \(account) does not match declared account \(abiResponse.accountName)"
                        return completion(.failure(EosioError(.getRawAbiError, reason: errorReason)))
                    }
                    self.cacheAbi(abi, chainId: chainId, account: account)
                    return completion(.success(abi))
                    
                } catch {
                    completion(.failure(error.eosioError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
