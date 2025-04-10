//
//  ViewController.swift
//  Clima
//
//  Created by Paulo Roberto on 28/03/25.
//

import UIKit

class WeatherController: UIViewController, UITextFieldDelegate, WeatherDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherRepo = WeatherRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherRepo.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Insert a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            cityLabel.text = text
            textField.text = ""
            weatherRepo.fetchWeather(city: text)
        }
    }
    
    func updateWithWeatherData(_ weatherData: WeatherData) {
        DispatchQueue.main.async{
            self.temperatureLabel.text = String(format: "%.0f ºC", weatherData.main.temp)
            
        }

    }
    
    func onErrorFetchingWeather(){
        DispatchQueue.main.async{
            self.cityLabel.text = "Failed fetching weather, please try again."
        }
    }
}

