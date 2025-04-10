//
//  ImageService.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import Foundation
import SwiftUI

protocol WeatherService {
    func searchCity(query: String) async throws -> [CitySearchEntity]
    func fetchCurrentWeather(query: String) async throws -> CurrentWeatherEntity
    func fetchWeatherForecast(query: String) async throws -> WeatherForecastEntity
}

struct WeatherServiceImpl: WeatherService {
    private let apiKey = ""
    
    func searchCity(query: String) async throws -> [CitySearchEntity] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(encodedQuery)"
        
        print("Отправка запроса по URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.requestFailed
            }
            
            let result = try JSONDecoder().decode([CitySearchEntity].self, from: data)
            
            print("Получен результат: \(result)")
            return result
        } catch {
            print("Ошибка при запросе: \(error)")
            throw WeatherError.requestFailed
        }
    }
    
    func fetchCurrentWeather(query: String) async throws -> CurrentWeatherEntity {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(encodedQuery)&aqi=no"
        
        print("Получаем текущую погоду: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.requestFailed
            }
            
            let decoded = try JSONDecoder().decode(CurrentWeatherApiResponse.self, from: data)
            
            return CurrentWeatherEntity(
                name: decoded.location.name,
                region: decoded.location.region,
                country: decoded.location.country,
                localTime: decoded.location.localtime,
                temperature: decoded.current.temp_c,
                conditionText: decoded.current.condition.text,
                iconURL: decoded.current.condition.icon,
                isDay: decoded.current.is_day == 1,
                windKph: decoded.current.wind_kph,
                humidity: decoded.current.humidity
            )
        } catch {
            print("Ошибка при получении погоды: \(error)")
            throw WeatherError.requestFailed
        }
    }
    
    func fetchWeatherForecast(query: String) async throws -> WeatherForecastEntity {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(encodedQuery)&days=7&aqi=yes&alerts=yes"
        
        print("Получаем прогноз погоды на 7 дней: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw WeatherError.requestFailed
            }
            
            // Декодируем данные из API в модель WeatherForecastApiResponse
            let decoded = try JSONDecoder().decode(WeatherForecastApiResponse.self, from: data)
            
            print("DECODED: ", decoded)
            
            // Преобразуем данные из модели в сущности для использования в UI
            let weatherForecastEntity = mapToWeatherForecastEntity(apiResponse: decoded)
            
            // Возвращаем сущность WeatherForecastEntity с преобразованными данными
            print("RESULT: ", weatherForecastEntity)
            return weatherForecastEntity
        } catch {
            print("Ошибка при получении прогноза погоды: \(error)")
            throw WeatherError.requestFailed
        }
    }
    
}

enum WeatherError: Error {
    case invalidUrl
    case requestFailed
}

