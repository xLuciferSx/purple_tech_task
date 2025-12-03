//
//  Date+Extensions.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

extension Date {
  private static let longDateTimeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = .init(identifier: "en_GB")
    f.dateFormat = "d MMMM yyyy, HH:mm"
    return f
  }()

  var asLongDateTime: String {
    Date.longDateTimeFormatter.string(from: self)
  }
}
