//
//  EosioAbiProviderTests.swift
//  EosioSwiftTests
//
//  Created by Todd Bowden on 2/25/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation
import XCTest
import EosioSwift

class EosioAbiProviderTests: XCTestCase {

    var rpcProvider: EosioRpcProviderProtocol {
        let endpoint = EosioEndpoint("mock://endpoint")
        return EosioRpcProviderMockImpl(endpoints: [endpoint!], failoverRetries: 3)
    }

    func testGetAbi() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider)
        do {
            let eosioToken = try EosioName("eosio.token")
            abiProvider.getAbi(chainId: "", account: eosioToken, completion: { (response) in
                switch response {
                case .success(let abi):
                    XCTAssertEqual(abi.sha256.hex, "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                case .failure(let error):
                    print(error)
                    XCTFail("Failed to get Abi from provider")
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

    func testGetAbis() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider)
        do {
            let eosioToken = try EosioName("eosio.token")
            let eosio = try EosioName("eosio")
            abiProvider.getAbis(chainId: "", accounts: [eosioToken, eosio, eosioToken], completion: { (response) in
                switch response {
                case .success(let abi):
                    XCTAssertEqual(abi[eosioToken]?.sha256.hex, "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248")
                    XCTAssertEqual(abi[eosio]?.sha256.hex, "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
                case .failure(let error):
                    print(error)
                    XCTFail("Failed to get Abi from provider")
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

    func testGetAbisBadAccount() {
        let abiProvider = EosioAbiProvider(rpcProvider: rpcProvider)
        do {
            let eosioToken = try EosioName("eosio.token")
            let eosio = try EosioName("eosio")
            let badAccount = try EosioName("bad.acount")
            abiProvider.getAbis(chainId: "", accounts: [badAccount, eosioToken, eosio], completion: { (response) in
                switch response {
                case .success:
                    XCTFail("getting Abi from provider succeeded despite being wrong")
                case .failure(let error):
                    print(error)
                }
            })
        } catch {
            XCTFail("\(error)")
        }

    }

}
