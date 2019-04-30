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

    public var chainId = ""
    private var endpoints: [URL]
    private let retries: UInt
    private var currentEndpoint: URL!

    /// Initialize the default RPC Provider implementation with one RPC node endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: A node URL.
    ///   - retries: Number of times to retry an endpoint before failing.
    public init(endpoint: URL, retries: UInt = 1) {
        self.endpoints = [endpoint]
        self.currentEndpoint = self.endpoints[0]
        self.retries = retries
    }

    /// Initialize the default RPC Provider implementation with a list of RPC node endpoints. Extra endpoints will be used for failover purposes.
    /// - Parameters:
    ///   - endpoints: A list of node URLs.
    ///   - retries: Number of times to retry an endpoint before failing over to the next.
    public init(endpoints: [URL], retries: UInt = 1) {
        assert(endpoints.count > 0, "Assertion Failure: The endpoints array cannot be empty.")
        self.endpoints = endpoints
        self.currentEndpoint = self.endpoints[0]
        self.retries = retries
    }

    private func retry<T>(maximumRetryCount: Int = 1, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                // We only want to retry for when we get the proper bad status code from server!
                guard (attempts < maximumRetryCount) && self.isRetryable(error: error) else {
                    if error is EosioError {
                        throw error
                    } else {
                        throw EosioError(.rpcProviderError, reason: error.localizedDescription, originalError: error as NSError)
                    }
                }
                return after(delayBeforeRetry).then(on: nil, attempt)
            }
        }
        return attempt()
    }

    private func isRetryable(error: Error) -> Bool {
        var retVal = false
        if let theError = error as? PMKHTTPError {
            switch theError {
            case .badStatusCode(let code, _, _) :
                if code == 500 ||
                    code == 401 ||
                    code == 418 {
                    retVal = false
                } else {
                    retVal = true
                }
            }
        }
        return retVal
    }

    /// Creates an RPC request, makes the network call, and handles the response returning a Promise.
    ///
    /// - Parameters:
    ///   - _: Differentiates call signature from that of non-promise-returning endpoint method. Pass in `.promise` as the first parameter to call this method.
    ///   - rpc: String representing endpoint path. E.g., `chain/get_account`.
    ///   - requestParameters: The request object.
    /// - Returns: A Promise fulfilling with a response object conforming to the `EosioRpcResponseProtocol` and rejecting with an Error.
    func getResource<T: Decodable & EosioRpcResponseProtocol>(_: PMKNamespacer, rpc: String, requestParameters: Encodable?) -> Promise<T> {

        /*
         Logic for retry and failover implementation:
         
         1) First call to an endpoint needs to call getInfo to get the chainId which is stored to ensure all
            calls and all endpoints are running the same chain ID.

         2) An endpoint call is retried on failures up to the number of times specified by the RPCProvider's
            retries property.  Failures are only retried for bad HTTP response status!  No network connection
            is an error that will bubble up so the calling app can deal with it.

         3) Failover. After all retries fail then try the process again with a subsequent endpoint.
             a) Subsequent enpoints not having the same Chain ID as the first should be
                discarded and the next tried if one is availble.  Otherwise, bubble up the failure.
        */

        var promise: Promise<T>
        if self.chainId.isEmpty {
            promise = captureChainId()

            promise.catch { error in
                promise = Promise(error: error)
            }

            if rpc == "chain/get_info" {
                return promise
            } else {
                promise = runRequestWithRetry(rpc: rpc, requestParameters: requestParameters)
            }

        } else {
            promise = runRequestWithRetry(rpc: rpc, requestParameters: requestParameters)
        }
        return promise
    }

    private func captureChainId<T: Decodable & EosioRpcResponseProtocol>() -> Promise<T> {
        return runRequestWithRetry(rpc: "chain/get_info", requestParameters: nil)
            .then { (response: T) -> Promise<T>  in
                if let resp = response as? EosioRpcInfoResponse {
                    self.chainId = resp.chainId
                }
                return Promise.value(response)
            }
    }

    private func runRequestWithRetry<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {
        var promise: Promise<T>
        promise = retry(maximumRetryCount: Int(self.retries)) {
            self.runRequest(rpc: rpc, requestParameters: requestParameters)
        }

        promise.catch { error in
            if error is PMKHTTPError {
                promise = self.failOver(rpc: rpc, requestParameters: requestParameters)
            } else {
                promise = Promise(error: error)
            }
        }
        return promise
    }

    private func runRequest<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {
        return buildRequest(rpc: rpc, endpoint: endpoints[0], requestParameters: requestParameters)
            .then {
                URLSession.shared.dataTask(.promise, with: $0).validate()
            }.then { (data, _) in
                self.decodeResponse(data: data)
            }
    }

    private func failOver<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {

        //TODO: add failOver logic here!
        return Promise(error: EosioError(.rpcProviderError, reason: "Failover not implemented int his PR."))
    }

    private func buildRequest(rpc: String, endpoint: URL, requestParameters: Encodable?) -> Promise<URLRequest> {
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
