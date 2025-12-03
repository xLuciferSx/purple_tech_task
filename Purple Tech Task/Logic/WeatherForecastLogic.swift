//
//  WeatherForecastLogic.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import ComposableArchitecture
import CoreLocation

@Reducer
struct WeatherForecastLogic {
  @ObservableState
  struct State: Equatable {
    var forecasts: [DailyForecast] = []
    var isLoading = false
    var isCached = false
    var lastUpdated: Date?
    var error: String?
    var showSnackbar = false
    var snackbarColor: SnackbarColor = .red
  }

  enum Action: Equatable, Sendable {
    case onAppear
    case fetchSucceeded(forecasts: [DailyForecast], cached: Bool)
    case fetchFailed
    case networkChanged(Bool)
    case dismissSnackbar
  }

  @Injected(\.weatherManager) private var weatherManager
  @Injected(\.locationManager) private var locationManager

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .onAppear:
          state.isLoading = true
          state.error = nil
          state.isCached = false
          state.showSnackbar = false

          return .run { send async in
            do {
              let coordinate = try await locationManager.currentLocation()
              let result = try await weatherManager.fetch7DayForecastWithCacheState(for: coordinate)
              await send(.fetchSucceeded(forecasts: result.forecasts, cached: result.cached))
            } catch {
              await send(.fetchFailed)
            }
          }

        case let .fetchSucceeded(forecasts, cached):
          state.isLoading = false
          state.forecasts = forecasts
          state.isCached = cached
          state.lastUpdated = Date()
          state.error = nil
          state.showSnackbar = false
          return .none

        case .fetchFailed:
          state.isLoading = false
          if state.forecasts.isEmpty {
            state.error = "Cannot fetch data. Please check your network connection."
          } else {
            state.error = nil
            state.showSnackbar = true
          }
          return .none
          
        case let .networkChanged(online):
          if online {
            state.error = "Back online"
            state.snackbarColor = .green
          } else {
            state.error = "No internet connection"
            state.snackbarColor = .red
          }
          state.showSnackbar = true
          return .none

        case .dismissSnackbar:
          state.showSnackbar = false
          return .none
      }
    }
  }
}
