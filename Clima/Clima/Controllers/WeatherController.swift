//
//  ViewController.swift
//  Clima
//
//  Created by Paulo Roberto on 28/03/25.
//

import CoreLocation
import UIKit

class WeatherController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var cityLabel: UILabel!

    var weatherRepo = WeatherRepository()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        searchTextField.delegate = self
        weatherRepo.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

    }

    @IBAction func onTapLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}

extension WeatherController: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        if let userLocation = locations.last {
            weatherRepo.fetchWeather(
                latitude: userLocation.coordinate.latitude,
                longitute: userLocation.coordinate.longitude)
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("unable to fetch data")
    }

}

//MARK: - UiTextFieldDelegate Logic
extension WeatherController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Insert a city name"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            cityLabel.text = text
            textField.text = ""
            weatherRepo.fetchWeather(city: text)
        }
    }
}

//MARK: - WeatherDelegate Logic
extension WeatherController: WeatherDelegate {

    func updateWithWeatherData(_ weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = String(
                format: "%.0f ºC", weatherData.main.temp)
            self.cityLabel.text = weatherData.name

        }

    }

    func onErrorFetchingWeather() {
        DispatchQueue.main.async {
            self.cityLabel.text = "Failed fetching weather, please try again."
        }
    }

}
