//
//  MainTabBarController.swift
//  TeeWeatherForecast
//
//  Created by tringuyen on 16/10/2022.
//

import UIKit

protocol TabBarCoordinating: AnyObject {
    var weatherForecastNavigationController: UINavigationController { get }
    var airPollutionNavigationController: UINavigationController { get }
    
    func viewDidLoad()
}

final class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    weak var coordinator: TabBarCoordinating!
    
    var weatherForecastNavigationController: UINavigationController {
        coordinator.weatherForecastNavigationController
    }
    
    var airPollutionNavigationController: UINavigationController {
        coordinator.airPollutionNavigationController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Helpers

private extension MainTabBarController {
    
    func configure() {
        tabBar.tintColor = .orange
        tabBar.backgroundColor = .white
        
        setupViewControllers()
    }
    
    func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.isHidden = true
        return navController
    }
    
    func setupViewControllers() {
        let weatherForecastViewController = WeatherForecastViewController()
        weatherForecastViewController.presenter = WeatherForecastPresenter(display: weatherForecastViewController)
        
        let airPollutionViewController = AirPollutionViewController()
        airPollutionViewController.presenter = AirPollutionPresenter(display: airPollutionViewController)
        
        let weatherForecastNavigationController = createNavController(
            for: weatherForecastViewController,
            title: K.InApp.weather_forecast_title,
            image: UIImage(systemName: "cloud.sun.fill")!
        )
        let airPollutionNavigationController = createNavController(
            for: airPollutionViewController,
            title: K.InApp.air_pollution_title,
            image: UIImage(systemName: "aqi.medium")!
        )
        
        viewControllers = [
            weatherForecastNavigationController,
            airPollutionNavigationController
        ]
    }
}
