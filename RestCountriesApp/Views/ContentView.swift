//
//  ContentView.swift
//  RestCountriesApp
//
//  Created by Ahmed Ezzat on 18/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CountriesViewModel()
    @StateObject var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                SearchBar(text: $vm.searchText, placeholder: "Search countries")
                    .padding(.horizontal)

                if vm.isLoading {
                    ProgressView("Loading countries...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                List {
                    Section(header: Text("Main Countries (max \(vm.maxMain))")) {
                        if vm.mainCountries.isEmpty {
                            Text("No countries added yet.")
                                .foregroundColor(.secondary)
                        }
                        ForEach(vm.mainCountries) { country in
                            NavigationLink(value: country) {                                   CountryRow(country: country)
                            }
                        }
                        .onDelete(perform: vm.removeFromMain)
                    }

                    Section(header: Text("All Countries")) {
                        ForEach(vm.filtered) { country in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(country.name.common)
                                    Text(country.capital?.first ?? "—")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Button(action: {
                                    vm.addToMain(country)
                                }) {
                                    Image(systemName: "plus.circle")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task { await vm.loadCountries(forceRefresh: true) }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task {
                await vm.loadCountries()
                locationManager.requestLocation()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                vm.addFirstCountryByLocation(locationManager.userLocation)
            }
            .navigationDestination(for: Country.self) { country in
                CountryDetailView(viewModel: CountryDetailViewModel(country: country))
            }
            .alert(item: $vm.alertMessage) { msg in
                Alert(title: Text("Notice"),
                      message: Text(msg.message),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}


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



struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6)))
    }
}
