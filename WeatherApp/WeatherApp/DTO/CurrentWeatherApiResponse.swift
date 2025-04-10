//
//  WeatherApiResponse.swift
//  WeatherApp
//
//  Created by Bekarys on 18.04.2025.
//

import Foundation

struct CurrentWeatherApiResponse: Decodable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let localtime: String
}

struct CurrentWeather: Decodable {
    let temp_c: Double
    let is_day: Int
    let condition: Condition
    let wind_kph: Double
    let humidity: Int
}

struct Condition: Decodable {
    let text: String
    let icon: String
}
