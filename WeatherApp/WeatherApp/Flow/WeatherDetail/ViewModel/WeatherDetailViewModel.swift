//
//  ImageDetailViewModel.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import SwiftUI

final class WeatherDetailViewModel: ObservableObject {
    private let service: WeatherService
    
    @Published var weatherForecast: WeatherForecastEntity?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    init(service: WeatherService) {
        self.service = service
    }
    
    func fetchWeatherForecast(query: String) async {
        guard !query.isEmpty else {
            await MainActor.run {
                self.errorMessage = "Что-то пошло не так..."
                self.isLoading = false
            }
            return
        }
        
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let forecastEntity = try await service.fetchWeatherForecast(query: query)
            await MainActor.run {
                self.weatherForecast = forecastEntity
                self.isLoading = false
            }
        } catch {
            print("Ошибка поиска: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
