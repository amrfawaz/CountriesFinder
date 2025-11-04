//
//  HomeViewModel.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import SharedModels
import Combine

@MainActor
public protocol HomeViewModel: ObservableObject {
    var title: String { get }
    var countries: [Country] { get set }
    var isLoading: Bool { get set }
    var countriesApiErrors: GenericAPIError? { get set }
    var filteredCountries: [Country] { get }
    var searchText: String { get set }
    
    func fetchCountries() async
}


public final class HomeViewModelImpl: HomeViewModel {
    @Published public var isLoading: Bool = false
    @Published public var countries: [Country] = []
    @Published public var countriesApiErrors: GenericAPIError?
    @Published public var searchText: String = ""

    private let useCase: SearchUseCase

    public init(useCase: SearchUseCase) {
        self.useCase = useCase
    }

    public var title: String {
        "Country Finder"
    }

    public var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { country in
                (country.name?.name ?? "")
                    .localizedCaseInsensitiveContains(searchText)
            }
        }

    }

    public func fetchCountries() async {
        do {
            isLoading = true
            let response = try await useCase.search()
            isLoading = false

            countriesApiErrors = nil
            countries = response
//            coordinator.push(
//                .otp(
//                    mobile: userPhoneNumber,
//                    countryPrefix: prefix,
//                    verificationType: .forgetPassword,
//                    token: token
//                )
//            )

        } catch {
            countriesApiErrors = GenericAPIError.genericError(description: error.localizedDescription)
        }
    }
    

}
