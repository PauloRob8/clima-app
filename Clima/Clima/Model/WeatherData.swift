//
//  WeatherData.swift
//  Clima
//
//  Created by Paulo Roberto on 09/04/25.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let coord: Coordinates
    
}

struct Main: Codable{
    let temp: Double
}

struct Coordinates: Codable{
    let lon: Double
    let lat: Double
}
