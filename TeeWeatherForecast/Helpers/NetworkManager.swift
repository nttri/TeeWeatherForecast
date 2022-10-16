//
//  NetworkManager.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

typealias WeatherForecastInfoCompletion = (Result<[DailyWeatherData], NetworkingError>) -> Void
typealias AirPollutionInfoCompletion = (Result<AirPollution, NetworkingError>) -> Void

final class NetworkManager {
    
    // MARK: Properties
    
    static let sharedInstance = NetworkManager()
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    // MARK: Initialisers
    
    private init() {}
    
    func requestWeatherForecastInfo(
        with url: URL,
        completion: @escaping WeatherForecastInfoCompletion
    ) {
        let task = session.dataTask(with: url) { data, _, error in
            guard let sData = data, error == nil else {
                completion(.failure(.network))
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(WeatherForecast.self, from: sData)
                completion(.success(decodedData.list))
            } catch {
                completion(.failure(.api))
            }
        }
        task.resume()
    }
    
    func requestAirPollutionInfo(
        with url: URL,
        completion: @escaping AirPollutionInfoCompletion
    ) {
        let task = session.dataTask(with: url) { data, _, error in
            guard let sData = data, error == nil else {
                completion(.failure(.network))
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(AirPollution.self, from: sData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.api))
            }
        }
        task.resume()
    }
}
