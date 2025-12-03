//
//  AppEnvironment.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct AppEnvironment {
  var weatherManager: WeatherForecastManagerProtocol
  var offlineWeatherManager: OfflineWeatherManagerProtocol
  var networkManager: NetworkManagerProtocol
  var locationManager: LocationManagerProtocol
}

extension AppEnvironment {
  static let live = AppEnvironment(
    weatherManager: WeatherForecastManager(),
    offlineWeatherManager: OfflineWeatherManager.shared,
    networkManager: NetworkManager.shared,
    locationManager: LocationManager.shared
  )

  static func mock(
    weatherManager: WeatherForecastManagerProtocol = WeatherForecastManager(),
    offlineWeatherManager: OfflineWeatherManagerProtocol = OfflineWeatherManager.shared,
    networkManager: NetworkManagerProtocol = NetworkManager.shared,
    locationManager: LocationManagerProtocol = LocationManager.shared
  ) -> AppEnvironment {
    AppEnvironment(
      weatherManager: weatherManager,
      offlineWeatherManager: offlineWeatherManager,
      networkManager: networkManager,
      locationManager: locationManager
    )
  }
}
