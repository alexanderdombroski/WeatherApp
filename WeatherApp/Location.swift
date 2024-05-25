//
//  Item.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import Foundation
import SwiftData

@Model
final class Location {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
