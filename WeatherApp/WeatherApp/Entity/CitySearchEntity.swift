//
//  ImageEntity.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import Foundation

struct CitySearchEntity: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let url: String
}
