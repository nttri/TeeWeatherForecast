//
//  WeatherForecastPresenter.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

protocol MainWeatherForecastPresenting: AnyObject {
    func displayDidLoad()
    func startSearch(with cityName:String)
}

final class MainWeatherForecastPresenter {
    
    // MARK: - Properties
    
    private weak var display: MainWeatherForecastDisplaying?
    
    // MARK: - Initialisers
    
    init(display: MainWeatherForecastDisplaying) {
        self.display = display
    }
}

// MARK: - WeatherForecastPresenting

extension MainWeatherForecastPresenter: MainWeatherForecastPresenting {
    
    func displayDidLoad() {
        self.loadDailyWeatherData(with: K.InApp.app_default_cityname)
    }
    
    func startSearch(with cityName: String) {
        guard isValid(cityName: cityName) else {
            return handleFailure(with: CityInfoError.cityNameTooShort)
        }
        self.loadDailyWeatherData(with: cityName)
    }
}

// MARK: - Helpers

private extension MainWeatherForecastPresenter {
    
    private func isValid(cityName: String) -> Bool {
        return cityName.count >= K.InApp.app_min_cityname_length
    }
    
    private func loadDailyWeatherData(with cityName:String) {
        guard var urlComponent = URLComponents(string: K.Networking.app_api_url) else {
            return
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: K.Networking.app_api_field_cityname, value: cityName),
            URLQueryItem(name: K.Networking.app_api_field_cnt, value: "\(K.Networking.app_api_default_cnt)"),
            URLQueryItem(name: K.Networking.app_api_field_appid, value: K.Networking.app_api_default_appid),
            URLQueryItem(name: K.Networking.app_api_field_units, value: K.Networking.app_api_default_units),
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
