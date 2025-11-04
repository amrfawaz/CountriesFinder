//
//  CountryDTO.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import NetworkManager
import SharedModels

struct CountryDTO: Decodable {
    let name: CountryNameDTO?
    let capital: [String]?
    let currencies: [String: CurrencyDTO]?
    let flags: CountryFlagDTO?

    init(
        name: CountryNameDTO?,
        capital: [String]?,
        currencies: [String: CurrencyDTO]?,
        flags: CountryFlagDTO
    ) {
        self.name = name
        self.capital = capital
        self.currencies = currencies
        self.flags = flags
    }
}

extension CountryDTO {
    func toDomain() -> Country {
        return Country(
            name: self.name?.toDomain(),
            capital: self.capital,
            currency: self.currencies?.values.first?.toDomain(),
            flags: self.flags?.toDomain()
        )
    }
}


struct CurrencyDTO: Decodable {
    var name: String?
    var symbol: String?

    func toDomain() -> Currency {
        Currency(
            name: self.name ?? "",
            symbol: self.symbol ?? ""
        )
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

extension CountryNameDTO {
    func toDomain() -> CountryName {
        return CountryName(
            name: self.name ?? "",
            officialName: self.officialName ?? ""
        )
    }
}

struct CountryFlagDTO: Decodable {
    let png: String?

    func toDomain() -> CountryFlag {
        return CountryFlag(png: self.png ?? "")
    }
}
