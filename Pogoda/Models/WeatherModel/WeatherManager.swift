//
//  WeatherManager.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/24/21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didUpdateLocationName(location: CLPlacemark)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&exclude=hourly&units=metric&appid=\(valueForAPIKey(named: "API_KEY"))"
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(withLocation location: CLLocationCoordinate2D) {
        let urlString = "\(weatherURL)&lat=\(location.latitude)&lon=\(location.longitude)"
        performRequest(urlString: urlString)
    }
    
    func updateWeatherByCity(location: String) {
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
    
    func getCurrentLocationName(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let placemark = placemarks?[0] {
                self.delegate?.didUpdateLocationName(location: placemark)
            }
        }
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(weatherData: safeData) {
                    self.delegate?.didUpdateWeather(self, weather: weather)
                }
           
            }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        

        let decoder = JSONDecoder()
        
        do {
            let decode = try decoder.decode(WeatherData.self, from: weatherData)
            
            let lat = decode.lat
            let lon = decode.lon
            let day = decode.current.dt
            let sunrise = decode.current.sunrise
            let sunset = decode.current.sunset
            let temp = decode.current.temp
            let feelsLike = decode.current.feels_like
            let windSpeed = decode.current.wind_speed
            let conditionId = decode.current.weather[0].id
            let description = decode.current.weather[0].description
            let timeZone = decode.timezone
            let maxTemp = decode.daily[0].temp.max
            let minTemp = decode.daily[0].temp.min
            
            let weather = WeatherModel(latitude: lat, longitude: lon, currentDay: day, sunrise: sunrise, sunset: sunset, currentTemperature: temp, feelsLike: feelsLike, windSpeed: windSpeed, currentIconId: conditionId, timeZone: timeZone, maxTemp: maxTemp, minTemp: minTemp)
            
            print(weather)
            return weather
            
        } catch {
            return nil
        }
    }
}
