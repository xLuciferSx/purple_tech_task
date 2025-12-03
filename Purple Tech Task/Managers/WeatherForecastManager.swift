//
//  WeatherForecastClient.swift
//  WeatherTechTask
//
//  Created by Raivis on 3/12/25.
//

import CoreLocation
import Foundation

protocol WeatherForecastManagerProtocol: Sendable {
  func fetch7DayForecast(for coordinate: CLLocationCoordinate2D) async throws -> [DailyForecast]
}

enum WeatherForecastManagerError: Error, Equatable {
  case invalidURL
  case invalidResponse(statusCode: Int)
  case decoding
}

struct WeatherForecastManager: WeatherForecastManagerProtocol, Sendable {
  private let baseURL: URL
  private let session: URLSession
  private let decoder: JSONDecoder

  init(
    baseURL: URL = URL(string: "https://api.open-meteo.com/v1")!,
    session: URLSession = .shared
  ) {
    self.baseURL = baseURL
    self.session = session
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .useDefaultKeys
    self.decoder = decoder
  }

  func fetch7DayForecast(for coordinate: CLLocationCoordinate2D) async throws -> [DailyForecast] {
    var components = URLComponents(
      url: baseURL.appendingPathComponent("forecast"),
      resolvingAgainstBaseURL: false
    )

    components?.queryItems = [
      .init(name: "latitude", value: "\(coordinate.latitude)"),
      .init(name: "longitude", value: "\(coordinate.longitude)"),
      .init(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min"),
      .init(name: "timezone", value: "auto"),
      .init(name: "forecast_days", value: "7")
    ]

    guard let url = components?.url else {
      throw WeatherForecastManagerError.invalidURL
    }

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

    return Array(forecasts.prefix(7))
  }
}
