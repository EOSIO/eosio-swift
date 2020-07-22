//
//  EosioRpcProvider.swift
//  EosioSwift
//
//  Created by Ben Martell on 4/22/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation
import PromiseKit

/// Default RPC Provider implementation. Conforms to `EosioRpcProviderProtocol`.
/// RPC Reference: https://developers.eos.io/eosio-nodeos/reference
public class EosioRpcProvider {

    private let getInfoRpc = "chain/get_info"
    // How to handle error conditions for retry / failover.
    private enum NextAction {
        case returnError
        case retry
        case failover
        case retryOnceThenFailover
    }

    /// The blockchain ID that all RPC calls for an active instance of EosioRpcProvider should be interacting with.
    public var chainId: String?
    private var originalChainId: String?
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
        setUpEndPoints()
    }

    private func setUpEndPoints() {
        for url in origEndpoints {
            endPointQueue.enqueue(url)
        }
        self.currentEndpoint = endPointQueue.dequeue()
    }

    // This is based on the retry/polling pattern found at:
    // https://github.com/mxcl/PromiseKit/blob/master/Documentation/CommonPatterns.md#retry--polling
    //
    // The 'body' here refers to a promise func that is wrapped by this retry promise.
    // The inner attempt() func is dispatched for every promise try.
    // Usage of this func will look like:
    //  retry {
    //        someFunc() -> Promise<T>
    //  }
    //
    private func retry<T>(_ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                // We only want to retry for specific errors!
                guard (attempts < self.retries) && self.isRetryable(error: error, tries: attempts) else {
                    throw error
                }
                return after(self.dispatchTimeInterval).then(on: nil, attempt)
            }
        }
        return attempt()
    }

    private func isRetryable(error: Error, tries: Int) -> Bool {
        let nextAction = nextActionFor(error: error)
        if nextAction == .retry || (nextAction == .retryOnceThenFailover && tries == 1 ) {
            return true
        } else {
            return false
        }
    }

    private func nextActionFor(error: Error) -> NextAction {
        if let theError = error as? PMKHTTPError {
            switch theError {
            case .badStatusCode(let code, _, _) :
                if code == 500 ||
                    code == 401 ||
                    code == 418 {
                    return NextAction.returnError
                } else {
                    return NextAction.retry
                }
            }
        } else if let theError = error as? EosioError {
            if theError.errorCode == .rpcProviderFatalError {
                return NextAction.returnError
            } else {
                return NextAction.failover
            }
        } else {
           return handleNSError(error: (error as NSError))
        }
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable cyclomatic_complexity
    private func handleNSError(error: NSError) -> NextAction {
        switch error.code {
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            return NextAction.returnError
        case NSURLErrorBackgroundSessionInUseByAnotherProcess:
            return NextAction.returnError
        case NSURLErrorBadServerResponse:
            return NextAction.failover
        case NSURLErrorBadURL:
            return NextAction.returnError
        case NSURLErrorCallIsActive:
            return NextAction.returnError
        case NSURLErrorCannotConnectToHost:
            return NextAction.retry
        case NSURLErrorCannotDecodeContentData:
            return NextAction.failover
        case NSURLErrorCannotDecodeRawData:
            return NextAction.failover
        case NSURLErrorCannotFindHost:
            return NextAction.retry
        case NSURLErrorCannotParseResponse:
            return NextAction.failover
        case NSURLErrorClientCertificateRejected:
            return NextAction.failover
        case NSURLErrorClientCertificateRequired:
            return NextAction.failover
        case NSURLErrorDNSLookupFailed:
            return NextAction.retry
        case NSURLErrorDataLengthExceedsMaximum:
            return NextAction.failover
        case NSURLErrorDataNotAllowed:
            return NextAction.returnError
        case NSURLErrorHTTPTooManyRedirects:
            return NextAction.failover
        case NSURLErrorInternationalRoamingOff:
             return NextAction.returnError
        case NSURLErrorNetworkConnectionLost:
            return NextAction.retry
        case NSURLErrorNotConnectedToInternet:
            return NextAction.returnError
        case NSURLErrorRedirectToNonExistentLocation:
            return NextAction.failover
        case NSURLErrorRequestBodyStreamExhausted:
            return NextAction.returnError
        case NSURLErrorResourceUnavailable:
            return NextAction.failover
        case NSURLErrorSecureConnectionFailed:
            return NextAction.failover
        case NSURLErrorServerCertificateHasBadDate:
            return NextAction.failover
        case NSURLErrorServerCertificateHasUnknownRoot:
            return NextAction.failover
        case NSURLErrorServerCertificateNotYetValid:
            return NextAction.failover
        case NSURLErrorServerCertificateUntrusted:
            return NextAction.failover
        case NSURLErrorTimedOut:
            return NextAction.retry
        case NSURLErrorUnknown:
            return NextAction.returnError
        case NSURLErrorUnsupportedURL:
            return NextAction.returnError
        case NSURLErrorUserAuthenticationRequired:
            return NextAction.failover
        case NSURLErrorUserCancelledAuthentication:
            return NextAction.returnError
        case NSURLErrorZeroByteResource:
            return NextAction.failover
        default:
            return NextAction.returnError
        }
    }
    // swiftlint:enable function_body_length
    // swiftlint:enable cyclomatic_complexity

    private func canErrorFailOverToNewEndpoint(error: Error) -> Bool {

        let errorAction = nextActionFor(error: error)

        if errorAction == NextAction.returnError {
            return false
        }

        // Any endpoints to try?
        guard let newEndpoint = self.endPointQueue.dequeue() else {
           // All endpoints have been exhausted.
           // Set endpoint to original one so the RPC provider instance is not DOA for subsequent calls.
            self.currentEndpoint = self.origEndpoints[0]
            return false
        }

        // Set up for failover run. Will force a get and compare of new endpoint's chainId.
        self.currentEndpoint = newEndpoint
        self.originalChainId = self.chainId
        self.chainId = nil
        return true
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
         
         1) First call to an endpoint needs to call getInfo to get the blockchain ID which is stored to ensure all
            calls and all endpoints are running on the same blockchain.

         2) An endpoint call is retried on failures up to the number of times specified by the RPCProvider's
         retries property.  Retry only occurs for specific failures. E.g., no network connection
            is an error that will bubble up so the calling app can deal with it. See nextActionFor(error: Error) -> NextAction.

         3) Failover. After all retries fail then try the process again with a subsequent endpoint.
             a) Subsequent endpoints not having the same blockchain ID as the first should be
                discarded and the next tried if one is available. Otherwise, bubble up the failure.
             b) Certain failures are considered fatal and will not failover to a new endpoint. E.g., no network connection, etc.
                See nextActionFor(error: Error) -> NextAction.
        */

        return runWithFailover {
            self.processRequest(rpc: rpc, requestParameters: requestParameters)
        }
    }

    // This is based on the retry/polling pattern found at:
    // https://github.com/mxcl/PromiseKit/blob/master/Documentation/CommonPatterns.md#retry--polling
    //
    // The 'body' here refers to a promise func that is wrapped by this runWithFailover promise.
    // The inner failover() func is dispatched for every promise try.
    // Usage of this func will look like:
    //  runWithFailover {
    //        someFunc() -> Promise<T>
    //  }
    //
    // This particular implementation is typing the return promise to a Decodable & EosioRpcResponseProtocol object.
    private func runWithFailover<T: Decodable & EosioRpcResponseProtocol>(_ body: @escaping () -> Promise<T>) -> Promise<T> {
        func failOver() -> Promise<T> {
            return body().recover { error -> Promise<T> in
                // See if we can failover this error to a new endpoint!
                guard self.canErrorFailOverToNewEndpoint(error: error) else {
                    throw EosioError(.rpcProviderError, reason: error.localizedDescription, originalError: error as NSError)
                }
                return failOver()
            }
        }
        return after(seconds: 0).then(on: nil, failOver)
    }

    private func processRequest<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {

        // This promise var is used for the return of Promise<T> expected in this function.
        var promise: Promise<T>
        promise = captureChainId(rpc: rpc).then { (response: EosioRpcInfoResponse) -> Promise<T> in
            if rpc == self.getInfoRpc, let resp = response as? T {
                return Promise.value(resp)
            } else {
                return self.runRequestWithRetry(rpc: rpc, requestParameters: requestParameters)
            }
        }
        return promise
    }

    private func captureChainId(rpc: String) -> Promise<EosioRpcInfoResponse> {
        var promise: Promise<EosioRpcInfoResponse>

        if rpc != self.getInfoRpc && self.chainId != nil {
            // Need to return a dummy response object there to satisfy the promise expectation.
            let response = EosioRpcInfoResponse(chainId: "", headBlockNum: EosioUInt64.uint64(0),
                                                lastIrreversibleBlockNum: EosioUInt64.uint64(0),
                                                lastIrreversibleBlockId: "", headBlockId: "", headBlockTime: "")
            return Promise.value(response)
        }

        promise = runRequestWithRetry(rpc: self.getInfoRpc, requestParameters: nil)

        return promise.then { (response: EosioRpcInfoResponse) -> Promise<EosioRpcInfoResponse>  in
            if self.chainId == nil && self.originalChainId == nil {
                // Very first setting of chainId
                self.chainId = response.chainId
                self.originalChainId = response.chainId
                return Promise.value(response)
            } else if self.chainId == nil {
                if self.originalChainId == response.chainId {
                    // This check would occur if failover is happening.
                    // The new endpoint blockchain ID matches the original blockchain ID for previous valid endpoints running the same blockchain.
                    self.chainId = response.chainId
                    return Promise.value(response)
                } else {
                    let error = EosioError(.rpcProviderChainIdError, reason: "New endpoint chain ID does not match previous endpoint chain ID.")
                    return Promise(error: error)
                }
            }
            return Promise.value(response)
        }
    }

    private func runRequestWithRetry<T: Decodable & EosioRpcResponseProtocol>(rpc: String, requestParameters: Encodable?) -> Promise<T> {

        return retry {
            self.runRequest(rpc: rpc, requestParameters: requestParameters)
        }
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
            } catch let error {
                let eosioError = EosioError(.rpcProviderFatalError, reason: "Error while encoding request parameters.", originalError: error as NSError)
                return Promise(error: eosioError)
            }
        }
        return Promise.value(request)
    }

    private func decodeResponse<T: Decodable & EosioRpcResponseProtocol>(data: Data) -> Promise<T> {
        let errorReasonPrefix = "Error occurred in decoding/serializing returned data."
        let decoder = JSONDecoder()
        do {
            var resource = try decoder.decode(T.self, from: data)
            resource._rawResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return Promise.value(resource)
        } catch DecodingError.dataCorrupted(let context) {
            let errorReason = "\(errorReasonPrefix) DataCorrupted: \(context.debugDescription)."
            return makeFatalEosioErrorPromiseError(reason: errorReason)
        } catch DecodingError.keyNotFound(let key, let context) {
            let errorReason = "\(errorReasonPrefix) KeyNotFound: \(key.stringValue) \(context.debugDescription)."
            return makeFatalEosioErrorPromiseError(reason: errorReason)
        } catch DecodingError.typeMismatch(let type, let context) {
            let errorReason = "\(errorReasonPrefix) TypeMismatch: \(type) was expected, \(context.debugDescription)."
            return makeFatalEosioErrorPromiseError(reason: errorReason)
        } catch DecodingError.valueNotFound(let type, let context) {
            let errorReason = "\(errorReasonPrefix) ValueNotFound: no value was found for \(type), \(context.debugDescription)."
            return makeFatalEosioErrorPromiseError(reason: errorReason)
        } catch let error {
            return makeFatalEosioErrorPromiseError(reason: errorReasonPrefix, originialError: error as NSError)
        }
    }

    private func makeFatalEosioErrorPromiseError<T>(reason: String, originialError: NSError? = nil) -> Promise<T> {
        let error = EosioError(.rpcProviderFatalError, reason: reason, originalError: originialError)
        return Promise(error: error)

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
