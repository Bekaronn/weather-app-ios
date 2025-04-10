//
//  ImageDetailView.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import SwiftUI
import UIKit

struct WeatherDetailView: View {
    let cityName: String
    @StateObject var viewModel: WeatherDetailViewModel
    @Environment(\.colorScheme) var colorScheme
    
    init(cityName: String, service: WeatherService) {
        self.cityName = cityName
        _viewModel = StateObject(wrappedValue: WeatherDetailViewModel(service: service))
    }
    
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
                ScrollView {
                    Text(cityName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    if let currentWeather = viewModel.weatherForecast?.current {
                        Text("\(currentWeather.temperatureC ?? 0.0, specifier: "%.1f")°C")
                            .font(.system(size: 50, weight: .semibold))
                    }
                    
                    VStack(spacing: 8) {
                        if let currentWeather = viewModel.weatherForecast?.current,
                           let iconURL = URL(string: "https:\(currentWeather.conditionIconURL ?? "")") {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 64, height: 64)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        if let currentWeather = viewModel.weatherForecast?.current {
                            Text(currentWeather.conditionText ?? "Unknown")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text("Max: \((viewModel.weatherForecast?.forecast.first?.maxTempC ?? 0).formatted())°C")
                        Text("Min: \((viewModel.weatherForecast?.forecast.first?.minTempC ?? 0).formatted())°C")
                        Text("Avg: \((viewModel.weatherForecast?.forecast.first?.avgTempC ?? 0).formatted())°C")
                    }
                    .font(.headline)
                    .padding(.top, 8)
                    
                    if let currentWeather = viewModel.weatherForecast?.current {
                        VStack(spacing: 4) {
                            Text("Humidity: \(currentWeather.humidity ?? 0)%")
                            Text("Wind Speed: \(currentWeather.windSpeedKph ?? 0.0, specifier: "%.1f") km/h")
                        }
                        .font(.headline)
                        .padding(.top, 8)
                    }
                    
                    forecastSection()
                    
                    airQualityCard(airQuality: viewModel.weatherForecast?.airQuality)
                    
                    astronomyCard(astro: viewModel.weatherForecast?.astronomy?.first)
                    
                    weatherAlertCard(weatherAlerts: viewModel.weatherForecast?.weatherAlerts)
                    
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchWeatherForecast(query: cityName)
                }
            }
            .foregroundColor(.white)
        }
    }
}

extension WeatherDetailView {
    @ViewBuilder
    private func forecastSection() -> some View {
        if let forecast = viewModel.weatherForecast?.forecast, !forecast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("7-DAY FORECAST")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                ForEach(forecast.indices, id: \.self) { index in
                    let day = forecast[index]
                    HStack {
                        Text(formattedDay(for: day.date, index: index))
                            .font(.headline)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Max: \(day.maxTempC ?? 0, specifier: "%.1f")°C")
                            Text("Min: \(day.minTempC ?? 0, specifier: "%.1f")°C")
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }
            }
            .foregroundColor(.white)
            .padding()
        }
    }
    
    @ViewBuilder
    private func airQualityCard(airQuality: AirQualityEntity?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Air Quality Data")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            if let airQuality = airQuality {
                HStack {
                    VStack(alignment: .leading) {
                        Text("PM2.5: \(airQuality.pm25 ?? 0.0) µg/m³")
                        Text("PM10: \(airQuality.pm10 ?? 0.0) µg/m³")
                        Text("NO2: \(airQuality.no2 ?? 0.0) µg/m³")
                        Text("SO2: \(airQuality.so2 ?? 0.0) µg/m³")
                        Text("O3: \(airQuality.o3 ?? 0.0) µg/m³")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                .background(Color.green.opacity(0.2))  // Background color
                .cornerRadius(12)
            } else {
                Text("Air quality data is not available")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(12)
            }
        }
        .padding()
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func astronomyCard(astro: AstronomyEntity?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Astronomy Information")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            if let astro = astro {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sunrise: \(astro.sunrise ?? "Not available")")
                    Text("Sunset: \(astro.sunset ?? "Not available")")
                    Text("Moonrise: \(astro.moonrise ?? "Not available")")
                    Text("Moonset: \(astro.moonset ?? "Not available")")
                }
                .font(.subheadline)
                .padding()
                .background(Color.purple.opacity(0.2))
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(12)
            } else {
                Text("Astronomy data is not available")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(12)
            }
        }
        .padding()
        .cornerRadius(12)
    }

    
    @ViewBuilder
    private func weatherAlertCard(weatherAlerts: [WeatherAlertEntity]?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weather Alerts & Warnings")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            
            if let weatherAlerts = weatherAlerts, !weatherAlerts.isEmpty {
                ForEach(weatherAlerts, id: \.headline) { alert in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Headline: \(alert.headline ?? "No headline available")")
                            .font(.headline)
                        Text("Event: \(alert.event ?? "No event description")")
                            .font(.subheadline)
                        Text("Severity: \(alert.severity ?? "Unknown")")
                            .font(.subheadline)
                        Text("Effective: \(alert.effective ?? "No effective time")")
                            .font(.subheadline)
                        Text("Expires: \(alert.expires ?? "No expiry time")")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.bottom, 8)
                }
            } else {
                Text("No weather alerts or warnings at the moment")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(12)
            }
        }
        .padding()
        .cornerRadius(12)
    }
    
    
    
    private func formattedDay(for dateString: String, index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        if index == 0 && calendar.isDateInToday(date) {
            return "Today"
        }
        
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
