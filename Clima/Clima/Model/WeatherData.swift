//
//  WeatherData.swift
//  Clima
//
//  Created by Paulo Roberto on 09/04/25.
//

import Foundation

struct WeatherData: Codable{
    let main: Main
    
}

struct Main: Codable{
    let temp: Double
}
