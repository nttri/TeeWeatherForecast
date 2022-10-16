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

enum NetworkingError: AppError {
    case api
    case network
    
    var description: String {
        switch self {
        case .api:
            return K.ErrorMessage.process_data_fail
        case .network:
            return K.ErrorMessage.server_fail
        }
    }
}
