//
//  Constants.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

struct K {
    
    // MARK: - In-app
    
    struct InApp {
        static let app_searchbar_placeholder: String         = "City name (Eg: London, Paris)"
        static let app_button_cancel: String                 = "Cancel"
        static let app_min_cityname_length: Int              = 3
        static let app_date_format: String                   = "EEE, dd MMM yyyy"
        static let app_date_info: String                     = "Date: %@"
        static let app_average_temperature_info: String      = "Average Temperature: %d°C"
        static let app_pressure_info: String                 = "Pressure: %d"
        static let app_humidity_info: String                 = "Humidity: %d%%"
        static let app_description_info: String              = "Description: %@"
        static let app_ok_button: String                     = "OK"
        static let app_alert_title: String                   = "Alert"
        static let weather_forecast_title: String            = "Weather Forecast"
        static let air_pollution_title: String               = "Air Pollution"
    }
    
    // MARK: - Networking
    
    struct Networking {
        static let base_url: String              = "https://api.openweathermap.org"
        static let weather_forecast_path: String = "/data/2.5/forecast/daily"
        static let air_pollution_path: String    = "/data/2.5/air_pollution"
        
        static let api_field_cityname: String    = "q"
        static let api_field_appid: String       = "appid"
        static let api_field_cnt: String         = "cnt"
        static let api_field_units: String       = "units"
        static let api_field_latitude: String    = "lat"
        static let api_field_longitude: String   = "lon"
        
        static let api_default_appid: String     = "60c6fbeb4b93ac653c492ba806fc346d"
        static let api_default_cityname: String  = "saigon"
        static let api_default_cnt: Int          = 7
        static let api_default_units: String     = "metric"
    }
    
    // MARK: - ErrorMessage
    
    struct ErrorMessage {
        static let cityname_too_short: String = "City name must have at least 3 characters!"
        static let city_not_found: String     = "Can't found this city!"
        static let process_data_fail: String  = "Failed on data processing!"
        static let server_fail: String        = "Connect to server failed.\n Please try again later!"
    }
    
    // MARK: - AppMessage
    
    struct AppMessage {
        static let searchbar_cancel_accessibility_hint: String = "Hint: Cancel editing search bar."
        static let searchbar_accessibility_hint: String        = "Hint: Enter the city name you want to search."
    }
}
