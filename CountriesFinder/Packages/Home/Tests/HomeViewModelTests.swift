//
//  HomeViewModelTests.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import XCTest
import Combine
import SharedModels

@testable import Home

@MainActor
final class HomeViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_title_returnsCorrectTitle() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // When
        let title = sut.title
        
        // Then
        XCTAssertEqual(title, "Country Finder")
    }
    
    // MARK: - Initial State Tests
    
    func test_initialState_isLoadingIsFalse() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        // Then
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_initialState_countriesIsEmpty() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Then
        XCTAssertTrue(sut.countries.isEmpty)
    }
    
    func test_initialState_countriesApiErrorsIsNil() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Then
        XCTAssertNil(sut.countriesApiErrors)
    }
    
    func test_initialState_searchTextIsEmpty() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Then
        XCTAssertEqual(sut.searchText, "")
    }
    
    // MARK: - FetchCountries Success Tests
    
    func test_fetchCountries_whenSuccess_setsCountries() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        let expectedCountries = createMockCountries()
        mockUseCase.searchResult = .success(expectedCountries)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(sut.countries.count, 3)
        XCTAssertEqual(sut.countries[0].name?.name, "Syria")
        XCTAssertEqual(sut.countries[1].name?.name, "France")
        XCTAssertEqual(sut.countries[2].name?.name, "Germany")
    }
    
    func test_fetchCountries_whenSuccess_clearsErrors() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countriesApiErrors = GenericAPIError.genericError(description: "Previous error")
        mockUseCase.searchResult = .success(createMockCountries())
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertNil(sut.countriesApiErrors)
    }
    
    func test_fetchCountries_whenSuccess_setsIsLoadingToFalse() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        mockUseCase.searchResult = .success(createMockCountries())
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_fetchCountries_setsIsLoadingToTrueDuringFetch() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        var cancellables = Set<AnyCancellable>()

        // Given
        mockUseCase.searchResult = .success(createMockCountries())
        mockUseCase.delay = 0.1
        
        var isLoadingStates: [Bool] = []
        
        sut.$isLoading
            .sink { isLoading in
                isLoadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertTrue(isLoadingStates.contains(true), "isLoading should be true during fetch")
        XCTAssertFalse(sut.isLoading, "isLoading should be false after fetch")
    }
    
    func test_fetchCountries_callsUseCaseSearch() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        mockUseCase.searchResult = .success([])
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(mockUseCase.searchCallCount, 1)
    }
    
    func test_fetchCountries_whenEmptyResponse_setsEmptyCountries() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        mockUseCase.searchResult = .success([])
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertTrue(sut.countries.isEmpty)
        XCTAssertNil(sut.countriesApiErrors)
    }
    
    // MARK: - FetchCountries Failure Tests
    
//    func test_fetchCountries_whenFailure_setsError() async {
//        let mockUseCase = MockSearchUseCase()
//        let sut = HomeViewModelImpl(useCase: mockUseCase)
//
//        // Given
//        let expectedError = NSError(
//            domain: "TestError",
//            code: 123,
//            userInfo: [NSLocalizedDescriptionKey: "Network error"]
//        )
//        mockUseCase.searchResult = .failure(expectedError)
//        
//        // When
//        await sut.fetchCountries()
//        
//        // Then
//        XCTAssertNotNil(sut.countriesApiErrors)
//        if case .genericError(let description) = sut.countriesApiErrors {
//            XCTAssertEqual(description, "Network error")
//        } else {
//            XCTFail("Expected genericError")
//        }
//    }
    
    func test_fetchCountries_whenFailure_countriesRemainsEmpty() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        let error = NSError(domain: "TestError", code: 123)
        mockUseCase.searchResult = .failure(error)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertTrue(sut.countries.isEmpty)
    }
    
    func test_fetchCountries_whenFailure_preservesPreviousCountries() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        let initialCountries = createMockCountries()
        sut.countries = initialCountries
        
        let error = NSError(domain: "TestError", code: 123)
        mockUseCase.searchResult = .failure(error)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertEqual(sut.countries.count, 3)
    }
    
    func test_fetchCountries_whenNetworkError_setsAppropriateError() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        enum NetworkError: Error {
            case timeout
        }
        mockUseCase.searchResult = .failure(NetworkError.timeout)
        
        // When
        await sut.fetchCountries()
        
        // Then
        XCTAssertNotNil(sut.countriesApiErrors)
    }
    
    // MARK: - FilteredCountries Tests
    
    func test_filteredCountries_whenSearchTextIsEmpty_returnsAllCountries() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countries = createMockCountries()
        sut.searchText = ""
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertEqual(filtered.count, 3)
    }
    
    func test_filteredCountries_whenSearchTextMatches_returnsMatchingCountries() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countries = createMockCountries()
        sut.searchText = "Syria"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered[0].name?.name, "Syria")
    }
    
    func test_filteredCountries_whenSearchTextMatchesPartial_returnsMatchingCountries() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countries = createMockCountries()
        sut.searchText = "Fran"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered[0].name?.name, "France")
    }
    
    func test_filteredCountries_isCaseInsensitive() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countries = createMockCountries()
        sut.searchText = "SYRIA"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered[0].name?.name, "Syria")
    }
    
    func test_filteredCountries_whenNoMatch_returnsEmptyArray() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        sut.countries = createMockCountries()
        sut.searchText = "NonExistentCountry"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertTrue(filtered.isEmpty)
    }
    
    func test_filteredCountries_whenCountryNameIsNil_handlesGracefully() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        let countryWithoutName = Country(name: nil, capital: nil, currency: nil, flags: nil)
        sut.countries = [countryWithoutName]
        sut.searchText = "Test"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertTrue(filtered.isEmpty)
    }
    
    func test_filteredCountries_withMultipleMatches_returnsAllMatches() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)

        // Given
        let countries = [
            createCountry(name: "Germany", officialName: "Federal Republic of Germany"),
            createCountry(name: "German Democratic Republic", officialName: "East Germany"),
            createCountry(name: "France", officialName: "French Republic")
        ]
        sut.countries = countries
        sut.searchText = "German"
        
        // When
        let filtered = sut.filteredCountries
        
        // Then
        XCTAssertEqual(filtered.count, 2)
    }

    // MARK: - Published Properties Tests
    
    func test_countries_isPublished() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        var cancellables = Set<AnyCancellable>()

        // Given
        let expectation = expectation(description: "Countries published")
        var receivedCountries: [[Country]] = []
        
        sut.$countries
            .dropFirst() // Skip initial empty value
            .sink { countries in
                receivedCountries.append(countries)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        mockUseCase.searchResult = .success(createMockCountries())
        
        // When
        await sut.fetchCountries()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedCountries.last?.count, 3)
    }
    
    func test_searchText_isPublished() {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        var cancellables = Set<AnyCancellable>()

        // Given
        let expectation = expectation(description: "SearchText published")
        var receivedSearchTexts: [String] = []
        
        sut.$searchText
            .dropFirst() // Skip initial empty value
            .sink { searchText in
                receivedSearchTexts.append(searchText)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.searchText = "Test"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedSearchTexts.last, "Test")
    }
    
    func test_isLoading_isPublished() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        var cancellables = Set<AnyCancellable>()

        // Given
        let expectation = expectation(description: "IsLoading published")
        expectation.expectedFulfillmentCount = 2 // true then false
        var receivedStates: [Bool] = []
        
        sut.$isLoading
            .dropFirst() // Skip initial false
            .sink { isLoading in
                receivedStates.append(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        mockUseCase.searchResult = .success([])
        mockUseCase.delay = 0.05
        
        // When
        await sut.fetchCountries()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertTrue(receivedStates.contains(true))
        XCTAssertTrue(receivedStates.contains(false))
    }
    
    // MARK: - Integration Tests
    
    func test_fullFlow_searchAndFilter() async {
        let mockUseCase = MockSearchUseCase()
        let sut = HomeViewModelImpl(useCase: mockUseCase)
        var cancellables = Set<AnyCancellable>()

        // Given
        mockUseCase.searchResult = .success(createMockCountries())
        
        // When - Fetch countries
        await sut.fetchCountries()
        
        // Then - All countries loaded
        XCTAssertEqual(sut.countries.count, 3)
        XCTAssertEqual(sut.filteredCountries.count, 3)
        
        // When - Search for specific country
        sut.searchText = "France"
        
        // Then - Only matching country shown
        XCTAssertEqual(sut.filteredCountries.count, 1)
        XCTAssertEqual(sut.filteredCountries[0].name?.name, "France")
        
        // When - Clear search
        sut.searchText = ""
        
        // Then - All countries shown again
        XCTAssertEqual(sut.filteredCountries.count, 3)
    }
    
    // MARK: - Helper Methods
    
    private func createMockCountries() -> [Country] {
        return [
            createCountry(name: "Syria", officialName: "Syrian Arab Republic"),
            createCountry(name: "France", officialName: "French Republic"),
            createCountry(name: "Germany", officialName: "Federal Republic of Germany")
        ]
    }
    
    private func createCountry(
        name: String,
        officialName: String,
        capital: [String]? = nil,
        currency: Currency? = nil,
        flags: CountryFlag? = nil
    ) -> Country {
        let countryName = CountryName(name: name, officialName: officialName)
        return Country(
            name: countryName,
            capital: capital,
            currency: currency,
            flags: flags
        )
    }
    
}
