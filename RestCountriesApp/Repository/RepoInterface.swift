//
//  RepoInterface.swift
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
