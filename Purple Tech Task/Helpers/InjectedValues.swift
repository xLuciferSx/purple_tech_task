//
//  InjectedValues.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Foundation

struct InjectedValues {
  static var current = InjectedValues()
  var environment: AppEnvironment = .live
}

@propertyWrapper
struct Injected<Value> {
  private let keyPath: KeyPath<AppEnvironment, Value>
  init(_ keyPath: KeyPath<AppEnvironment, Value>) {
    self.keyPath = keyPath
  }

  var wrappedValue: Value {
    InjectedValues.current.environment[keyPath: keyPath]
  }
}
