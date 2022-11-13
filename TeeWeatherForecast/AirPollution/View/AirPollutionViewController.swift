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
    
    private var o3IndexView: AirPollutionSingleIndexView!
    private var no2IndexView: AirPollutionSingleIndexView!
    private var coIndexView: AirPollutionSingleIndexView!
    private var pm25IndexView: AirPollutionSingleIndexView!
    private var pm10IndexView: AirPollutionSingleIndexView!
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
        o3IndexView.updateView(with: .o3(value: data.components.o3))
        no2IndexView.updateView(with: .no2(value: data.components.no2))
        coIndexView.updateView(with: .co(value: data.components.co))
        pm25IndexView.updateView(with: .pm2_5(value: data.components.pm2_5))
        pm10IndexView.updateView(with: .pm10(value: data.components.pm10))
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
        view.backgroundColor = .systemGray5
        
        let screenSize: CGRect = UIScreen.main.bounds
        let vScreenWidth: CGFloat = screenSize.width > screenSize.height ? screenSize.height : screenSize.width
        let contentWidth: CGFloat = vScreenWidth * 0.6
        let safeArea = view.safeAreaLayoutGuide
        let contentView = UIView()
        contentView.backgroundColor = .systemGray4
        contentView.layer.cornerRadius = contentWidth * 0.08
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // O3
        o3IndexView = AirPollutionSingleIndexView()
        contentView.addSubview(o3IndexView)
        o3IndexView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        o3IndexView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // NO2
        no2IndexView = AirPollutionSingleIndexView()
        contentView.addSubview(no2IndexView)
        no2IndexView.topAnchor.constraint(equalTo: o3IndexView.bottomAnchor, constant: 15).isActive = true
        no2IndexView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // CO
        coIndexView = AirPollutionSingleIndexView()
        contentView.addSubview(coIndexView)
        coIndexView.topAnchor.constraint(equalTo: no2IndexView.bottomAnchor, constant: 15).isActive = true
        coIndexView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // PM 2.5
        pm25IndexView = AirPollutionSingleIndexView()
        contentView.addSubview(pm25IndexView)
        pm25IndexView.topAnchor.constraint(equalTo: coIndexView.bottomAnchor, constant: 15).isActive = true
        pm25IndexView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // PM 10
        pm10IndexView = AirPollutionSingleIndexView()
        contentView.addSubview(pm10IndexView)
        pm10IndexView.topAnchor.constraint(equalTo: pm25IndexView.bottomAnchor, constant: 15).isActive = true
        pm10IndexView.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        
        // AQI
        aqiLabel = UILabel()
        aqiLabel.font = .boldSystemFont(ofSize: 25)
        aqiLabel.textColor = .black
        aqiLabel.textAlignment = .center
        contentView.addSubview(aqiLabel)
        aqiLabel.translatesAutoresizingMaskIntoConstraints = false
        aqiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        aqiLabel.topAnchor.constraint(equalTo: pm10IndexView.bottomAnchor, constant: 24).isActive = true
        aqiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    }
}
