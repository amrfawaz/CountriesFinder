//
//  HomeCoordinator.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import SwiftUI
import SharedModels
//import HeroDetails

@MainActor
public final class HomeCoordinator: Coordinator, HomeNavigationProtocol {
    @Published public var navigationPath = NavigationPath()
    @Published public var presentedSheet: HomePage?
    @Published public var presentedFullScreenCover: HomePage?
    
    private let dependencies: DependencyContainer
    public let homeViewModel: HomeViewModelImpl
    
    public init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
        self.homeViewModel = dependencies.makeHomeViewModel()
    }
    
    public var startPage: HomePage {
        .homeView
    }
}

// MARK: - Pages
extension HomeCoordinator {
    public enum HomePage: Hashable, Identifiable {
        case homeView
//        case countryDetail(heroId: Int)
        
        public var id: String {
            switch self {
            case .homeView: return "homeView"
//            case .countryDetail(let countryId): return "countryDetail\(countryId)"
            }
        }
    }
}

// MARK: - HeroesNavigationProtocol Implementation
extension HomeCoordinator {
    public func showCountryDetail(_ countryId: Int) {
    }
}

// MARK: - View Factory
extension HomeCoordinator {
    public func view(for page: HomePage) -> AnyView {
        switch page {
        case .homeView:
            return AnyView(
                HomeView(viewModel: homeViewModel, navigator: self)
            )
//            
//        case .heroDetail(let heroId):
//            return AnyView(
//                HeroDetailsView(
//                    viewModel: dependencies.makeHeroDetailsViewModel(heroId: heroId)
//                )
//            )
        }
    }
}
