//
//  EosioEndpoint.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public class EosioEndpoint {
    private(set) var endPoint: String
    private(set) var configuration: URLSessionConfiguration = URLSessionConfiguration.default

    public var baseUrl: URL? {
        return URL(string: endPoint)
    }

    public init?(_ endPoint: String, configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.endPoint = endPoint
        self.configuration = configuration
        guard let _ = URL(string: endPoint) else { return nil }
    }
}
