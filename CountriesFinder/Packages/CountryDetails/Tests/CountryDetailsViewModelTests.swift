//
//  CountryDetailsViewModelTests.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import XCTest
import SharedModels

@testable import CountryDetails

@MainActor
final class CountryDetailsViewModelTests: XCTestCase {

    var sut: CountryDetailsViewModelImpl!
    override func setUp() {
        super.setUp()
    }
    
//    @MainActor
//    override func tearDown() {
////        sut = nil
//        super.tearDown()
//    }
    
    func test_name_whenOfficialNameExists_returnsOfficialName() async throws {
        // Given
        let countryName = CountryName(name: "Syria", officialName: "Syrian Arab Republic")
        let country = createCountry(name: countryName)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let name = sut.name
        
        // Then
        XCTAssertEqual(name, "Syrian Arab Republic")
    }
    
    func test_name_whenNameIsNil_returnsDefaultValue() {
        // Given
        let country = createCountry(name: nil)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let name = sut.name
        
        // Then
        XCTAssertEqual(name, "Country Name")
    }
    
    // MARK: - Currency Tests
    
    func test_currency_whenCurrencyExists_returnsCurrencyNameAndSymbol() async throws {
        // Given
        let currency = Currency(name: "Syrian pound", symbol: "£")
        let country = createCountry(currency: currency)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let currencyString = sut.currency
        
        // Then
        XCTAssertEqual(currencyString, "Syrian pound, £")
    }
    
    func test_currency_whenCurrencyIsNil_returnsDefaultValue() {
        // Given
        let country = createCountry(currency: nil)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let currencyString = sut.currency
        
        // Then
        XCTAssertEqual(currencyString, ", ")
    }
    
    func test_currency_withDifferentCurrency_returnsCorrectFormat() async throws {
        // Given
        let currency = Currency(name: "US Dollar", symbol: "$")
        let country = createCountry(currency: currency)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let currencyString = sut.currency
        
        // Then
        XCTAssertEqual(currencyString, "US Dollar, $")
    }
    
    func test_currency_withEuroSymbol_returnsCorrectFormat() {
        // Given
        let currency = Currency(name: "Euro", symbol: "€")
        let country = createCountry(currency: currency)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let currencyString = sut.currency
        
        // Then
        XCTAssertEqual(currencyString, "Euro, €")
    }
    
    // MARK: - Capital Tests
    
    func test_capital_whenCapitalExists_returnsFirstCapital() async throws {
        // Given
        let country = createCountry(capital: ["Damascus", "Aleppo"])
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let capital = sut.capital
        
        // Then
        XCTAssertEqual(capital, "Damascus")
    }
    
    func test_capital_whenSingleCapital_returnsCapital() async throws {
        // Given
        let country = createCountry(capital: ["Paris"])
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let capital = sut.capital
        
        // Then
        XCTAssertEqual(capital, "Paris")
    }
    
    func test_capital_whenCapitalIsEmpty_returnsDefaultValue() async throws {
        // Given
        let country = createCountry(capital: [])
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let capital = sut.capital
        
        // Then
        XCTAssertEqual(capital, "Capital City")
    }
    
    func test_capital_whenCapitalIsNil_returnsDefaultValue() async throws {
        // Given
        let country = createCountry(capital: nil)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let capital = sut.capital
        
        // Then
        XCTAssertEqual(capital, "Capital City")
    }
    
    // MARK: - Flag Tests
    
    func test_flag_whenFlagExists_returnsFlagURL() async throws {
        // Given
        let flags = CountryFlag(png: "https://example.com/flag.png")
        let country = createCountry(flags: flags)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let flag = sut.flag
        
        // Then
        XCTAssertEqual(flag, "https://example.com/flag.png")
    }
    
    func test_flag_whenFlagIsNil_returnsEmptyString() async throws {
        // Given
        let country = createCountry(flags: nil)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let flag = sut.flag
        
        // Then
        XCTAssertEqual(flag, "")
    }
    
    func test_flag_withDifferentURL_returnsCorrectURL() async throws {
        // Given
        let flags = CountryFlag(png: "https://flagcdn.com/w320/sy.png")
        let country = createCountry(flags: flags)
        sut = CountryDetailsViewModelImpl(country: country)
        
        // When
        let flag = sut.flag
        
        // Then
        XCTAssertEqual(flag, "https://flagcdn.com/w320/sy.png")
    }
    
    // MARK: - Country Property Tests
    
    func test_country_canBeUpdated() async throws {
        // Given
        let initialName = CountryName(name: "Initial", officialName: "Initial Country")
        let initialCountry = createCountry(name: initialName)
        sut = CountryDetailsViewModelImpl(country: initialCountry)
        
        // When
        let newName = CountryName(name: "Updated", officialName: "Updated Country")
        let newCountry = createCountry(name: newName)
        sut.country = newCountry
        
        // Then
        XCTAssertEqual(sut.name, "Updated Country")
    }
    
    func test_country_allPropertiesWorkTogether() async throws {
        // Given
        let name = CountryName(name: "France", officialName: "French Republic")
        let currency = Currency(name: "Euro", symbol: "€")
        let capital = ["Paris"]
        let flags = CountryFlag(png: "https://flagcdn.com/w320/fr.png")
        
        let country = createCountry(
            name: name,
            capital: capital,
            currency: currency,
            flags: flags
        )
        sut = CountryDetailsViewModelImpl(country: country)
        
        // Then
        XCTAssertEqual(sut.name, "French Republic")
        XCTAssertEqual(sut.currency, "Euro, €")
        XCTAssertEqual(sut.capital, "Paris")
        XCTAssertEqual(sut.flag, "https://flagcdn.com/w320/fr.png")
    }
    
    // MARK: - Helper Methods
    
    private func createCountry(
        name: CountryName? = nil,
        capital: [String]? = ["Test Capital"],
        currency: Currency? = nil,
        flags: CountryFlag? = nil
    ) -> Country {
        return Country(
            name: name,
            capital: capital,
            currency: currency,
            flags: flags
        )
    }
}
