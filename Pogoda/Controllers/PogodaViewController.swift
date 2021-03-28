//
//  ViewController.swift
//  Pogoda
//
//  Created by Miguel Pelayo Mercado Caram on 3/23/21.
//

import UIKit
import CoreLocation

class PogodaViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
   
    
    @IBOutlet weak var airQualitySlider: UISlider!
    
    @IBOutlet weak var airQualityLabel: UILabel!
    
    //details outlets
    
    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    
    let locationManager = CLLocationManager()
    
    
    var weatherManager = WeatherManager()
    
    var airQualityManager = AirQualityManager()
    
    var gradientImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        
        weatherManager.delegate = self
        
        airQualityManager.delegate = self
        
        gradientImage = UIImage.gradientImage(with: self.airQualitySlider.frame,
                                              colors: [UIColor(hue: 0.5, saturation: 1, brightness: 0.94, alpha: 1.0).cgColor, UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor],
                                                        locations: nil)

        self.airQualitySlider.setMinimumTrackImage(gradientImage, for: .normal)
        self.airQualitySlider.setMaximumTrackImage(gradientImage, for: .normal)
        
       
        
        
        
    }
    

    

}

extension PogodaViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Enter a city please..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.updateWeatherByCity(location: city)
            airQualityManager.updateAirByCity(location: city)
        }
        
        searchTextField.text = ""
    }
    
}

extension PogodaViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.timeZone
            
            //details Outlets
            
            self.highTempLabel.text = "\(weather.maxString)°"
            self.lowTempLabel.text = "\(weather.minString)°"
            
            self.sunriseLabel.text = weather.dailySunriseTimeString
            self.sunsetLabel.text = weather.dailySunsetTimeString
            
            self.windSpeedLabel.text = weather.windSpeedString + " km/h"
            self.feelsLikeLabel.text = "\(weather.feelsLikeString)°"
            

        }
    }

    func didUpdateLocationName(location: CLPlacemark) {
        DispatchQueue.main.async {
            self.cityLabel.text = location.locality
        }
    }
    
      func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Loading Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }



}

extension PogodaViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            weatherManager.fetchWeather(withLocation: location.coordinate)
            weatherManager.getCurrentLocationName(location: location)
            
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension PogodaViewController: AirQualityProtocol {
    func didUpdateAirQualityIndex(_ airQualityManager: AirQualityManager, airQuality: AirQualityModel) {
//        DispatchQueue.main.async {
//            let gradientImage = UIImage.gradientImage(with: self.airQualityIndexProgressViewBar.frame,
//                                                    colors: [UIColor.green.cgColor, UIColor.red.cgColor],
//                                                    locations: nil)
//            //self.airQualityIndexProgressViewBar.progressImage = gradientImage!
//            self.airQualityIndexProgressViewBar.progressTintColor = .green
              
//            print(airIndex)
//            self.airQualityIndexProgressViewBar.progress = airIndex
           //self.airQualitySlider.value = airIndex
//
//            if airIndex <= 0.3 {
//                self.airQualityIndexProgressViewBar.progressTintColor = .green
//                self.airQualityLabel.text = "Air Quality: Good"
//                self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
//            } else if airIndex > 0.3 && airIndex < 0.7 {
//                self.airQualityIndexProgressViewBar.progressTintColor = .yellow
//                self.airQualityLabel.text = "Air Quality: Moderate"
//                self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
//            }else {
//                self.airQualityIndexProgressViewBar.progressTintColor = .red
//                self.airQualityLabel.text = "Air Quality: Poor"
//                self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
//            }
//
//        }
        
        DispatchQueue.main.async {
            let airIndex = airQuality.airQualityIndex / 6
            self.airQualitySlider.value = airIndex
            
            if airIndex <= 0.3 {
                         
                         self.airQualityLabel.text = "Air Quality: Good"
                         self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
                     } else if airIndex > 0.3 && airIndex < 0.7 {
                         
                         self.airQualityLabel.text = "Air Quality: Moderate"
                         self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
                     }else {
                         self.airQualityLabel.text = "Air Quality: Poor"
                         self.airQualityLabel.font = self.airQualityLabel.font.withSize(20)
                     }
         
                 }
            
        }
    }
    
    


fileprivate extension UIImage {
    static func gradientImage(with bounds: CGRect,
                            colors: [CGColor],
                            locations: [NSNumber]?) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = 8
        gradientLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

