//
//  BaseRequest.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct BaseRequest: Sendable {
    public var body: (any Encodable & Sendable)?
    public var headers: [String: String]

    public init(
        body: (any Encodable & Sendable)? = nil,
        headers: [String: String] = [:]
    ) {
        self.body = body
        self.headers = headers
    }
}
