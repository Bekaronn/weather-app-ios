//
//  ImageModel.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import Foundation

struct CurrentWeatherModel: Identifiable {
    let id: String
    let name: String
    let region: String
    let country: String
    let localTime: String
    let temperature: Double
    let conditionText: String
    let iconURL: String
    let isDay: Bool
    let windKph: Double
    let humidity: Int
    
    init(from entity: CurrentWeatherEntity) {
        self.id = UUID().uuidString
        self.name = entity.name
        self.region = entity.region
        self.country = entity.country
        self.localTime = entity.localTime
        self.temperature = entity.temperature
        self.conditionText = entity.conditionText
        self.iconURL = entity.iconURL
        self.isDay = entity.isDay
        self.windKph = entity.windKph
        self.humidity = entity.humidity
    }
    
    var formattedTemperature: String {
        return String(format: "%.1f°C", temperature)
    }
}
