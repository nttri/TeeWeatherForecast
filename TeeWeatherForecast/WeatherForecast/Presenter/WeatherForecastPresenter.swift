//
//  WeatherForecastPresenter.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

protocol WeatherForecastPresenting: AnyObject {
    func displayDidLoad()
    func startSearch(with cityName:String)
}

final class WeatherForecastPresenter {
    
    // MARK: - Properties
    
    private weak var display: WeatherForecastDisplaying?
    
    // MARK: - Initialisers
    
    init(display: WeatherForecastDisplaying) {
        self.display = display
    }
}

// MARK: - Conformance

// MARK: WeatherForecastPresenting

extension WeatherForecastPresenter: WeatherForecastPresenting {
    
    func displayDidLoad() {
        self.loadDailyWeatherData(with: K.Networking.api_default_cityname)
    }
    
    func startSearch(with cityName: String) {
        guard isValid(cityName: cityName) else {
            return handleFailure(with: CityInfoError.cityNameTooShort)
        }
        self.loadDailyWeatherData(with: cityName)
    }
}

// MARK: - Helpers

private extension WeatherForecastPresenter {
    
    private func isValid(cityName: String) -> Bool {
        return cityName.count >= K.InApp.app_min_cityname_length
    }
    
    private func loadDailyWeatherData(with cityName:String) {
        let weatherForecastUrl: String = K.Networking.base_url + K.Networking.weather_forecast_path
        guard var urlComponent = URLComponents(string: weatherForecastUrl) else {
            return
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: K.Networking.api_field_cityname, value: cityName),
            URLQueryItem(name: K.Networking.api_field_cnt, value: "\(K.Networking.api_default_cnt)"),
            URLQueryItem(name: K.Networking.api_field_appid, value: K.Networking.api_default_appid),
            URLQueryItem(name: K.Networking.api_field_units, value: K.Networking.api_default_units),
        ]
        
        NetworkManager.sharedInstance.requestWeatherForecastInfo(
            with: urlComponent.url!,
            completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.display?.onDailyWeatherDataReceived(with: data)
                case .failure(let error):
                    self?.handleFailure(with: error)
                }
            }
        )
    }
    
    private func handleFailure<T: AppError>(with error: T) {
        self.display?.showAlert(with: error)
    }
}
