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
