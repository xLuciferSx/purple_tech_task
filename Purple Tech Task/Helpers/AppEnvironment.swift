//
//  AppEnvironment.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct AppEnvironment {
  var weatherManager: WeatherForecastManagerProtocol
  var offlineManager: OfflineManagerProtocol
  var networkManager: NetworkManagerProtocol
  var locationManager: LocationManagerProtocol
}

extension AppEnvironment {
  static let live = AppEnvironment(
    weatherManager: WeatherForecastManager(),
    offlineManager: OfflineManager.shared,
    networkManager: NetworkManager.shared,
    locationManager: LocationManager.shared
  )

  static func mock(
    weatherManager: WeatherForecastManagerProtocol = WeatherForecastManager(),
    offlineManager: OfflineManagerProtocol = OfflineManager.shared,
    networkManager: NetworkManagerProtocol = NetworkManager.shared,
    locationManager: LocationManagerProtocol = LocationManager.shared
  ) -> AppEnvironment {
    AppEnvironment(
      weatherManager: weatherManager,
      offlineManager: offlineManager,
      networkManager: networkManager,
      locationManager: locationManager
    )
  }
}
