//
//  CountryDetailViewModel.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation
import Combine

@MainActor
final class CountryDetailViewModel: ObservableObject {
    @Published var country: Country

    init(country: Country) {
        self.country = country
    }

    var capitalText: String {
        country.capital?.first ?? "—"
    }

    var currenciesText: String {
        guard let dict = country.currencies, !dict.isEmpty else { return "—" }
        // dict: [code: CurrencyInfo]
        return dict.map { key, value in
            if let name = value.name {
                return "\(name) (\(key))"
            } else {
                return key
            }
        }.joined(separator: ", ")
    }
}
