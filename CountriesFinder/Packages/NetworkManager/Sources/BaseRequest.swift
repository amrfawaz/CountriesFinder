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

    private var isSecured: Bool

    public init(
        isSecured: Bool = false,
        body: (any Encodable & Sendable)? = nil,
        headers: [String: String] = [:]
    ) {
        self.isSecured = isSecured
        self.body = body
        self.headers = headers

        if isSecured {
            guard let accessToken = KeychainManager[.accessToken] else {
                return
//                fatalError("Access token is not set")
            }
            self.headers = ["Authorization": "Bearer " + accessToken]
        }
    }
}
