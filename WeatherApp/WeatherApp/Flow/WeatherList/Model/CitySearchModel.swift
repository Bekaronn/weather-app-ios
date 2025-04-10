//
//  CitySearchModel.swift
//  WeatherApp
//
//  Created by Bekarys on 18.04.2025.
//

import Foundation

struct CitySearchModel: Identifiable {
    let id: String
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let url: String
    
    init(from entity: CitySearchEntity) {
        self.id = UUID().uuidString
        self.name = entity.name
        self.region = entity.region
        self.country = entity.country
        self.latitude = entity.lat
        self.longitude = entity.lon
        self.url = entity.url
    }
    
    var locationDescription: String {
        return "\(name), \(region), \(country)"
    }
}
