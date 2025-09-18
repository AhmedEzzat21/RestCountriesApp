//
//  CountryDetailView.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import SwiftUI

struct CountryDetailView: View {
    @ObservedObject var viewModel: CountryDetailViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.country.name.common) 
                .font(.title2)
                .bold()

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Capital", systemImage: "building.columns")
                    Text(viewModel.capitalText)
                        .font(.headline)
                }
                Spacer()
            }

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Currencies", systemImage: "dollarsign.circle")
                    Text(viewModel.currenciesText)
                        .font(.headline)
                }
                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
