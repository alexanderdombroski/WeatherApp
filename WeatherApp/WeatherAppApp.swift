//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftUI
import SwiftData

// Program starts running here

@main
struct WeatherAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ // Persistant data modeling
            Location.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView() // Load the first screen
        }
        .modelContainer(sharedModelContainer)
    }
}

