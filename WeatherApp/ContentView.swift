//
//  ContentView.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import SwiftUI

// First Screen

let TEXTCOLOR = UIColor(red: 1, green: 1, blue: 0.7, alpha: 1)

struct ContentView: View {
    let topColor = UIColor(red: 0, green: 0.8, blue: 1, alpha: 1)
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color(topColor), .blue], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                VStack {
                    Text("WeatherNow")
                        .foregroundStyle(Color(TEXTCOLOR))
                        .font(.system(size: 55))
                    HStack {
                        ThunderCloud()
                        ThunderCloud()
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 60, trailing: 0))
                    
                    ViewButton(destination: LocationChooser(), title: "Manage Locations")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                    ViewButton(destination: WeatherView(), title: "See Weather")
                }
            }
        }
    }
}

struct ThunderCloud: View {
    var body: some View {
        Image(systemName: "cloud.bolt.rain.fill")
            .font(.system(size: 50))
            .foregroundStyle(Color(TEXTCOLOR))
    }
}

struct ViewButton<Destination: View>: View {
    let destination: Destination
    let title: String
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [.blue, Color(UIColor(red: 0.8, green: 0.8, blue: 1, alpha: 0.1))]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 200
                    )
                )
                .foregroundStyle(Color(TEXTCOLOR))
                .cornerRadius(10)
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
