//
//  CountryDetailsViewModel.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import Foundation
import SharedModels

@MainActor
public protocol CountryDetailsViewModel: ObservableObject {
    var country: Country { get set }
    var name: String { get }
    var currency: String { get }
    var capital: String { get }
    var flag: String { get }
}


public final class CountryDetailsViewModelImpl: CountryDetailsViewModel {
    public var country: Country

    public init(country: Country) {
        self.country = country
    }

    public var name: String {
        self.country.name?.officialName ?? "Country Name"
    }
    public var currency: String {
        "\(self.country.currency?.name ?? ""), \(self.country.currency?.symbol ?? "")"
    }
    public var capital: String {
        self.country.capital?.first ?? "Capital City"
    }

    public var flag: String {
        self.country.flags?.png ?? ""
    }
}
