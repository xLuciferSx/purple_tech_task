//
//  DateFormatter+Extension.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

extension DateFormatter {
  static let weatherISO: DateFormatter = {
    let f = DateFormatter()
    f.calendar = .init(identifier: .iso8601)
    f.locale = .init(identifier: "en_GB")
    f.timeZone = .gmt
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()
}
