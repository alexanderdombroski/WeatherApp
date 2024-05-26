//
//  Item.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftData
import Foundation

@Model
final class Location: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var country: String
    var longitude: Double
    var latitude: Double
    
    init(name: String, country: String, longitude: Double, latitude: Double) {
        self.name = name
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
}
