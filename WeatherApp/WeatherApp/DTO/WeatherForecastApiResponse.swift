//
//  WeatherForecastApiResponse.swift
//  WeatherApp
//
//  Created by Bekarys on 18.04.2025.
//

import Foundation

struct WeatherForecastApiResponse: Codable {
    let location: Location
    let current: Current
    let forecast: ForecastData
    let alerts: Alerts?
    
    struct Location: Codable {
        let name: String?
        let region: String?
        let country: String?
        let lat: Double?
        let lon: Double?
        let tz_id: String?
        let localtime_epoch: Int?
        let localtime: String?
    }

    struct Current: Codable {
        let last_updated_epoch: Int?
        let last_updated: String?
        let temp_c: Double?
        let temp_f: Double?
        let is_day: Int?
        let condition: WeatherCondition
        let wind_mph: Double?
        let wind_kph: Double?
        let wind_degree: Int?
        let wind_dir: String?
        let pressure_mb: Double?
        let pressure_in: Double?
        let precip_mm: Double?
        let precip_in: Double?
        let humidity: Int?
        let cloud: Int?
        let feelslike_c: Double?
        let feelslike_f: Double?
        let vis_km: Double?
        let vis_miles: Double?
        let pm25: Double?
        let pm10: Double?
        let no2: Double?
        let so2: Double?
        let o3: Double?
    }

    struct ForecastData: Codable {
        let forecastday: [ForecastDay]
    }

    struct ForecastDay: Codable {
        let date: String
        let day: Day
        let astro: Astro
    }

    struct Day: Codable {
        let maxtemp_c: Double?
        let maxtemp_f: Double?
        let mintemp_c: Double?
        let mintemp_f: Double?
        let avgtemp_c: Double?
        let avgtemp_f: Double?
        let maxwind_mph: Double?
        let maxwind_kph: Double?
        let totalprecip_mm: Double?
        let totalprecip_in: Double?
        let totalsun_hours: Double?
        let uv: Double?
    }

    struct Astro: Codable {
        let sunrise: String?
        let sunset: String?
        let moonrise: String?
        let moonset: String?
    }

    struct WeatherCondition: Codable {
        let text: String?
        let icon: String?
        let code: Int?
    }

    struct Alerts: Codable {
        let alert: [Alert]
    }

    struct Alert: Codable {
        let headline: String?
        let msgtype: String?
        let severity: String?
        let urgency: String?
        let areas: String?
        let category: String?
        let certainty: String?
        let event: String?
        let note: String?
        let effective: String?
        let expires: String?
        let desc: String?
        let instruction: String?
    }
}
