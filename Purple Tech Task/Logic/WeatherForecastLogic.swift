//
//  WeatherForecastLogic.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct WeatherForecastLogic { 
  @ObservableState
  struct State: Equatable {
    var test: String = "Hello World"
  }
  
  enum Action: Equatable, Sendable {
    case test
  }
  
  init() {}
  
  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
        case .test:
          state.test = "New Value"
          return .none
      }
    }
  }
}
