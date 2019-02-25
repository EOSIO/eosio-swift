//
//  EosRpcProviderMockImpl.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/21/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import EosioSwiftFoundation

public class EosioRpcProviderMockImpl: EosioRpcProviderProtocol {
    public var endpoints: [EosioEndpoint]
    
    public var failoverRetries: Int
    
    private var currentEndpoint: EosioEndpoint
    
    public var primaryEndpoint: EosioEndpoint {
        get {
            return currentEndpoint
        }
    }
    
    public required init(endpoints: [EosioEndpoint], failoverRetries: Int) {
        self.endpoints = endpoints
        self.failoverRetries = failoverRetries
        self.currentEndpoint = endpoints[0]
    }
    
    public func rpcRequest(request: EosioRequest, completion: @escaping (EosioResult<EosioResponse>) -> Void) {
        // For now all calls to rpcRequest will return a failure
        completion(EosioResult.error(EosioError(EosioErrorCode.networkError, reason: "Mock Implementation: rpcRequest not implemented.")))
    }
    
    public func getInfo(completion: @escaping (EosioResult<EosioRpcInfo>) -> Void) {
        let resp = createInfoResponse()
        completion(resp.decodeJson())
    }
    
    public func getBlock(blockNum: UInt64, completion: @escaping (EosioResult<EosioRpcBlock>) -> Void) {
        let resp = createBlockResponse()
        completion(resp.decodeJson())
    }
    
    public func getBlockHeaderState(blockNum: UInt64, completion: @escaping (EosioResult<EosioRpcBlockHeaderState>) -> Void) {
        
    }
    
    public func getBlockHeaderState(blockId: String, completion: @escaping (EosioResult<EosioRpcBlockHeaderState>) -> Void) {
        
    }
    
    public func getAccount(account: EosioName, completion: @escaping (EosioResult<EosioRpcAccount>) -> Void) {
        
    }
    
    public func getRawAbi(account: EosioName, completion: @escaping (EosioResult<EosioRpcRawAbi>) -> Void) {
        let resp = createRawAbiResponse()
        completion(resp.decodeJson())
    }
    
    public func getRawCodeAndAbi(account: EosioName, completion: @escaping (EosioResult<EosioRpcRawCodeAbi>) -> Void) {
        
    }
    
    public func getTableRows(parameters: EosioRpcTableRowsRequest, completion: @escaping (EosioResult<EosioRpcTableRows>) -> Void) {
        
    }
    
    public func getRequiredKeys(parameters: EosioRpcRequiredKeysRequest, completion: @escaping (EosioResult<EosioRpcRequiredKeys>) -> Void) {
        
    }
    
    public func getCurrencyStats(code: String, symbol: String, completion: @escaping (EosioResult<EosioRpcCurrencyStats>) -> Void) {
        
    }
    
    public func getProducers(parameters: EosioRpcProducersRequest, completion: @escaping (EosioResult<EosioRpcProducers>) -> Void) {
        
    }
    
    public func pushTransaction(transaction: EosioTransaction, completion: @escaping (EosioResult<EosioRpcTransaction>) -> Void) {
        
    }
    
    public func pushTransactions(transactions: [EosioTransaction], completion: @escaping ([EosioResult<EosioRpcTransaction>]) -> Void) {
        
    }
    
    public func getHistoryActions(parameters: EosioRpcHistoryActionsRequest, completion: @escaping (EosioResult<EosioRpcHistoryActions>) -> Void) {
        
    }
    
    public func getHistoryTransaction(transactionId: String, completion: @escaping (EosioResult<EosioRpcTransaction>) -> Void) {
        
    }
    
    public func getHistoryKeyAccounts(publicKey: String, completion: @escaping (EosioResult<EosioRpcKeyAccounts>) -> Void) {
        
    }
    
    public func getHistoryControlledAccounts(controllingAccount: EosioName, completion: @escaping (EosioResult<EosioRpcControllingAccounts>) -> Void) {
        
    }
    
    private func createInfoResponse() -> EosioResponse {
        let json = """
        {
            "server_version": "0f6695cb",
            "chain_id": "687fa513e18843ad3e820744f4ffcf93b1354036d80737db8dc444fe4b15ad17",
            "head_block_num": 25260035,
            "last_irreversible_block_num": 25259987,
            "last_irreversible_block_id": "01816fd3f7f35fd7d60c72b522772541fad71ce310c5f5cd434c41a17d2ad3b8",
            "head_block_id": "01817003aecb618966706f2bca7e8525d814e873b5db9a95c57ad248d10d3c05",
            "head_block_time": "2019-02-21T18:31:41.500",
            "head_block_producer": "blkproducer2",
            "virtual_block_cpu_limit": 200000000,
            "virtual_block_net_limit": 1048576000,
            "block_cpu_limit": 199900,
            "block_net_limit": 1048576,
            "server_version_string": "v1.3.0"
        }
        """
        return responseFromJson(json: json)
    }
    
    private func createBlockResponse() -> EosioResponse {
        let json = """
            {
                "timestamp": "2019-02-21T18:31:40.000",
                "producer": "blkproducer2",
                "confirmed": 0,
                "previous": "01816fffa4548475add3c45d0e0620f59468a6817426137b37851c23ccafa9cc",
                "transaction_mroot": "0000000000000000000000000000000000000000000000000000000000000000",
                "action_mroot": "de5493939e3abdca80deeab2fc9389cc43dc1982708653cfe6b225eb788d6659",
                "schedule_version": 3,
                "new_producers": null,
                "header_extensions": [],
                "producer_signature": "SIG_K1_KZ3ptku7orAgcyMzd9FKW4jPC9PvjW9BGadFoyxdJFWM44VZdjW28DJgDe6wkNHAxnpqCWSzaBHB1AfbXBUn3HDzetemoA",
                "transactions": [],
                "block_extensions": [],
                "id": "0181700002e623f2bf291b86a10a5cec4caab4954d4231f31f050f4f86f26116",
                "block_num": 25260032,
                "ref_block_prefix": 2249927103
            }
        """
       return responseFromJson(json: json)
    }
    
    private func createRawAbiResponse() -> EosioResponse {
        let json = """
            {
                "account_name": "eosio.token",
                "code_hash": "3e0cf4172ab025f9fff5f1db11ee8a34d44779492e1d668ae1dc2d129e865348",
                "abi_hash": "43864d5af0fe294d44d19c612036cbe8c098414c4a12a5a7bb0bfe7db1556248",
                "abi": "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXK8By0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly9jZG4udGVzdG5ldC5kZXYuYjFvcHMubmV0L3Rva2VuLXRyYW5zZmVyLnBuZyNjZTUxZWY5ZjllZWNhMzQzNGU4NTUwN2UwZWQ0OWU3NmZmZjEyNjU0MjJiZGVkMDI1NWYzMTk2ZWE1OWM4YjBjCi0tLQoKIyMgVHJhbnNmZXIgVGVybXMgJiBDb25kaXRpb25zCgpJLCB7e2Zyb219fSwgY2VydGlmeSB0aGUgZm9sbG93aW5nIHRvIGJlIHRydWUgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlOgoKMS4gSSBjZXJ0aWZ5IHRoYXQge3txdWFudGl0eX19IGlzIG5vdCB0aGUgcHJvY2VlZHMgb2YgZnJhdWR1bGVudCBvciB2aW9sZW50IGFjdGl2aXRpZXMuCjIuIEkgY2VydGlmeSB0aGF0LCB0byB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UsIHt7dG99fSBpcyBub3Qgc3VwcG9ydGluZyBpbml0aWF0aW9uIG9mIHZpb2xlbmNlIGFnYWluc3Qgb3RoZXJzLgozLiBJIGhhdmUgZGlzY2xvc2VkIGFueSBjb250cmFjdHVhbCB0ZXJtcyAmIGNvbmRpdGlvbnMgd2l0aCByZXNwZWN0IHRvIHt7cXVhbnRpdHl9fSB0byB7e3RvfX0uCgpJIHVuZGVyc3RhbmQgdGhhdCBmdW5kcyB0cmFuc2ZlcnMgYXJlIG5vdCByZXZlcnNpYmxlIGFmdGVyIHRoZSB7eyR0cmFuc2FjdGlvbi5kZWxheV9zZWN9fSBzZWNvbmRzIG9yIG90aGVyIGRlbGF5IGFzIGNvbmZpZ3VyZWQgYnkge3tmcm9tfX0ncyBwZXJtaXNzaW9ucy4KCklmIHRoaXMgYWN0aW9uIGZhaWxzIHRvIGJlIGlycmV2ZXJzaWJseSBjb25maXJtZWQgYWZ0ZXIgcmVjZWl2aW5nIGdvb2RzIG9yIHNlcnZpY2VzIGZyb20gJ3t7dG99fScsIEkgYWdyZWUgdG8gZWl0aGVyIHJldHVybiB0aGUgZ29vZHMgb3Igc2VydmljZXMgb3IgcmVzZW5kIHt7cXVhbnRpdHl9fSBpbiBhIHRpbWVseSBtYW5uZXIuAAAAAAClMXYFaXNzdWUAAAAAAKhs1EUGY3JlYXRlAAIAAAA4T00RMgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQHYWNjb3VudAAAAAAAkE3GA2k2NAEIY3VycmVuY3kBBnVpbnQ2NA5jdXJyZW5jeV9zdGF0cwAAAAA=="
            }
        """
        return responseFromJson(json: json)
    }
    
    private func responseFromJson(json: String) -> EosioResponse {
        let response = EosioResponse(data: json.data(using: .utf8), statusCode: 200, httpResponse: nil)
        return response
    }
}
