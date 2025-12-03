//
//  AppEnvironment.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct AppEnvironment {
  var weatherClient: WeatherForecastManagerProtocol
  var offlineWeatherManager: OfflineWeatherManagerProtocol
  var networkManager: NetworkManagerProtocol
}

extension AppEnvironment {
  static let live = AppEnvironment(
    weatherClient: WeatherForecastManager(),
    offlineWeatherManager: OfflineWeatherManager.shared,
    networkManager: NetworkManager.shared
  )

  static func mock(
    weatherClient: WeatherForecastManagerProtocol = WeatherForecastManager(),
    offlineWeatherManager: OfflineWeatherManagerProtocol = OfflineWeatherManager.shared,
    networkManager: NetworkManagerProtocol = NetworkManager.shared
  ) -> AppEnvironment {
    AppEnvironment(
      weatherClient: weatherClient,
      offlineWeatherManager: offlineWeatherManager,
      networkManager: networkManager
    )
  }
}
