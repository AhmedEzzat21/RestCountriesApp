//
//  Repository.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation

final class CountryRepository: CountryRepositoryProtocol {
    private let mainKey = "MainCountries_v1"
    private let allKey = "AllCountries_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    var storedCountries: [Country] {
        guard let data = UserDefaults.standard.data(forKey: mainKey) else {
            print("📦 No stored data found")
            return []
        }
        do {
            let decoded = try decoder.decode([Country].self, from: data)
            print("📦 Loaded countries:", decoded.map { $0.name.common })
            return decoded
        } catch {
            print("❌ Failed to decode:", error)
            return []
        }
    }

    func saveMainCountries(_ countries: [Country]) {
        do {
            let data = try encoder.encode(countries)
            UserDefaults.standard.set(data, forKey: mainKey)
            print("📦 Saved countries:", countries.map { $0.name.common })
        } catch {
            print("❌ Failed to encode:", error)
        }
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
