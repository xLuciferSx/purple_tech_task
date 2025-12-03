//
//  WeatherForecastManager.swift
//  WeatherTechTask
//
//  Created by Raivis on 3/12/25.
//

import CoreLocation
import Foundation

protocol WeatherForecastManagerProtocol: Sendable {
  func fetch7DayForecast(for coordinate: CLLocationCoordinate2D) async throws -> [DailyForecast]
  func fetch7DayForecastWithCacheState(for coordinate: CLLocationCoordinate2D) async throws -> (forecasts: [DailyForecast], fromCache: Bool)
}

enum WeatherForecastManagerError: Error, Equatable {
  case invalidURL
  case invalidResponse(statusCode: Int)
  case decoding
  case noData
}

struct WeatherForecastManager: WeatherForecastManagerProtocol, Sendable {
  @Injected(\.offlineManager) private var offlineManager

  private let session: URLSession
  private let decoder: JSONDecoder

  init(session: URLSession = .shared) {
    self.session = session
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    self.decoder = decoder
  }

  func fetch7DayForecastWithCacheState(for coordinate: CLLocationCoordinate2D) async throws -> (forecasts: [DailyForecast], fromCache: Bool) {
    guard let url = Self.makeURL(coordinate: coordinate) else {
      throw WeatherForecastManagerError.invalidURL
    }

    do {
      let (data, response) = try await session.data(from: url)

      guard
        let http = response as? HTTPURLResponse,
        (200 ..< 300).contains(http.statusCode)
      else {
        throw WeatherForecastManagerError.invalidResponse(
          statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1
        )
      }

      guard let weather = try? decoder.decode(WeatherResponse.self, from: data) else {
        throw WeatherForecastManagerError.decoding
      }

      let daily = weather.daily

      let zipped = zip(
        zip(daily.time, daily.weatherCode),
        zip(daily.temperature2mMax, daily.temperature2mMin)
      )

      let forecasts = zipped.compactMap { tuple in
        let ((dateString, code), (max, min)) = tuple
        return DailyForecast.make(
          dateString: dateString,
          weatherCode: code,
          max: max,
          min: min
        )
      }

      let final = Array(forecasts.prefix(7))

      try? offlineManager.saveForecast(final)

      return (final, false)
    } catch {
      if let cached = try offlineManager.loadForecast(), !cached.isEmpty {
        return (cached, true)
      }
      throw WeatherForecastManagerError.noData
    }
  }

  func fetch7DayForecast(for coordinate: CLLocationCoordinate2D) async throws -> [DailyForecast] {
    try await fetch7DayForecastWithCacheState(for: coordinate).forecasts
  }
}

private extension WeatherForecastManager {
  static func makeURL(coordinate: CLLocationCoordinate2D) -> URL? {
    var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
    components?.queryItems = [
      .init(name: "latitude", value: "\(coordinate.latitude)"),
      .init(name: "longitude", value: "\(coordinate.longitude)"),
      .init(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min"),
      .init(name: "timezone", value: "auto"),
      .init(name: "forecast_days", value: "7")
    ]
    return components?.url
  }
}
