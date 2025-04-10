//
//  ImageListViewModel.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import SwiftUI


final class WeatherListViewModel: ObservableObject {
    @Published var searchResults: [CitySearchModel] = []
    @Published var currentCitiesWeather: [CurrentWeatherModel] = []
    @Published var savedCities: [String] = ["Almaty", "Astana"]
    @Published var isLoading: Bool = false
    
    private let service: WeatherService
    private let router: WeatherRouter
    
    // кэш для погоды городов
    private var weatherCache: [String: CurrentWeatherModel] = [:]
    
    
    init(service: WeatherService, router: WeatherRouter) {
        self.service = service
        self.router = router
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            await MainActor.run {
                self.searchResults = []
                self.isLoading = false
            }
            return
        }
        
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let searchEntityArray = try await service.searchCity(query: query)
            await MainActor.run {
                self.searchResults = searchEntityArray.map { CitySearchModel(from: $0) }
                self.isLoading = false
            }
        } catch {
            print("Ошибка поиска: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func fetchWeatherForSavedCities() async {
        guard !savedCities.isEmpty else { return }
        
        await MainActor.run {
            self.isLoading = true
        }
        
        fetchCurrentWeathers(cityNames: savedCities) { weatherModels in
            self.isLoading = false
            self.currentCitiesWeather = weatherModels
        }
    }
    
    func fetchCurrentWeathers(cityNames: [String], completion: @escaping ([CurrentWeatherModel]) -> Void) {
        guard !cityNames.isEmpty else {
            completion([])
            return
        }
        
        var weatherModels: [CurrentWeatherModel] = []
        let dispatchGroup = DispatchGroup()
        
        for cityName in cityNames {
            dispatchGroup.enter()
            
            Task {
                do {
                    let weatherEntity = try await self.service.fetchCurrentWeather(query: cityName)
                    let weatherModel = CurrentWeatherModel(from: weatherEntity)
                    weatherModels.append(weatherModel)
                } catch {
                    print("Ошибка для города \(cityName): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(weatherModels)
        }
    }
    
    func toggleCity(_ city: CitySearchModel) {
        if savedCities.contains(city.name) {
            savedCities.removeAll { $0 == city.name }
        } else {
            savedCities.append(city.name)
        }
    }
    
    
    func routeToDetail(by name: String) {
        router.showDetails(for: name)
    }
}
