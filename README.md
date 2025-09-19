# 🌍 RestCountriesApp

An iOS application built with **SwiftUI + MVVM** that displays a list of countries using the [RestCountries API](https://restcountries.com/).
Users can:

* Browse all countries.
* Search countries by name.
* Pin selected countries as "Main Countries".
* View detailed information about each country.

---

## 📱 Features

* ✅ Fetch countries from [RestCountries v3.1 API](https://restcountries.com/v3.1/all?fields=name,capital,cca2,latlng,currencies).
* ✅ Display countries in two sections:

  * **Main Countries** (user-pinned, max 5).
  * **All Countries** (fetched from API).
* ✅ Search functionality with case-insensitive matching.
* ✅ Country details screen (capital, currencies, code).
* ✅ Local persistence for pinned countries (repository pattern).
* ✅ Unit Tests for:

  * Fetching countries from API.
  * Adding/removing from main list.
  * Search filtering.

---

## 🛠 Project Structure

```
RestCountriesApp/
│
├── RestCountriesApp.swift        # App entry point
│
├── Models/
│   └── Country.swift             # Country, Name, CurrencyInfo models
│
├── ViewModels/
│   ├── CountriesViewModel.swift  # Main view model
│   └── CountryDetailViewModel.swift
│
├── Views/
│   ├── ContentView.swift         # Main screen
│   ├── CountryRow.swift          # Row for list
│   └── CountryDetailView.swift   # Details screen
│
├── Services/
│   ├── NetworkService.swift      # API calls
│   └── CountryRepository.swift   # Local persistence
│
├── Supporting Files/
│   └── Info.plist                # ATS exceptions
│
└── RestCountriesAppTests/
    └── RestCountriesAppTests.swift # Unit tests
```

---

## 🚀 Requirements

* iOS 16.0+
* Xcode 15+
* Swift 5.9

---

## ⚙️ Setup & Run

1. Clone the repository.
2. Open `RestCountriesApp.xcodeproj` in Xcode.
3. Build & Run on iOS Simulator or real device.
4. Make sure you have internet connection (API is public, no API key required).

---

## 🧪 Running Tests

1. Open the project in Xcode.
2. Press **⌘U** or go to `Product → Test`.
3. Test target: **RestCountriesAppTests**.

---

## 📡 API Reference

This app uses [RestCountries v3.1](https://restcountries.com/).
We fetch only the required fields:

```
https://restcountries.com/v3.1/all?fields=name,capital,cca2,latlng,currencies
```

---


## 👤 Author

Built by **Ahmed Ezzat** ✨
For technical assessments & iOS development showcase.
