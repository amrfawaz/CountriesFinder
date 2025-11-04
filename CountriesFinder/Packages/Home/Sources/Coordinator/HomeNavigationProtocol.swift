//
//  HomeNavigationProtocol.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation

@MainActor
public protocol HomeNavigationProtocol {
    func showCountryDetail(_ countryId: Int)
}
