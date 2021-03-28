//
//  AirQualityManager.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/25/21.
//

import Foundation
import CoreLocation

protocol AirQualityProtocol {
    func didUpdateAirQualityIndex(_ airQualityManager: AirQualityManager, airQuality: AirQualityModel)
    
}
struct AirQualityManager {
    
    
    let airQualityUrl = "https://api.openweathermap.org/data/2.5/air_pollution?&appid=\(valueForAPIKey(named: "API_KEY"))"
    
    var delegate: AirQualityProtocol?
    
    func fetchWeather(withLocation location: CLLocationCoordinate2D) {
        let urlString = "\(airQualityUrl)&lat=\(location.latitude)&lon=\(location.longitude)"
        performRequest(urlString: urlString)
    }
    func updateAirByCity(location: String) {
        CLGeocoder().geocodeAddressString(location) { placemarks, error in
            if error != nil {
                print("error") // This error when no internet and wrong location string!
                return
            }
            if let location = placemarks?[0].location {
                self.fetchWeather(withLocation: location.coordinate)
            }
            if let placemark = placemarks?[0] {
                print(placemark)
            }

        }
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                if let airQualityData = self.parseJSON(weatherData: safeData) {
                    self.delegate?.didUpdateAirQualityIndex(self, airQuality: airQualityData)
                }
           
            }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> AirQualityModel? {
        

        let decoder = JSONDecoder()
        
        do {
            let decode = try decoder.decode(AirQualityData.self, from: weatherData)
            
            let dt = decode.list[0].dt
            let airQuality = decode.list[0].main.aqi
            
            let airQualityIndex = AirQualityModel(dateTime: dt, airQualityIndex: airQuality)
            
            print(airQualityIndex)
            return airQualityIndex
            
        } catch {
            return nil
        }
    }
    
}
