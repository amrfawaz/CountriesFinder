//
//  HomeDIContainer.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import SwiftUI
import SharedModels

public struct HomeContainer: View {
    private let dependencies: DependencyContainer
    
    public init(dependencies: DependencyContainer? = nil) {
        self.dependencies = dependencies ?? DependencyContainer()
    }
    
    public var body: some View {
        NavigationContainer(
            coordinator: HomeCoordinator(dependencies: dependencies)
        )
    }
}
