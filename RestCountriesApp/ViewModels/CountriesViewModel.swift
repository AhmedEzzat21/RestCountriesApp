//
//  CountriesViewModel.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class CountriesViewModel: ObservableObject {
    @Published private(set) var allCountries: [Country] = []
    @Published var mainCountries: [Country] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var alertMessage: AlertMessage? = nil

    private let repository: CountryRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    let maxMain = 5

    init(repository: CountryRepositoryProtocol = CountryRepository()) {
        self.repository = repository
        self.mainCountries = repository.storedCountries
        setupBindings()
    }

    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
    }

    var filtered: [Country] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return allCountries }
        return allCountries.filter { $0.name.common.localizedCaseInsensitiveContains(searchText) }
    }

    func loadCountries(forceRefresh: Bool = false) async {
        isLoading = true
        defer { isLoading = false }

        if let repo = (repository as? CountryRepository), !forceRefresh {
            if let cached = repo.loadAllCountries(), !cached.isEmpty {
                self.allCountries = cached
                return
            }
        }

        do {
            let countries = try await NetworkService.shared.fetchCountries()
            self.allCountries = countries.sorted { $0.name.common < $1.name.common }
            if let repo = repository as? CountryRepository {
                repo.saveAllCountries(self.allCountries)
            }
        } catch {
            alertMessage = AlertMessage(message: "Failed to fetch countries: \(error.localizedDescription)")
        }
    }

    func addToMain(_ country: Country) {
        if mainCountries.contains(where: { $0.id == country.id }) { return }
        guard mainCountries.count < maxMain else {
            alertMessage = AlertMessage(message: "You can add up to \(maxMain) countries only.")
            return
        }
        mainCountries.append(country)
        repository.saveMainCountries(mainCountries)
    }

    func removeFromMain(at offsets: IndexSet) {
        mainCountries.remove(atOffsets: offsets)
        repository.saveMainCountries(mainCountries)
    }

    func removeFromMain(country: Country) {
        mainCountries.removeAll { $0.id == country.id }
        repository.saveMainCountries(mainCountries)
    }

    func addFirstCountryByLocation(_ location: CLLocation?, defaultCountryName: String = "Egypt") {
        guard mainCountries.isEmpty else {
            print("📦 Skipping auto-add, already have:", mainCountries.map { $0.name.common })
            return
        }

        if let location = location {
            var best: (country: Country, dist: Double)?
            for c in allCountries {
                if let latlng = c.latlng, latlng.count == 2 {
                    let cl = CLLocation(latitude: latlng[0], longitude: latlng[1])
                    let d = cl.distance(from: location)
                    if best == nil || d < best!.dist {
                        best = (c, d)
                    }
                }
            }
            if let candidate = best?.country {
                addToMain(candidate)
                return
            }
        }

        if let fallback = allCountries.first(where: { $0.name.common.localizedCaseInsensitiveContains(defaultCountryName) }) {
            addToMain(fallback)
        }
    }



    #if DEBUG
    func injectCountries(_ countries: [Country]) {
        self.allCountries = countries
    }
    #endif
}
