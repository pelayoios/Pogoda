//
//  AirQualityData.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/25/21.
//

import Foundation

struct AirQualityData: Codable {
    let list: [List]
}

struct List: Codable {
    let dt: Double
    let main: Main
}

struct Main: Codable {
    let aqi: Float
}
