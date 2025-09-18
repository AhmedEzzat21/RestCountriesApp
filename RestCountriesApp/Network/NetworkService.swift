//
//  NetworkService.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,capital,cca2,latlng,currencies") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse {
            print("➡️ Status code:", http.statusCode)
            if !(200..<300).contains(http.statusCode) {
                let body = String(data: data, encoding: .utf8) ?? "no body"
                print("❌ Error body:", body)
                throw NetworkError.invalidResponse
            }
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([Country].self, from: data)
    }
}
