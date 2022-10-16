//
//  AirPollutionViewController.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 11/08/2022.
//

import UIKit

protocol AirPollutionDisplaying: Display {
    func onAirPollutionDataReceived(with airPollutionData: AirPollution)
    func showAlert<T: AppError>(with error: T)
}

final class AirPollutionViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter:AirPollutionPresenting!
    
    private var o3IndexLabel: UILabel!
    private var no2IndexLabel: UILabel!
    private var coIndexLabel: UILabel!
    private var pm25IndexLabel: UILabel!
    private var pm10IndexLabel: UILabel!
    private var aqiLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.displayDidLoad()
    }
}

// MARK: - Conformance

// MARK: AirPollutionDisplaying

extension AirPollutionViewController: AirPollutionDisplaying {
    
    func onAirPollutionDataReceived(with airPollutionData: AirPollution) {
        guard let data: AirPollutionData = airPollutionData.list.first else {
            return
        }
        o3IndexLabel.text = "O3: \(data.components.o3)"
        no2IndexLabel.text = "NO2: \(data.components.no2)"
        coIndexLabel.text = "CO: \(data.components.co)"
        pm25IndexLabel.text = "PM 2.5: \(data.components.pm2_5)"
        pm10IndexLabel.text = "PM 10: \(data.components.pm10)"
        aqiLabel.text = "AQI: \(data.main.aqi)"
    }
    
    func showAlert<T: AppError>(with error: T) {
        let alert = UIAlertController(
            title: K.InApp.app_alert_title,
            message: error.description,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: K.InApp.app_ok_button,
            style: .default,
            handler: nil
        )
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Configuration

private extension AirPollutionViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        let contentView = UIView()
        contentView.backgroundColor = .orange
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        contentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        contentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = K.InApp.air_pollution_title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.isAccessibilityElement = false
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        o3IndexLabel = UILabel()
        o3IndexLabel.font = .preferredFont(forTextStyle: .body)
        o3IndexLabel.textColor = .black
        o3IndexLabel.textAlignment = .center
        contentView.addSubview(o3IndexLabel)
        o3IndexLabel.translatesAutoresizingMaskIntoConstraints = false
        o3IndexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        o3IndexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        no2IndexLabel = UILabel()
        no2IndexLabel.font = .preferredFont(forTextStyle: .body)
        no2IndexLabel.textColor = .black
        no2IndexLabel.textAlignment = .center
        contentView.addSubview(no2IndexLabel)
        no2IndexLabel.translatesAutoresizingMaskIntoConstraints = false
        no2IndexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        no2IndexLabel.bottomAnchor.constraint(equalTo: o3IndexLabel.topAnchor, constant: -10).isActive = true
        
        coIndexLabel = UILabel()
        coIndexLabel.font = .preferredFont(forTextStyle: .body)
        coIndexLabel.textColor = .black
        coIndexLabel.textAlignment = .center
        contentView.addSubview(coIndexLabel)
        coIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        coIndexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        coIndexLabel.bottomAnchor.constraint(equalTo: no2IndexLabel.topAnchor, constant: -10).isActive = true

        pm25IndexLabel = UILabel()
        pm25IndexLabel.font = .preferredFont(forTextStyle: .body)
        pm25IndexLabel.textColor = .black
        pm25IndexLabel.textAlignment = .center
        contentView.addSubview(pm25IndexLabel)
        pm25IndexLabel.translatesAutoresizingMaskIntoConstraints = false
        pm25IndexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        pm25IndexLabel.topAnchor.constraint(equalTo: o3IndexLabel.bottomAnchor, constant: 10).isActive = true
        
        pm10IndexLabel = UILabel()
        pm10IndexLabel.font = .preferredFont(forTextStyle: .body)
        pm10IndexLabel.textColor = .black
        pm10IndexLabel.textAlignment = .center
        contentView.addSubview(pm10IndexLabel)
        pm10IndexLabel.translatesAutoresizingMaskIntoConstraints = false
        pm10IndexLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        pm10IndexLabel.topAnchor.constraint(equalTo: pm25IndexLabel.bottomAnchor, constant: 10).isActive = true
        
        aqiLabel = UILabel()
        aqiLabel.font = .boldSystemFont(ofSize: 16)
        aqiLabel.textColor = .black
        aqiLabel.textAlignment = .center
        contentView.addSubview(aqiLabel)
        aqiLabel.translatesAutoresizingMaskIntoConstraints = false
        aqiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        aqiLabel.topAnchor.constraint(equalTo: pm10IndexLabel.bottomAnchor, constant: 10).isActive = true
    }
}
