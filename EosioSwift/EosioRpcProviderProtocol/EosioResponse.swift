//
//  EosioResponse.swift
//  EosioSwift
//
//  Created by Steve McCoole on 2/19/19.
//  Copyright © 2018-2019 block.one.
//

import Foundation

public class EosioResponse {
    public var data: Data?
    public var httpResponse: HTTPURLResponse?

    var string: String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    init(data: Data? = nil, httpResponse: HTTPURLResponse? = nil) {
        self.data = data
        self.httpResponse = httpResponse
    }

    func decodeJson<T: Decodable>() -> T? {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let json = string {
            let jsonKey = CodingUserInfoKey(rawValue: "json")!
            decoder.userInfo[jsonKey] = json
        }

        do {
            let rpcResponse = try decoder.decode(T.self, from: data)
            return rpcResponse
        } catch {
            return nil
        }
    }
}
