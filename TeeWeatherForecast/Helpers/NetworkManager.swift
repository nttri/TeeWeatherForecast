//
//  NetworkManager.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import Foundation

final class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    func requestWeatherForecastInfo(
        with url: URL,
        completionHandler: @escaping (_ data: [DailyWeatherData], _ errorType: AppError?) -> Void
    ) {
        let task = session.dataTask(with: url) { data, _, error in
            guard let sData = data, error == nil else {
                completionHandler([], .serverError)
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(WeatherForecast.self, from: sData)
                completionHandler(decodedData.list, nil)
            } catch {
                completionHandler([], .processDataFailed)
            }
        }
        task.resume()
    }
}
