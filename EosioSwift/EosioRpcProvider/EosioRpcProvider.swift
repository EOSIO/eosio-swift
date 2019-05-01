//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Ben Martell on 4/22/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation
import PromiseKit

/// Default RPC Provider implementation. Conforms to `EosioRpcProviderProtocol`.
/// RPC Reference: https://developers.eos.io/eosio-nodeos/reference
public class EosioRpcProvider {

    //
    public var chainId: String?
    public var originalChainId: String?
    private var origEndpoints: [URL]
    private let retries: Int
    private let dispatchTimeInterval: DispatchTimeInterval
    private var currentEndpoint: URL?
    private var endPointQueue = Queue<URL>()

    /// Initialize the default RPC Provider implementation with one RPC node endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: A node URL.
    ///   - retries: Number of times to retry an endpoint before failing (default is 3 tries).
    ///   - delayBeforeRetry: Number of seconds to wait between each retry (default is 1 second).
    public convenience init(endpoint: URL, retries: Int = 3, delayBeforeRetry: Int = 1) {
        self.init(endpoints: [endpoint], retries: retries, delayBeforeRetry: delayBeforeRetry)
    }

    /// Initialize the default RPC Provider implementation with a list of RPC node endpoints. Extra endpoints will be used for failover purposes.
    /// - Parameters:
    ///   - endpoints: A list of node URLs.
    ///   - retries: Number of times to retry an endpoint before failing over to the next (default is 3 tries).
    ///   - delayBeforeRetry: Number of seconds to wait between each retry (default is 1 second).
    public init(endpoints: [URL], retries: Int = 3, delayBeforeRetry: Int = 1) {
        assert(endpoints.count > 0, "Assertion Failure: The endpoints array cannot be empty.")
        self.origEndpoints = endpoints
        self.retries = retries
        self.dispatchTimeInterval = .seconds(delayBeforeRetry)
        setUp()
    }

    private func setUp() {
        for url in origEndpoints {
            endPointQueue.enqueue(url)
        }
        self.currentEndpoint = endPointQueue.dequeue()
    }

    private func retry<T>(maximumRetryCount: Int = 1, _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                // We only want to retry for when we get the proper code from server!
                guard (attempts < maximumRetryCount) && self.isRetryable(error: error) else {
                    if error is EosioError {
                        throw error
                    } else {
                        throw EosioError(.rpcProviderError, reason: error.localizedDescription, originalError: error as NSError)
                    }
                }
                return after(self.dispatchTimeInterval).then(on: nil, attempt)
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

    private func canErrorFailOverToNewEndpoint(error: Error) -> Bool {

        // any endpoints to try?
        guard let newEndpoint = self.endPointQueue.dequeue() else {
           return false
        }

        currentEndpoint = newEndpoint

        if isRetryable(error: error) {
            // Reset these for the failover retries. Will force a get and compare of new endpoint chainId.
            self.originalChainId = self.chainId
            self.chainId = nil
            return true
        } else {
            return false
        }
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
                discarded and the next tried if one is available.  Otherwise, bubble up the failure.
        */

       return processRequest(rpc: rpc, requestParameters: requestParameters)
    }

    // A helper func that is used so failover can recurse the request to new endpoints as needed.
    private func processRequest<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {

        // This promise var is used for the return of Promise<T> expected in this function.
        var promise: Promise<T>
        if self.chainId == nil {

            // Need to capture the chain id to ensure all function calls
            // to a given endpoint are running the same block chain!
            promise = captureChainId()

            promise.catch { error in
                promise = Promise(error: error)
            }

            if rpc == "chain/get_info" {
                // Return the getInfo result since that was the original call desired that triggered this func.
                return promise
            } else {
                // Return the correct result for the rpc needed.
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

                    if self.chainId == nil && self.originalChainId == nil {
                        self.chainId = resp.chainId
                    } else {
                        if let validChainId = self.originalChainId,
                                validChainId == resp.chainId {
                            //new endpoint chain id matches orignimal endpoint chain id
                            self.chainId = resp.chainId
                        } else {
                            let error = EosioError(.rpcProviderError, reason: "New endpoint chain ID does not match previous endpoint chain ID.")
                            return Promise(error: error)
                        }
                    }
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

            if self.canErrorFailOverToNewEndpoint(error: error) {
                // Recursion starts here.
                promise = self.processRequest(rpc: rpc, requestParameters: requestParameters)
            } else {
                 promise = Promise(error: error)
            }
        }
        return promise
    }

    private func runRequest<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {

        guard let endpoint = currentEndpoint else {
            let error = EosioError(.rpcProviderError, reason: "No current endpoint is set.")
            return Promise(error: error)
        }

        return buildRequest(rpc: rpc, endpoint: endpoint, requestParameters: requestParameters)
            .then {
                URLSession.shared.dataTask(.promise, with: $0).validate()
            }.then { (data, _) in
                self.decodeResponse(data: data)
            }
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
