//
//  AirPollution.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 11/08/2022.
//

import Foundation

struct AirPollution: Decodable {
    let list: [AirPollutionData]
}

struct AirPollutionData: Decodable {
    let main: AirQualityIndex
    let components: AirPollutionComponents
}

struct AirQualityIndex: Decodable {
    let aqi: Float
}

struct AirPollutionComponents: Decodable {
    let co: Float
    let no2: Float
    let o3: Float
    let pm2_5: Float
    let pm10: Float
}

enum AirPollutionIndexType {
    case o3(value: Float)
    case no2(value: Float)
    case co(value: Float)
    case pm2_5(value: Float)
    case pm10(value: Float)
    
    enum Level {
        case bad
        case medium
        case good
    }
    
    /// This level is base on `https://en.wikipedia.org/wiki/Air_quality_index`
    var level: Level {
        switch self {
        case .o3(let value):
            switch value {
            case 0..<101: return .good
            case 101..<209: return .medium
            default: return .bad
            }
        case .no2(let value):
            switch value {
            case 0..<81: return .good
            case 81..<281: return .medium
            default: return .bad
            }
        case .co(let value):
            switch value {
            case 0..<2: return .good
            case 2..<17: return .medium
            default: return .bad
            }
        case .pm2_5(let value):
            switch value {
            case 0..<61: return .good
            case 61..<121: return .medium
            default: return .bad
            }
        case .pm10(let value):
            switch value {
            case 0..<101: return .good
            case 101..<301: return .medium
            default: return .bad
            }
        }
    }
    
    var description: String {
        switch self {
        case .o3(let value):
            return "O3: \(value)"
        case .no2(let value):
            return "NO2: \(value)"
        case .co(let value):
            return "CO: \(value)"
        case .pm2_5(let value):
            return "PM2.5: \(value)"
        case .pm10(let value):
            return "PM10: \(value)"
        }
    }
}
