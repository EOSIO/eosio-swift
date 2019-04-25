//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import PromiseKit

/// Default RPC Provider implementation. Conforms to `EosioRpcProviderProtocol`.
/// RPC Reference: https://developers.eos.io/eosio-nodeos/reference
public class EosioRpcProvider {

    private var endpoints: [URL]
    private let retries: UInt
    private var chainId: String?
    private var currentEndpoint: URL!
    private var currentRpc: String?
    /// Initialize the default RPC Provider implementation with one RPC node endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: A node URL.
    ///   - retries: Number of times to retry an endpoint before failing.
    public init(endpoint: URL, retries: UInt = 5) {
        self.endpoints = [endpoint]
        self.currentEndpoint = self.endpoints[0]
        self.retries = retries
    }

    /// Initialize the default RPC Provider implementation with a list of RPC node endpoints. Extra endpoints will be used for failover purposes.
    /// - Parameters:
    ///   - endpoints: A list of node URLs.
    ///   - retries: Number of times to retry an endpoint before failing over to the next.
    public init(endpoints: [URL], retries: UInt = 5) {
        assert(endpoints.count > 0, "Assertion Failure: The endpoints array cannot be empty.")
        self.endpoints = endpoints
        self.currentEndpoint = self.endpoints[0]
        self.retries = retries
    }

    func retry<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                guard attempts < maximumRetryCount else { throw error }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }

    /// Creates an RPC request, makes the network call, and handles the response returning a Promise.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - rpc: String representing endpoint path. E.g., `chain/get_account`.
    ///   - requestParameters: The request object.
    /// - Returns: A Promise fulfilling with a response object conforming to the `EosioRpcResponseProtocol` and rejecting with an Error.
    func getResource<T: Decodable & EosioRpcResponseProtocol>(_: PMKNamespacer, rpc: String, requestParameters: Encodable?) -> Promise<T> {
        var theError: EosioError?

        var promise: Promise<T>

        /*
         Logic for retry and failover:
         
         1) First call to an endpoint needs to call getInfo to get the chainId which is stored to ensure all calls and all endponts are running the same chain ID.
         2) An endopoint call is retried on failures up to the nuber of tmes specified by the RPCProvider's retries property
         3) After all retirees fail then try the propcess again with a subsequent endpoint.
             a) subsequent enpoints not having the same Chain ID as the first should be discared.
        */

        // If we dont have the chain ID for the host we are hitting we need to get it!
        // TODO: This will need to be enhanced when the next PR for failover is implemented. It needs addional logic when
        // switching to new endpoint when failover to next enpoint occurs.
        if rpc != "chain/get_info" && chainId == nil {
            runRequest(rpc: "chain/get_info", requestParameters: nil)
                .done { (infoResponse: EosioRpcInfoResponse)  in
                self.chainId = infoResponse.chainId
            }.catch { error in
                var eosioError: EosioError
                if let error = error as? EosioError {
                    eosioError = error
                } else {
                    eosioError = EosioError(.rpcProviderError,
                                            reason: "Unable to obtain sourthe Chain Id via getInfo for host: \(String(describing: self.currentEndpoint.host)).",
                        originalError: error as NSError)
                }
                theError = eosioError
            }
        }
        guard let error = theError else {
            promise = retry(maximumRetryCount: 3) {
                self.runRequest(rpc: rpc, requestParameters: requestParameters)
            }

            promise.catch { _ in

            }
            
            return promise
        }
        return Promise(error: error)
    }

    func runRequest<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {
        let backgroundQueue = DispatchQueue.global(qos: .default)
        return buildRequest(rpc: rpc, endpoint: endpoints[0], requestParameters: requestParameters)
            .then (on: backgroundQueue) {
                URLSession.shared.dataTask(.promise, with: $0).validate()
            }.then { (data, _) in
                self.decodeResponse(data: data)
            }
    }

    func buildRequest(rpc: String, endpoint: URL, requestParameters: Encodable?) -> Promise<URLRequest> {
        currentRpc = rpc
        let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestParameters = requestParameters {
            do {
                let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                request.httpBody = jsonData
            } catch {
                let eosioError = EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError)
                return Promise(error: eosioError)
            }
        }
        return Promise.value(request)
    }

    private func decodeResponse<T: Decodable & EosioRpcResponseProtocol>(data: Data) -> Promise<T> {
        let decoder = JSONDecoder()
        do {
            var resource = try decoder.decode(T.self, from: data)
            resource._rawResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Promise.value(resource)
        } catch let error {
            let eosioError = EosioError(.rpcProviderError, reason: "Error occurred in decoding/serializing returned data.", originalError: error as NSError)
            return Promise(error: eosioError)
        }
    }

    /// Creates an RPC request, makes the network call, and handles the response. Calls the callback when complete.
    ///
    /// - Parameters:
    ///   - rpc: String representing endpoint path. E.g., `chain/get_account`.
    ///   - requestParameters: The request object.
    ///   - callback: Callback.
    func getResource<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?, callback: @escaping (T?, EosioError?) -> Void) {
        getResource(.promise, rpc: rpc, requestParameters: requestParameters)
            .done {
                callback($0, nil)
            }.catch { error in
                var eosioError: EosioError
                if let error = error as? EosioError {
                    eosioError = error
                } else {
                    eosioError = EosioError(.rpcProviderError, reason: "Other error.", originalError: error as NSError)
                }
                callback(nil, eosioError)
        }
    }
}

extension NSError {
    func isNetworkConnectionError() -> Bool {
        let networkErrors = [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet]

        if self.domain == NSURLErrorDomain && networkErrors.contains(self.code) {
            return true
        }
        return false
    }
}
