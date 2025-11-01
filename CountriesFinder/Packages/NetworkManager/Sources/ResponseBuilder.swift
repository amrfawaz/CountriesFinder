//
//  ResponseBuilder.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

internal struct ResponseBuilder {
    static func response<T: Decodable>(from data: Data?) throws -> T {
        guard let data else {
            throw ResponseBuilderError.responseDataMissing
        }
        
        guard let response = try? JSONDecoder().decode(T.self, from: data) else {
            throw ResponseBuilderError.failedToParse
        }
        
        return response
    }
}
