//
//  DailyForecast.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct DailyForecast: Identifiable, Codable, Sendable, Equatable {
  var id: String { dateString }

  let date: Date
  let weatherCode: Int
  let maxTemp: Double
  let minTemp: Double

  var dateString: String {
    Self.dateFormatter.string(from: date)
  }

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = .init(identifier: .iso8601)
    formatter.locale = .init(identifier: "en_GB")
    formatter.timeZone = .gmt
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  static func make(
    dateString: String,
    weatherCode: Int,
    max: Double,
    min: Double
  ) -> DailyForecast? {
    guard let date = dateFormatter.date(from: dateString) else { return nil }
    return .init(
      date: date,
      weatherCode: weatherCode,
      maxTemp: max,
      minTemp: min
    )
  }
}
