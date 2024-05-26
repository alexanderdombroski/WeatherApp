//
//  forcast.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/25/24.
//

import Foundation

final class Forecast: ObservableObject {
    var location: Location
    @Published var city = "idk"
    @Published var dailyForecast: [DailyForecast] = []
    @Published var sunrise = "idk"
    @Published var sunset = "idk"
    @Published var feelsLike = 0.0
    @Published var humidity = 0.0
    
    init(location: Location) {
            self.location = location
            updateWeatherData(for: location)
        }
        
        func changeLocation(to newLocation: Location) {
            self.location = newLocation
            updateWeatherData(for: newLocation)
        }

        private func updateWeatherData(for location: Location) {
            getData(url: buildUrl()) { jsonData in
                if let jsonData = jsonData, let dayDataList = jsonData["list"] as? [[String: Any]], let cityData = jsonData["city"] as? [String: Any], let nowData = dayDataList.first?["main"] as? [String: Any] {
                    DispatchQueue.main.async {
                        self.city = cityData["name"] as? String ?? "Unknown"
                        self.sunrise = self.formatTime(unixTime: cityData["sunrise"] as? Int ?? 0)
                        self.sunset = self.formatTime(unixTime: cityData["sunset"] as? Int ?? 0)
                        self.dailyForecast = self.parseDailyForecasts(from: dayDataList)
                        self.feelsLike = nowData["feels_like"] as? Double ?? 0.0
                        self.humidity = nowData["humidity"] as? Double ?? 0.0
                        print("Updated Forecast for \(self.city)")
                    }
                } else {
                    print("No data found")
                }
            }
        }
    
    private func parseDailyForecasts(from dayDataList: [[String: Any]]) -> [DailyForecast] {
        var generalForcasts: [Date: DailyForecast] = [:]
        let calendar = Calendar.current

        for forecast in dayDataList {
            guard let timestamp = forecast["dt"] as? TimeInterval,
                  let main = forecast["main"] as? [String: Any],
                  let temperature = main["temp"] as? Double,
                  let weather = (forecast["weather"] as? [[String: Any]])?.first,
                  let description = weather["description"] as? String 
            else {
                continue
            }
            let date = Date(timeIntervalSince1970: timestamp)
            let dayStart = calendar.startOfDay(for: date)
            
            let hourlyForecast = HourlyForecast(timestamp: timestamp, temperature: temperature, description: description)
            
            if generalForcasts[dayStart] == nil {
                generalForcasts[dayStart] = DailyForecast(date: dayStart)
            }
            
            generalForcasts[dayStart]?.addHourlyForecast(hourlyForecast)
        }
        
        return Array(generalForcasts.values).sorted { $0.date < $1.date }
    }
    
    private func buildUrl() -> String {
        "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=5498a883757fe616d4bbaead3bce2724"
    }
    
    func formatTime(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeFormatter.timeZone = TimeZone.current

        return timeFormatter.string(from: date)
    }
}


final class DailyForecast: Identifiable {
    let id = UUID()
    let date: Date
    var hourlyForecasts: [HourlyForecast] = []
    var minTemperature = Double.greatestFiniteMagnitude
    var maxTemperature = Double.leastNormalMagnitude
    
    init(date: Date) {
        self.date = date
    }
    
    func addHourlyForecast(_ forecast: HourlyForecast) {
        hourlyForecasts.append(forecast)
        minTemperature = min(minTemperature, forecast.temperature)
        maxTemperature = max(maxTemperature, forecast.temperature)
    }
    
    func getDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, M/d"
        return dateFormatter.string(from: date)
    }
}

struct HourlyForecast: Identifiable {
    let id = UUID()
    let timestamp: TimeInterval
    let temperature: Double
    let description: String
    
    func getTime() -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}

func formatFahrenheit(_ kelvin: Double) -> String {
    let celsius = kelvin - 273.15
    return "\(Int(celsius * 9 / 5 + 32)) °F"
}
