//
//  WeatherForecast.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

enum AppError: Error {
    case cityNameTooShort
    case cityNotFound
    case processDataFailed
    case serverError
    
    var description: String {
        switch self {
        case .cityNameTooShort:
            return K.app_error_cityname_too_short
        case .cityNotFound:
            return K.app_error_city_not_found
        case .processDataFailed:
            return K.app_error_process_data_fail
        case .serverError:
            return K.app_error_server_fail
        }
    }
}

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
