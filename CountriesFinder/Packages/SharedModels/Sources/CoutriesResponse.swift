//
//  CoutriesResponse.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct Country: Sendable, Identifiable, Equatable, Hashable {
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String = UUID().uuidString

    public let name: CountryName?
    public let capital: [String]?
    public let currency: Currency?
    public let flags: CountryFlag?

    public init(
        name: CountryName?,
        capital: [String]?,
        currency: Currency?,
        flags: CountryFlag?
    ) {
        self.name = name
        self.capital = capital
        self.currency = currency
        self.flags = flags
    }
}

public struct Currency: Sendable, Hashable {
    public let name: String
    public let symbol: String

    public init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
}

public struct CountryName: Sendable, Hashable {
    public let name: String
    public let officialName: String

    public init(
        name: String,
        officialName: String
    ) {
        self.name = name
        self.officialName = officialName
    }
}

public struct CountryFlag: Sendable, Hashable {
    public let png: String

    public init(png: String) {
        self.png = png
    }
}
