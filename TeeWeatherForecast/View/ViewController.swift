//
//  ViewController.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 09/08/2022.
//

import UIKit

protocol ViewControllerProtocol: class {
    func onDailyWeatherDataReceived(with dailyWeatherData: [DailyWeatherData])
    func showAlert(with errorType: AppError)
}

final class ViewController: UIViewController {
    
    var presenter:WeatherForecastPresenterProtocol!
    private var searchBar:UISearchBar!
    private var cancelBtn:UIButton!
    private var tableView:UITableView!
    private var dailyWeatherData:[DailyWeatherData] = []
    private let kCellName:String = "DailyWeatherTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        let headerView = UIView()
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        let titleLbl = UILabel()
        titleLbl.text = K.app_title
        titleLbl.font = .boldSystemFont(ofSize: 18)
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        titleLbl.isAccessibilityElement = false
        headerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        titleLbl.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        
        cancelBtn = UIButton()
        cancelBtn.setTitle(K.app_button_cancel, for: .normal)
        cancelBtn.setTitleColor(.systemBlue, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        cancelBtn.accessibilityHint = K.app_cancel_btn_accessibility_hint
        headerView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 10).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        cancelBtn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        
        searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = K.app_searchbar_placeholder
        searchBar.accessibilityHint = K.app_searchbar_accessibility_hint
        searchBar.delegate = self
        headerView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 10).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: cancelBtn.leadingAnchor, constant: -10).isActive = true
        
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
    
    @objc private func cancelBtnTapped() {
        view.endEditing(true)
    }
}

//MARK: ViewControllerProtocol
extension ViewController: ViewControllerProtocol {
    func onDailyWeatherDataReceived(with dailyWeatherData: [DailyWeatherData]) {
        self.dailyWeatherData = dailyWeatherData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(with errorType: AppError) {
        let alert = UIAlertController(title: K.app_alert_title, message: errorType.description, preferredStyle: .alert)
        let action = UIAlertAction(title: K.app_ok_button, style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let cityName = searchBar.text ?? ""
        self.presenter.startSearch(with: cityName)
    }
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCellName, for: indexPath) as? DailyWeatherTableViewCell, dailyWeatherData.count > 0 else {
            return UITableViewCell()
        }
        cell.setupCell(with: dailyWeatherData[indexPath.row])
        return cell
    }
}

