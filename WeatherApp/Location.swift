//
//  Item.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftData

@Model
final class Location {
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
