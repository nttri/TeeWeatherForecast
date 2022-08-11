//
//  Errors.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

protocol AppError: Error, Equatable {
    var description: String { get }
}

enum CityInfoError: AppError {
    case cityNameTooShort
    case cityNotFound
    
    var description: String {
        switch self {
        case .cityNameTooShort:
            return K.ErrorMessage.app_error_cityname_too_short
        case .cityNotFound:
            return K.ErrorMessage.app_error_city_not_found
        }
    }
}

enum WeatherForecastRequestError: AppError {
    case api
    case network
    
    var description: String {
        switch self {
        case .api:
            return K.ErrorMessage.app_error_process_data_fail
        case .network:
            return K.ErrorMessage.app_error_server_fail
        }
    }
}
