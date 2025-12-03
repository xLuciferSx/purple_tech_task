//
//  OfflineWeatherManager.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

protocol OfflineWeatherManagerProtocol: Sendable {
  func saveForecast(_ items: [DailyForecast]) throws
  func loadForecast() throws -> [DailyForecast]?
}

final class OfflineWeatherManager: OfflineWeatherManagerProtocol, Sendable {
  static let shared = OfflineWeatherManager()

  private let url: URL = {
    let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return dir.appendingPathComponent("weather_cache.json")
  }()

  func saveForecast(_ items: [DailyForecast]) throws {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(items)
    try data.write(to: url, options: .atomic)
  }

  func loadForecast() throws -> [DailyForecast]? {
    guard FileManager.default.fileExists(atPath: url.path) else { return nil }
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode([DailyForecast].self, from: data)
  }
}
