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
    Self.isoFormatter.string(from: date)
  }

  var longDate: String {
    dateString.asLongDate
  }

  static func make(
    dateString: String,
    weatherCode: Int,
    max: Double,
    min: Double
  ) -> DailyForecast? {
    guard let date = isoFormatter.date(from: dateString) else { return nil }
    return .init(
      date: date,
      weatherCode: weatherCode,
      maxTemp: max,
      minTemp: min
    )
  }
}

extension DailyForecast {
  static let isoFormatter: DateFormatter = {
    let f = DateFormatter()
    f.calendar = .init(identifier: .iso8601)
    f.locale = .init(identifier: "en_GB")
    f.timeZone = .gmt
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  static let longFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = .init(identifier: "en_GB")
    f.dateFormat = "d MMMM yyyy"
    return f
  }()
}
