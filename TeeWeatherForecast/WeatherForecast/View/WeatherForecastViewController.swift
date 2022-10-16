//
//  ViewController.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 09/08/2022.
//

import UIKit

protocol WeatherForecastDisplaying: Display {
    func onDailyWeatherDataReceived(with dailyWeatherData: [DailyWeatherData])
    func showAlert<T: AppError>(with error: T)
}

final class WeatherForecastViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter:WeatherForecastPresenting!
    private var searchBar:UISearchBar!
    private var cancelButton:UIButton!
    private var tableView:UITableView!
    private var dailyWeatherData:[DailyWeatherData] = []
    private let kCellName:String = "DailyWeatherTableViewCell"
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.displayDidLoad()
    }
}

// MARK: - Conformance

// MARK: WeatherForecastDisplaying

extension WeatherForecastViewController: WeatherForecastDisplaying {
    
    func onDailyWeatherDataReceived(with dailyWeatherData: [DailyWeatherData]) {
        self.dailyWeatherData = dailyWeatherData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: UISearchBarDelegate

extension WeatherForecastViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cityName = searchBar.text ?? ""
        self.presenter.startSearch(with: cityName)
    }
}

// MARK: UITableViewDelegate

extension WeatherForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource

extension WeatherForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: kCellName, for: indexPath) as? DailyWeatherTableViewCell,
                dailyWeatherData.count > 0 else {
            return UITableViewCell()
        }
        cell.configure(with: dailyWeatherData[indexPath.row])
        return cell
    }
}

// MARK: - Configuration

private extension WeatherForecastViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        let headerView = UIView()
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = K.InApp.app_title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.isAccessibilityElement = false
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        
        cancelButton = UIButton()
        cancelButton.setTitle(K.InApp.app_button_cancel, for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.accessibilityHint = K.AppMessage.searchbar_cancel_accessibility_hint
        headerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = K.InApp.app_searchbar_placeholder
        searchBar.accessibilityHint = K.AppMessage.searchbar_accessibility_hint
        searchBar.delegate = self
        headerView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10).isActive = true
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: kCellName)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    @objc func cancelButtonTapped() {
        view.endEditing(true)
    }
}
