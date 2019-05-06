//
//  EosioResult.swift
//  EosioSwift
//
//  Created by Steve McCoole on 1/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// Provides typed results in closure returns so that there won't be any `nil` return states to test for.
///
/// - success: The success return state.
/// - failure: The failure return state.
public enum EosioResult<Success, Failure: Error> {
    /// The success return state.
    case success(Success)
    /// The failure return state.
    case failure(Failure)

    init?(success: Success?, failure: Failure?) {
        if let success = success {
            self = .success(success)
        } else if let failure = failure {
            self = .failure(failure)
        } else {
            return nil
        }
    }
}
