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

    static func responseArray<T: Decodable>(from data: Data?) throws -> [T] {
        guard let data else {
            throw ResponseBuilderError.responseDataMissing
        }
        
        guard let response = try? JSONDecoder().decode([T].self, from: data) else {
            throw ResponseBuilderError.failedToParse
        }
        
        return response
    }
}


struct CountryDTO: Decodable {
    let name: CountryNameDTO?
    let capital: [String]?
//    let currencies: [String: [String: String]]?
    let flags: CountryFlagDTO?

    init(
        name: CountryNameDTO?,
        capital: [String]?,
//        currencies: [String : [String : String]]?,
        flags: CountryFlagDTO
    ) {
        self.name = name
        self.capital = capital
//        self.currencies = currencies
        self.flags = flags
    }
}




struct CountryNameDTO: Decodable {
    let name: String?
    let officialName: String?

    enum CodingKeys: String, CodingKey {
        case name = "common"
        case officialName = "official"
    }
}

struct CountryFlagDTO: Decodable {
    let png: String?

}
