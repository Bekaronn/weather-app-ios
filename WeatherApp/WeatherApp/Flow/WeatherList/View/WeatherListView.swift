//
//  ImageListView.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import SwiftUI

struct ImageListView: View {
    @StateObject var viewModel: WeatherListViewModel
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                ? [.black]
                : [.blue, .indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                headerView
                
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    else if searchText.isEmpty {
                        // Показ погоды по умолчанию
                        ForEach(viewModel.currentCitiesWeather) {currentCityWeather in
                            cityCardView(city: currentCityWeather)
                                .padding(.horizontal)
                        }
                    } else {
                        // Показ результатов поиска
                        ForEach(viewModel.searchResults) { searchResult in
                            searchResultView(result: searchResult)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .foregroundColor(.white)
        }
        .task {
            await viewModel.fetchWeatherForSavedCities()
        }
    }
    
}

extension ImageListView {
    
    @ViewBuilder
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weather")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button {
                    print("Обновить погоду")
                    Task { await viewModel.fetchWeatherForSavedCities() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.7))
                
                TextField("Search city", text: $searchText)
                    .foregroundColor(.white)
                    .onChange(of: searchText) {
                        Task {
                            await viewModel.search(query: searchText)
                        }
                    }
            }
            .padding(12)
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func cityCardView(city: CurrentWeatherModel) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(city.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(city.isDay ? "☀️" : "🌙")
                        .font(.title3)
                }
                
                Text(city.conditionText)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 12) {
                    Label("\(Int(city.humidity))%", systemImage: "humidity")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Label("\(city.windKph, specifier: "%.1f") km/h", systemImage: "wind")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Text("\(Int(city.temperature))°")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: city.isDay
                                   ? [Color.blue.opacity(0.6), Color.cyan.opacity(0.8)]
                                   : [Color.black.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .onTapGesture {
            print("Tapped \(city.name)")
            viewModel.routeToDetail(by: city.name)
        }
    }
    
    
    @ViewBuilder
    private func searchResultView(result: CitySearchModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("\(result.region), \(result.country)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.toggleCity(result)
            }) {
                Image(systemName: viewModel.savedCities.contains(result.name) ? "minus.circle.fill" : "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(viewModel.savedCities.contains(result.name) ? .red : .white)
                    .animation(.easeInOut, value: viewModel.savedCities.contains(result.name))
            }
            .frame(width: 36, height: 36)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.2))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
    
    
}

//#Preview {
//    ImageListView()
//}
