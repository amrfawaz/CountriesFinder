//
//  CountriesFinderApp.swift
//  CountriesFinder
//
//  Created by Amr Fawaz on 01/11/2025.
//

import SwiftUI
import Home
import NetworkManager

@main
struct CountriesFinderApp: App {

    init() {
        NetworkManagerImp.sharedInstance().setConfigurations(NetworkConfigurationsImp(
            baseURL: "https://restcountries.com"
        ))

    }
    var body: some Scene {
        WindowGroup {
            HomeContainer()
        }
    }
}



final public class NetworkConfigurationsImp: NetworkConfigurations {
    public var timeoutInterval: TimeInterval = 60
    public var session: URLSession = .shared
    public var baseURL: String
    
    public init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    public func getDefaultHeaders() async -> [String: String] {
        [:]
    }
}
