//
//  WeatherDayCell.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import SwiftUI

struct WeatherDayCell: View {
  let item: DailyForecast
  let isToday: Bool

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(item.date.formatted(.dateTime.weekday(.wide)))
          .font(.headline)
        Text(item.longDate)
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()

      Image(systemName: icon(for: item.weatherCode))
        .font(.title2)

      VStack(alignment: .trailing) {
        Text("\(Int(item.maxTemp))°C")
          .font(.headline)
        Text("\(Int(item.minTemp))°C")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .padding()
    .background(isToday ? Color.blue.opacity(0.15) : Color.gray.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  private func icon(for code: Int) -> String {
    switch code {
      case 0: return "sun.max"
      case 1...3: return "cloud.sun"
      case 45, 48: return "cloud.fog"
      case 51...67: return "cloud.drizzle"
      case 71...77: return "snow"
      case 80...82: return "cloud.rain"
      case 95...99: return "cloud.bolt.rain"
      default: return "questionmark"
    }
  }
}
