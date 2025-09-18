//
//  Models.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation

struct Country: Identifiable, Codable, Hashable {
    var id: String { cca2 ?? UUID().uuidString }

    let name: Name
    let capital: [String]?
    let cca2: String?
    let latlng: [Double]?
    let currencies: [String: CurrencyInfo]?
}

struct Name: Codable, Hashable {
    let common: String
    let official: String
}

struct CurrencyInfo: Codable, Hashable {
    let name: String?
    let symbol: String?
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
}
