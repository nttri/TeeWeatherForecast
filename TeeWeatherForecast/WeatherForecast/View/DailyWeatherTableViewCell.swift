//
//  DailyWeatherTableViewCell.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 10/08/2022.
//

import UIKit
import Accessibility

final class DailyWeatherTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var dateLbl: UILabel!
    private var avgTempLbl: UILabel!
    private var pressureLbl: UILabel!
    private var humidityLbl: UILabel!
    private var descriptionLbl: UILabel!
    private var weatherImgView: UIImageView!
    var accessibilityCustomContent: [AXCustomContent]!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Initialisers
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    func configure(with dailyWeatherData: DailyWeatherData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = K.InApp.app_date_format
        let date = Date(timeIntervalSince1970: dailyWeatherData.dt)
        dateLbl.text = String(format: K.InApp.app_date_info, dateFormatter.string(from: date))
        
        let avgDailyTemperature = Int((dailyWeatherData.temp.min + dailyWeatherData.temp.max) / 2)
        avgTempLbl.text = String(format: K.InApp.app_average_temperature_info, avgDailyTemperature)
        
        pressureLbl.text = String(format: K.InApp.app_pressure_info, dailyWeatherData.pressure)
        
        humidityLbl.text = String(format: K.InApp.app_humidity_info, dailyWeatherData.humidity)
        
        let description = dailyWeatherData.weather.first?.description ?? ""
        descriptionLbl.text = String(format: K.InApp.app_description_info, description)
        
        let imgName = dailyWeatherData.weather.first?.icon ?? ""
        weatherImgView.image = UIImage(named: imgName)
    }
}

// MARK: - AXCustomContentProvider

extension DailyWeatherTableViewCell: AXCustomContentProvider {
    
    override var accessibilityLabel: String? {
        get {
            let text: String = (dateLbl.text ?? "") + ", "
                             + (avgTempLbl.text ?? "") + ", "
                             + (pressureLbl.text ?? "") + ", "
                             + (humidityLbl.text ?? "") + ", "
                             + (descriptionLbl.text ?? "")
            return text
        }
        set {}
    }
}

// MARK: - Configuration

private extension DailyWeatherTableViewCell {
    
    func buildDynamicLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }
    
    func setupUI() {
        contentView.backgroundColor = .systemGray4
        
        weatherImgView = UIImageView()
        weatherImgView.contentMode = .scaleAspectFit
        addSubview(weatherImgView)
        weatherImgView.translatesAutoresizingMaskIntoConstraints = false
        weatherImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        weatherImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        weatherImgView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        weatherImgView.heightAnchor.constraint(equalToConstant: 64).isActive = true
                
        dateLbl = buildDynamicLabel()
        addSubview(dateLbl)
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        dateLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        dateLbl.trailingAnchor.constraint(equalTo: weatherImgView.leadingAnchor, constant: -10).isActive = true
        
        avgTempLbl = buildDynamicLabel()
        addSubview(avgTempLbl)
        avgTempLbl.translatesAutoresizingMaskIntoConstraints = false
        avgTempLbl.topAnchor.constraint(equalTo: dateLbl.bottomAnchor, constant: 10).isActive = true
        avgTempLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        avgTempLbl.trailingAnchor.constraint(equalTo: weatherImgView.leadingAnchor, constant: -10).isActive = true
        
        pressureLbl = buildDynamicLabel()
        addSubview(pressureLbl)
        pressureLbl.translatesAutoresizingMaskIntoConstraints = false
        pressureLbl.topAnchor.constraint(equalTo: avgTempLbl.bottomAnchor, constant: 10).isActive = true
        pressureLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        pressureLbl.trailingAnchor.constraint(equalTo: weatherImgView.leadingAnchor, constant: -10).isActive = true
        
        humidityLbl = buildDynamicLabel()
        addSubview(humidityLbl)
        humidityLbl.translatesAutoresizingMaskIntoConstraints = false
        humidityLbl.topAnchor.constraint(equalTo: pressureLbl.bottomAnchor, constant: 10).isActive = true
        humidityLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        humidityLbl.trailingAnchor.constraint(equalTo: weatherImgView.leadingAnchor, constant: -10).isActive = true
        
        descriptionLbl = buildDynamicLabel()
        addSubview(descriptionLbl)
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        descriptionLbl.topAnchor.constraint(equalTo: humidityLbl.bottomAnchor, constant: 10).isActive = true
        descriptionLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        descriptionLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        descriptionLbl.trailingAnchor.constraint(equalTo: weatherImgView.leadingAnchor, constant: -10).isActive = true
    }
}
