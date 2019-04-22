//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Farid Rahmani on 4/1/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

/// Default RPC Provider implementation. Conforms to `EosioRpcProviderProtocol`.
/// RPC Reference: https://developers.eos.io/eosio-nodeos/reference
public class EosioRpcProvider {

    private var endpoints: [URL]
    private let retries: UInt
    private var chainId: String?
    private var currentEndpoint: URL?

    /// Initialize the default RPC Provider implementation with one RPC node endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: A node URL.
    ///   - retries: Number of times to retry an endpoint before failing.
    public init(endpoint: URL, retries: UInt = 5) {
        self.endpoints = [endpoint]
        self.retries = retries
    }

    /// Initialize the default RPC Provider implementation with a list of RPC node endpoints. Extra endpoints will be used for failover purposes.
    /// - Parameters:
    ///   - endpoints: A list of node URLs.
    ///   - retries: Number of times to retry an endpoint before failing over to the next.
    public init(endpoints: [URL], retries: UInt = 5) {
        assert(endpoints.count > 0, "Assertion Failure: The endpoints array cannot be empty.")
        self.endpoints = endpoints
        self.retries = retries
    }

    private func switchToNextEndpointAndTryAgain<ResponseType: Decodable & EosioRpcResponseProtocol>(
        rpc: String,
        requestParameters: Encodable?,
        callBack: @escaping (ResponseType?, EosioError?) -> Void
    ) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                callBack(nil, EosioError(.unexpectedError, reason: "self does not exist", originalError: nil))
                return
            }
            var exitLoop = false
            var lastReturnedError: EosioError?

            for endpoint in self.endpoints {
                let group = DispatchGroup()
                group.enter()

                self.getResource(
                    rpc: "chain/get_info",
                    requestParameters: nil,
                    shouldSwitchEndpoints: false,
                    usingEndpoint: endpoint,
                    callBack: { (response: EosioRpcInfoResponse?, error: EosioError?) in
                        if let response = response {
                            if let chainId = self.chainId, chainId != response.chainId {
                                if let indexOfEndpoint = self.endpoints.index(of: endpoint) {
                                   self.endpoints.remove(at: indexOfEndpoint)
                                }
                            } else {
                                self.chainId = response.chainId
                                self.currentEndpoint = endpoint
                                self.getResource(rpc: rpc, requestParameters: requestParameters, callBack: callBack)
                                exitLoop = true
                            }

                            group.leave()
                            return
                        }

                        if let error = error {
                            if let originalError = error.originalError, originalError.isNetworkConnectionError() {
                                exitLoop = true
                                callBack(nil, error)
                            }

                            lastReturnedError = error
                        }

                        group.leave()
                    }
                )

                group.wait()

                if exitLoop {
                    return
                }
            }
            // If we reach here all endpoints are busy/down
            callBack(nil, lastReturnedError)
        }
    }

    func getResource<T: Decodable & EosioRpcResponseProtocol>(
        rpc: String,
        requestParameters: Encodable?,
        shouldSwitchEndpoints: Bool = true,
        usingEndpoint: URL? = nil,
        callBack: @escaping (T?, EosioError?) -> Void
    ) {
        let endPointToUse = usingEndpoint ?? currentEndpoint
        guard let endpoint = endPointToUse else {
            switchToNextEndpointAndTryAgain(rpc: rpc, requestParameters: requestParameters, callBack: callBack)
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                callBack(nil, EosioError(.unexpectedError, reason: "self does not exist", originalError: nil))
                return
            }
            let url = URL(string: "v1/" + rpc, relativeTo: endpoint)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if let requestParameters = requestParameters {
                do {
                    let jsonData = try requestParameters.toJsonData(convertToSnakeCase: true)
                    request.httpBody = jsonData
                } catch {
                    callBack(nil, EosioError(.rpcProviderError, reason: "Error while encoding request parameters.", originalError: error as NSError))
                    return
                }
            }
            var exitLoop = false
            for i in 0..<self.retries {
                print("Trying \(rpc)")
                let group = DispatchGroup()
                group.enter()
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        if (self.retries - 1) == i {
                           callBack(nil, EosioError(.rpcProviderError, reason: "Network error.", originalError: error as NSError))
                        }
                        group.leave()
                        return
                    }
                    exitLoop = true
                    group.leave()
                    guard let httpResponse = response as? HTTPURLResponse else {
                        if shouldSwitchEndpoints {
                            self.switchToNextEndpointAndTryAgain(rpc: rpc, requestParameters: requestParameters, callBack: callBack)
                        } else {
                            callBack(nil, EosioError(.rpcProviderError, reason: "Server didn't respond.", originalError: nil))
                        }
                        return
                    }
                    guard (200...299).contains(httpResponse.statusCode) else {
                        if (502...504).contains(httpResponse.statusCode) && shouldSwitchEndpoints {
                            self.switchToNextEndpointAndTryAgain(rpc: rpc, requestParameters: requestParameters, callBack: callBack)
                        } else {
                            let reason = "Status Code: \(httpResponse.statusCode) Server Response: \(String(data: data ?? Data(), encoding: .utf8) ?? "nil")"
                            callBack(nil, EosioError(.rpcProviderError, reason: reason, originalError: nil))
                        }
                        return
                    }
                    if let data = data {
                        let decoder = JSONDecoder()
                        do {
                            var resource = try decoder.decode(T.self, from: data)
                            resource._rawResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            callBack(resource, nil)
                        } catch let error {
                            callBack(nil, EosioError(.unexpectedError, reason: "Error occurred in decoding/serializing returned data.", originalError: error as NSError))
                        }
                    }
                }
                task.resume()
                group.wait()

                if exitLoop {
                    break
                }
            }
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
