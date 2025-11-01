//
//  API.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public protocol API {
    var fullURL: String? {get}
    var endPoint: String? {get}
    var path: String? {get}
    var method: HTTPMethod {get}
    var customHeaders: [String: String]? {get}
    var parameters: Encodable? {get}
    
    func getAllHeaders(defaultHeaders: [String: String]) -> [String: String]
    func getFullURL(baseURL: String) throws -> String?
}

public extension API {
    func getAllHeaders(defaultHeaders: [String: String]) -> [String: String] {
        var headers: [String: String] = defaultHeaders
        
        if let customHeaders = customHeaders {
            headers.merge(customHeaders) { (_, new) in new }
        }
        
        return headers
    }

    func getFullURL(baseURL: String) throws -> String? {
        if let fullURL {
            return fullURL
        }
        if let path, let endPoint {
            return baseURL + path + endPoint
        }
        throw RequestBuilderError.invalidURL
    }
}

