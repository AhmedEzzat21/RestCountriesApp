//
//  Repository.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation

protocol CountryRepositoryProtocol {
    var storedCountries: [Country] { get }
    func saveMainCountries(_ countries: [Country])
    func saveAllCountries(_ countries: [Country])
}

final class CountryRepository: CountryRepositoryProtocol {
    private let mainKey = "MainCountries_v1"
    private let allKey = "AllCountries_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    var storedCountries: [Country] {
        guard let data = UserDefaults.standard.data(forKey: mainKey),
              let decoded = try? decoder.decode([Country].self, from: data) else { return [] }
        return decoded
    }

    func saveMainCountries(_ countries: [Country]) {
        guard let data = try? encoder.encode(countries) else { return }
        UserDefaults.standard.set(data, forKey: mainKey)
    }

    func saveAllCountries(_ countries: [Country]) {
        guard let data = try? encoder.encode(countries) else { return }
        UserDefaults.standard.set(data, forKey: allKey)
    }

    func loadAllCountries() -> [Country]? {
        guard let data = UserDefaults.standard.data(forKey: allKey),
              let decoded = try? decoder.decode([Country].self, from: data) else { return nil }
        return decoded
    }
}
