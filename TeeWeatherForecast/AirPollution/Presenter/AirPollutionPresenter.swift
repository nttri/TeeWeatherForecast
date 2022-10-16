//
//  AirPollutionPresenter.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 11/08/2022.
//

import Foundation

protocol AirPollutionPresenting: AnyObject {
    func displayDidLoad()
}

final class AirPollutionPresenter {
    
    // MARK: - Properties
    
    private weak var display: AirPollutionDisplaying?
    
    // MARK: - Initialisers
    
    init(display: AirPollutionDisplaying) {
        self.display = display
    }
}

// MARK: - AirPollutionPresenting

extension AirPollutionPresenter: AirPollutionPresenting {
    func displayDidLoad() {
        self.loadAirPollutionData()
    }
}

// MARK: - Helpers

private extension AirPollutionPresenter {
    
    private func loadAirPollutionData() {
        let airPollutionUrl: String = K.Networking.base_url + K.Networking.air_pollution_path
        guard var urlComponent = URLComponents(string: airPollutionUrl) else {
            return
        }
        
        urlComponent.queryItems = [
            URLQueryItem(name: K.Networking.api_field_longitude, value: "10.762622"),
            URLQueryItem(name: K.Networking.api_field_latitude, value: "10.660172"),
            URLQueryItem(name: K.Networking.api_field_appid, value: K.Networking.api_default_appid),
        ]
        
        NetworkManager.sharedInstance.requestAirPollutionInfo(
            with: urlComponent.url!,
            completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.handleAirPollutionData(with: data)
                case .failure(let error):
                    self?.handleFailure(with: error)
                }
            }
        )
    }
    
    private func handleAirPollutionData(with data: AirPollution) {
        DispatchQueue.main.async {
            self.display?.onAirPollutionDataReceived(with: data)
        }
    }
    
    private func handleFailure<T: AppError>(with error: T) {
        DispatchQueue.main.async {
            self.display?.showAlert(with: error)
        }
    }
}
