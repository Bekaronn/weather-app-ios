//
//  WeatherApiResponse.swift
//  WeatherApp
//
//  Created by Bekarys on 18.04.2025.
//

import UIKit

struct CurrentWeatherEntity {
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
}
