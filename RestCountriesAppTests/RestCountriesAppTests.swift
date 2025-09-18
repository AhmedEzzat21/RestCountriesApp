//
//  RestCountriesAppTests.swift
//  RestCountriesAppTests
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import XCTest
@testable import RestCountriesApp

@MainActor
final class RestCountriesAppTests: XCTestCase {

    func testAddAndRemoveCountryInMain() {
        let repo = CountryRepository()
        let vm = CountriesViewModel(repository: repo)

        let testCountry = Country(
            name: Name(common: "Testland", official: "Republic of Testland"),
            capital: ["Test City"],
            cca2: "TT",
            latlng: [10.0, 20.0],
            currencies: ["TST": CurrencyInfo(name: "Test Dollar", symbol: "$")]
        )

        vm.addToMain(testCountry)
        XCTAssertEqual(vm.mainCountries.count, 1)

        vm.removeFromMain(country: testCountry)
        XCTAssertEqual(vm.mainCountries.count, 0)
    }

    func testSearchFilter() {
        let repo = CountryRepository()
        let vm = CountriesViewModel(repository: repo)

        vm.injectCountries([
            Country(name: Name(common: "Egypt", official: "Arab Republic of Egypt"),
                    capital: ["Cairo"],
                    cca2: "EG",
                    latlng: [27.0, 30.0],
                    currencies: ["EGP": CurrencyInfo(name: "Egyptian Pound", symbol: "£")]),
            Country(name: Name(common: "France", official: "French Republic"),
                    capital: ["Paris"],
                    cca2: "FR",
                    latlng: [46.0, 2.0],
                    currencies: ["EUR": CurrencyInfo(name: "Euro", symbol: "€")])
        ])

        vm.searchText = "fra"
        let filtered = vm.filtered

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.name.common, "France")
    }

    func testFetchCountriesFromAPI() async throws {
        let service = NetworkService.shared
        let countries = try await service.fetchCountries()

        XCTAssertFalse(countries.isEmpty, "Countries list should not be empty")
        XCTAssertNotNil(countries.first?.name.common, "First country should have a name")
    }
}
