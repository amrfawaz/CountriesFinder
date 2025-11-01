//
//  BaseResponse.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct BaseResponse<T: Decodable, E: Decodable>: Decodable {
    public var data: T?
    public var error: E?
}

public struct GDError: Decodable, Sendable {
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }

    public let code: Int
    public let message: String
}
