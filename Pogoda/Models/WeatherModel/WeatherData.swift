//
//  WeatherData.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/23/21.
//

import Foundation

struct WeatherData: Codable {
    
    let lat: Double
    let lon: Double
    let timezone: String
    let current: Current
    let daily: [Daily]
}

struct Current: Codable {
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Daily: Codable {
    let temp: Temp
    
}

struct Temp: Codable {
    let min: Double
    let max: Double
}
