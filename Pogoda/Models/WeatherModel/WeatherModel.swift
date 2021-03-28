//
//  WeatherModel.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/23/21.
//

import Foundation

struct WeatherModel {
    let latitude: Double
    let longitude: Double
    let currentDay: Double
    let sunrise: Double
    let sunset: Double
    let currentTemperature: Double
    let feelsLike: Double
    let windSpeed: Double
    let currentIconId: Int
    let timeZone: String
    let maxTemp: Double
    let minTemp: Double
    
    var temperatureString: String {
        return String(format: "%.0f", currentTemperature)
    }
    var maxString: String {
        return String(format: "%.0f", maxTemp)
    }
    var minString: String {
        return String(format: "%.0f", minTemp)
    }
    
    var feelsLikeString : String {
        return String(format: "%.0f", feelsLike)
    }
    
    var windSpeedString : String {
        return String(format: "%.0f", windSpeed)
    }
    
    var dailySunriseTimeString : String {
        let time = NSDate(timeIntervalSince1970: sunrise)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        return timeFormatter.string(from: time as Date)
    }
    
    
    var dailySunsetTimeString : String {
        let time = NSDate(timeIntervalSince1970: sunset)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        return timeFormatter.string(from: time as Date)
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputData = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputData)
    }
    
    
    
    var conditionName: String {
        switch currentIconId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
}
