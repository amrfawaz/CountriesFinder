//
//  NavigationContainer.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import SwiftUI

public struct NavigationContainer<C: Coordinator>: View {
    @StateObject private var coordinator: C

    public init(coordinator: @autoclosure @escaping () -> C) {
        self._coordinator = StateObject(wrappedValue: coordinator())
    }

    public var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.view(for: coordinator.startPage)
                .navigationDestination(for: C.Page.self) { page in
                    coordinator.view(for: page)
                }
        }
        .sheet(item: $coordinator.presentedSheet) { page in
            NavigationStack {
                coordinator.view(for: page)
            }
        }
        .fullScreenCover(item: $coordinator.presentedFullScreenCover) { page in
            NavigationStack {
                coordinator.view(for: page)
            }
        }
        .environmentObject(coordinator)
    }
}
