//
//  String+Extensions.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

extension String {
  private static let isoFormatter: DateFormatter = {
    let f = DateFormatter()
    f.calendar = .init(identifier: .iso8601)
    f.locale = .init(identifier: "en_GB")
    f.timeZone = .gmt
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  private static let longFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = .init(identifier: "en_GB")
    f.dateFormat = "d MMMM yyyy"
    return f
  }()

  var asLongDate: String {
    guard let date = Self.isoFormatter.date(from: self)
    else { return self }
    return Self.longFormatter.string(from: date)
  }
}
