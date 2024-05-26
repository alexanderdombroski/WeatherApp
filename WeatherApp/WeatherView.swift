//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/25/24.
//

import SwiftUI
import SwiftData

struct WeatherView: View {
    let test = ["Hi", "My", "Name", "Is", "Alex"]
    
    @Query private var locations: [Location]
    
    @State private var selectedLocation: Location?
    @State private var weatherData: [String: Any]?
    
    @StateObject private var forecast = Forecast(location: Location(name: "Sahara", country: "Libya", longitude: 13.0174, latitude: 32.5338))
    
    let bottomColor = UIColor(red: 0.4, green: 0.1, blue: 0.8, alpha: 1)
    
    @State var showingDayForecast: Bool = false
    @State var chosenDay: DailyForecast?
    
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, Color(bottomColor)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                HStack {
                    // ---------- Selector Element ----------
                    Picker("Locations", selection: $selectedLocation) {
                        ForEach(locations, id: \.id) { location in
                            Text(location.name).tag(location as Location?)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLocation) {
                        queryWeather()
                    }.onAppear {
                        if selectedLocation == nil && !locations.isEmpty {
                            selectedLocation = locations.first
                            queryWeather()
                        }
                    }
                    Spacer()
                }
                
                // ---------- General Data ----------
                Text("\(forecast.city)").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                VStack {
                    let temp = (forecast.feelsLike - 273.15) * 9/5 + 32
                    if temp > 80 {
                        imageLabel(imageName: "flame.fill", imageColor: .orange, label: "Feels Like: \(formatFahrenheit( forecast.feelsLike))")
                    } else if temp > 45 {
                        imageLabel(imageName: "cloud.fill", imageColor: .white, label: "Feels Like: \(formatFahrenheit( forecast.feelsLike))")
                    } else {
                        imageLabel(imageName: "snow", imageColor: .white, label: "Feels Like: \(formatFahrenheit( forecast.feelsLike))")
                    }
                    imageLabel(imageName: "sun.max.fill", imageColor: .yellow, label: "Sunrise: \(forecast.sunrise)")
                    imageLabel(imageName: "moon.fill", imageColor: .yellow, label: "Sunset: \(forecast.sunset)")
                    imageLabel(imageName: "drop.fill", imageColor: .cyan, label: "Humidity: \(forecast.humidity)%")
                }
                ForEach(forecast.dailyForecast, id: \.id) { dailyForecast in
                    HStack {
                        Text(dailyForecast.getDate())
                            .foregroundStyle(.white)
                            .font(.title3)
                        Text(formatFahrenheit(dailyForecast.minTemperature))
                            .foregroundStyle(.white)
                            .font(.title3)
                        Text(formatFahrenheit(dailyForecast.maxTemperature))
                            .foregroundStyle(.white)
                            .font(.title3)
                    }.onTapGesture {
                        DispatchQueue.main.async {
                            chosenDay = dailyForecast
                            showingDayForecast = true
                        }
                        refreshID = UUID()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .background(Color(UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)))
                }
                Spacer()
            }
            .sheet(isPresented: $showingDayForecast) {
                if let chosenDay = chosenDay {
                    WeatherDayView(dailyForecast: chosenDay)
                } else {
                    Text("No forecast data available")
                }
            }
            .id(refreshID)
        }
        
    }
    
    func queryWeather() {
        if let location = selectedLocation {
            forecast.changeLocation(to: location)
        } else {
            print("Location is not selected")
        }
    }
    
}

struct imageLabel: View {
    let imageName: String
    var imageColor: UIColor = .black
    var imageSizeModifier = 1.0
    let label: String
    var body: some View {
        HStack {
            Image(systemName: imageName) // Sun symbol
                .resizable()
                .frame(width: 50 * imageSizeModifier, height: 50 * imageSizeModifier)
                .foregroundStyle(Color(imageColor))
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 50))
            Text(label)
                .foregroundStyle(.white)
                .font(.title2)
            Spacer()
        }
    }
}

#Preview {
    WeatherView()
}
