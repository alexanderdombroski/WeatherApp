//
//  WeatherDayView.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/25/24.
//

import SwiftUI

struct WeatherDayView: View {
    let dailyForecast: DailyForecast
    
    let topColor = UIColor(red: 0.4, green: 0.1, blue: 1, alpha: 1)
    let bottomColor = UIColor(red: 0.7, green: 0.1, blue: 1, alpha: 1)
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(topColor), Color(bottomColor)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text(dailyForecast.getDate())
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                HStack {
                    Text(formatFahrenheit(dailyForecast.minTemperature))
                        .foregroundStyle(.white)
                        .font(.title)
                    Text(formatFahrenheit(dailyForecast.maxTemperature))
                        .foregroundStyle(.white)
                        .font(.title)
                }
                ForEach(dailyForecast.hourlyForecasts, id: \.id) { forecast in
                    HStack {
                        Text(forecast.getTime())
                            .font(.title2)
                            .foregroundStyle(.white)
                        Spacer()
                        Text(forecast.description)
                            .foregroundStyle(.white)
                            .font(.title2)
                        Spacer()
                        Text(formatFahrenheit(forecast.temperature))
                            .foregroundStyle(.white)
                            .font(.title2)
                    }
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                }
            }
        }
    }
}





// -- Just for the preview of this page
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date(timeIntervalSince1970: 1716660000)
        let dailyForecast = DailyForecast(date: date)
        
        let hourlyForecasts: [HourlyForecast] = [
            HourlyForecast(timestamp: Date().timeIntervalSince1970 + 3600, temperature: 320.0, description: "Sunny"),
            HourlyForecast(timestamp: Date().timeIntervalSince1970 + 7200, temperature: 280.5, description: "Partly Cloudy"),
            HourlyForecast(timestamp: Date().timeIntervalSince1970 + 10800, temperature: 330.0, description: "Cloudy"),
            HourlyForecast(timestamp: Date().timeIntervalSince1970 + 14400, temperature: 300.5, description: "Rainy"),
            HourlyForecast(timestamp: Date().timeIntervalSince1970 + 18000, temperature: 300.0, description: "Thunderstorms")
        ]
        hourlyForecasts.forEach { dailyForecast.addHourlyForecast($0) }
    
        return WeatherDayView(dailyForecast: dailyForecast)
    }
}
