//
//  Coordinator.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import SwiftUI
import Foundation

@MainActor
public protocol Coordinator: ObservableObject {
    associatedtype Page: Hashable & Identifiable
    
    var navigationPath: NavigationPath { get set }
    var presentedSheet: Page? { get set }
    var presentedFullScreenCover: Page? { get set }
    var startPage: Page { get }
    
    func navigate(to page: Page)
    func present(sheet page: Page)
    func present(fullScreenCover page: Page)
    func dismissSheet()
    func dismissFullScreenCover()
    func popToRoot()
    func pop()
    
    func view(for page: Page) -> AnyView
}

public extension Coordinator {
    func navigate(to page: Page) {
        navigationPath.append(page)
    }
    
    func present(sheet page: Page) {
        presentedSheet = page
    }
    
    func present(fullScreenCover page: Page) {
        presentedFullScreenCover = page
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func pop() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
}
