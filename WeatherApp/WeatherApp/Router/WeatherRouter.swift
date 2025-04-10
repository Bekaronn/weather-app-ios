//
//  ImageRouter.swift
//  GalleryApp
//
//  Created by Bekarys on 04.04.2025.
//

import SwiftUI
import UIKit

final class WeatherRouter {
    var rootViewController: UINavigationController?
    
    func showDetails(for name: String) {
        let service = WeatherServiceImpl()
        let detailVC = UIHostingController(rootView: WeatherDetailView(cityName: name, service: service))
        rootViewController?.pushViewController(detailVC, animated: true)
    }
}
