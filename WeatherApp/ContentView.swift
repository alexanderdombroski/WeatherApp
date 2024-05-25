//
//  ContentView.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Location]

    var body: some View {
        NavigationView {
            ViewButton(destination: LocationChooser(), title: "Choose Location")
        }
    }
}

struct ViewButton<Destination: View>: View {
    let destination: Destination
    let title: String
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
