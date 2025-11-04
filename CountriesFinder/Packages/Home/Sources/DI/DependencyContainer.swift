//
//  DependencyContainer.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import SharedModels
import NetworkManager
//import HeroDetails

@MainActor
public final class DependencyContainer {
    // Home dependencies
//    public let heroesRepository: HeroesRepositoryImpl
    public let searchUseCase: SearchUseCaseUseCaseImpl

    // Hero Details dependencies
//    public let heroDetailsRepository: HeroDetailsRepositoryImpl
//    public let heroDetailsUseCase: HeroDetailsUseCase

    public init() {
        // Initialize Home dependencies
        self.searchUseCase = SearchUseCaseUseCaseImpl(networkLayer: NetworkLayerImpl(networkManager: NetworkManagerImp.sharedInstance()))
//        self.heroesUseCase = HeroesUseCase(repository: heroesRepository)
        
        // Initialize Hero Details dependencies
//        self.heroDetailsRepository = HeroDetailsRepositoryImpl(api: HeroDetailsAPI())
//        self.heroDetailsUseCase = HeroDetailsUseCase(repository: heroDetailsRepository)
    }

    public func makeHomeViewModel() -> HomeViewModelImpl {
        HomeViewModelImpl(useCase: searchUseCase)
    }

//    public func makeHeroDetailsViewModel(heroId: Int) -> HeroDetailsViewModel {
//        HeroDetailsViewModel(heroId: heroId, heroDetailsUseCase: heroDetailsUseCase)
//    }
}
