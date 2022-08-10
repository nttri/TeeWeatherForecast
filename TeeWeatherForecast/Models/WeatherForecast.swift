//
//  WeatherForecast.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct TemperatureData: Decodable {
    let min: Float
    let max: Float
}

struct DailyWeatherData: Decodable {
    let dt: TimeInterval
    let temp: TemperatureData
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
}

struct WeatherForecast: Decodable {
    let list: [DailyWeatherData]
}
