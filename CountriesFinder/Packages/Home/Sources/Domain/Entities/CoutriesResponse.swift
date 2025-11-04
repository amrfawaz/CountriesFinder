//
//  CoutriesResponse.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

public struct Country: Sendable, Identifiable {
    public let id: String = UUID().uuidString
    let name: CountryName?
    let capital: [String]?
//    let currencies: [String: [String: String]]?
    let flags: CountryFlag?

    public init(
        name: CountryName?,
        capital: [String]?,
//        currencies: [String: [String: String]]?,
        flags: CountryFlag?
    ) {
        self.name = name
        self.capital = capital
//        self.currencies = currencies
        self.flags = flags
    }
}

public struct CountryName: Sendable {
    let name: String?
    let officialName: String?

    public init(
        name: String?,
        officialName: String?
    ) {
        self.name = name
        self.officialName = officialName
    }
}

public struct CountryFlag: Sendable {
    let png: String?

    public init(png: String?) {
        self.png = png
    }
}
