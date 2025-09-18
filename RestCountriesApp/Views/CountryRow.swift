//
//  CountryRow.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//
import SwiftUI

struct CountryRow: View {
    let country: Country
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(country.name.common)
                    .font(.body)
                Text(country.capital?.first ?? "—")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if let code = country.cca2 {
                Text(code)
                    .font(.caption)
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 6).stroke())
            }
        }
        .padding(.vertical, 6)
    }
}
