//
//  DependencyContainer.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import SharedModels
import NetworkManager
import CountryDetails

@MainActor
public final class DependencyContainer {
    // Home dependencies
    public let searchUseCase: SearchUseCaseUseCaseImpl

    public init() {
        // Initialize Home dependencies
        self.searchUseCase = SearchUseCaseUseCaseImpl(networkLayer: NetworkLayerImpl(networkManager: NetworkManagerImp.sharedInstance()))
    }

    public func makeHomeViewModel() -> HomeViewModelImpl {
        HomeViewModelImpl(useCase: searchUseCase)
    }

    public func makeCountryDetailsViewModel(country: Country) -> CountryDetailsViewModelImpl {
        CountryDetailsViewModelImpl(country: country)
    }
}
