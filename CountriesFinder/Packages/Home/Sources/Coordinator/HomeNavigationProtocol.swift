//
//  HomeNavigationProtocol.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import SharedModels

@MainActor
public protocol HomeNavigationProtocol {
    func showCountryDetail(_ country: Country)
}
