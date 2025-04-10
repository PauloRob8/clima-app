//
//  WeatherRepository.swift
//  Clima
//
//  Created by Paulo Roberto on 04/04/25.
//

import Foundation

protocol WeatherDelegate {

    func updateWithWeatherData(_ weatherData: WeatherData)

    func onErrorFetchingWeather()

}

struct WeatherRepository {

    var delegate: WeatherDelegate?

    func getApiKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        {
            if let dict = NSDictionary(contentsOfFile: path)
                as? [String: String]
            {
                let apiKey = dict["API_KEY"]
                return apiKey
            } else {
                return nil
            }

        } else {
            return nil
        }
    }

    func fetchWeather(city: String) {
        if let apiKey = getApiKey() {
            if let url = URL(
                string:
                    "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
            ) {

                let urlSession = URLSession(configuration: .default)

                let task = urlSession.dataTask(
                    with: url,
                    completionHandler: requestHandler(data:response:error:))

                task.resume()

            }

        }

    }

    func requestHandler(
        data: Data?, response: URLResponse?, error: (any Error)?
    ) {
        if error != nil {
            delegate?.onErrorFetchingWeather()
            return
        }
        if let safeData = data {
            let decoder = JSONDecoder()
            do {
                let weatherData = try decoder.decode(
                    WeatherData.self, from: safeData)
                delegate?.updateWithWeatherData(weatherData)
                print(weatherData)

            } catch {
                delegate?.onErrorFetchingWeather()
                return
            }

        }

    }

}
