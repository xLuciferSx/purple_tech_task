//
//  WeatherResponse.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct WeatherResponse: Codable, Sendable, Equatable {
  let latitude: Double
  let longitude: Double
  let generationtimeMs: Double
  let utcOffsetSeconds: Int
  let timezone: String
  let timezoneAbbreviation: String
  let elevation: Double
  let dailyUnits: DailyUnits
  let daily: Daily

  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case generationtimeMs = "generationtime_ms"
    case utcOffsetSeconds = "utc_offset_seconds"
    case timezone
    case timezoneAbbreviation = "timezone_abbreviation"
    case elevation
    case dailyUnits = "daily_units"
    case daily
  }
}

struct DailyUnits: Codable, Sendable, Equatable {
  let time: String
  let weatherCode: String
  let temperature2mMax: String
  let temperature2mMin: String

  enum CodingKeys: String, CodingKey {
    case time
    case weatherCode = "weather_code"
    case temperature2mMax = "temperature_2m_max"
    case temperature2mMin = "temperature_2m_min"
  }
}

struct Daily: Codable, Sendable, Equatable {
  let time: [String]
  let weatherCode: [Int]
  let temperature2mMax: [Double]
  let temperature2mMin: [Double]

  enum CodingKeys: String, CodingKey {
    case time
    case weatherCode = "weather_code"
    case temperature2mMax = "temperature_2m_max"
    case temperature2mMin = "temperature_2m_min"
  }
}
