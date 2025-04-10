//
//  WeatherForecastEntity.swift
//  WeatherApp
//
//  Created by Bekarys on 18.04.2025.
//

struct WeatherForecastEntity {
    let location: LocationEntity
    let current: CurrentEntity
    let forecast: [ForecastEntity]
    let airQuality: AirQualityEntity?
    let weatherAlerts: [WeatherAlertEntity]?
    let astronomy: [AstronomyEntity]?
}

struct AstronomyEntity {
    let sunrise: String?
    let sunset: String?
    let moonrise: String?
    let moonset: String?
}

struct LocationEntity {
    let name: String?
    let region: String?
    let country: String?
}

struct CurrentEntity {
    let temperatureC: Double?
    let conditionText: String?
    let conditionIconURL: String?
    let windSpeedKph: Double?
    let humidity: Int?
    let feelsLikeC: Double?
    let pressureMb: Double?
    let visibilityKm: Double?
    let cloudCoverage: Int?
}

struct ForecastEntity {
    let date: String
    let maxTempC: Double?
    let minTempC: Double?
    let avgTempC: Double?
}

struct AirQualityEntity {
    let pm25: Double?
    let pm10: Double?
    let no2: Double?
    let so2: Double?
    let o3: Double?
}

struct WeatherAlertEntity {
    let headline: String?
    let severity: String?
    let event: String?
    let effective: String?
    let expires: String?
    let description: String?
    let instruction: String?
}


func mapToWeatherForecastEntity(apiResponse: WeatherForecastApiResponse) -> WeatherForecastEntity {
    let location = LocationEntity(
        name: apiResponse.location.name,
        region: apiResponse.location.region,
        country: apiResponse.location.country
    )
    
    let current = CurrentEntity(
        temperatureC: apiResponse.current.temp_c,
        conditionText: apiResponse.current.condition.text,
        conditionIconURL: apiResponse.current.condition.icon,
        windSpeedKph: apiResponse.current.wind_kph,
        humidity: apiResponse.current.humidity,
        feelsLikeC: apiResponse.current.feelslike_c,
        pressureMb: apiResponse.current.pressure_mb,
        visibilityKm: apiResponse.current.vis_km,
        cloudCoverage: apiResponse.current.cloud
    )
    
    let forecast = apiResponse.forecast.forecastday.map { forecastDay in
        ForecastEntity(
            date: forecastDay.date,
            maxTempC: forecastDay.day.maxtemp_c,
            minTempC: forecastDay.day.mintemp_c,
            avgTempC: forecastDay.day.avgtemp_c
        )
    }
    
    let airQuality = AirQualityEntity(
        pm25: apiResponse.current.pm25,
        pm10: apiResponse.current.pm10,
        no2: apiResponse.current.no2,
        so2: apiResponse.current.so2,
        o3: apiResponse.current.o3
    )
    
    let weatherAlerts = apiResponse.alerts?.alert.map { alert in
        WeatherAlertEntity(
            headline: alert.headline,
            severity: alert.severity,
            event: alert.event,
            effective: alert.effective,
            expires: alert.expires,
            description: alert.desc,
            instruction: alert.instruction
        )
    }

    let astronomy = apiResponse.forecast.forecastday.map { forecastDay in
        AstronomyEntity(
            sunrise: forecastDay.astro.sunrise,
            sunset: forecastDay.astro.sunset,
            moonrise: forecastDay.astro.moonrise,
            moonset: forecastDay.astro.moonset
        )
    }
    
    return WeatherForecastEntity(
        location: location,
        current: current,
        forecast: forecast,
        airQuality: airQuality,
        weatherAlerts: weatherAlerts,
        astronomy: astronomy
    )
}
