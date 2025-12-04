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
    var snackbarMessage: String?
    var showSnackbar = false
    var snackbarColor: SnackbarColor = .red
    var isNetworkAvailable: Bool = true
  }

  enum Action: Equatable, Sendable {
    case onAppear
    case networkChanged(Bool)
    case fetchSucceeded(forecasts: [DailyForecast], fromCache: Bool)
    case fetchFailed
    case autoHideSnackbar
  }

  @Injected(\.weatherManager) private var weatherManager
  @Injected(\.locationManager) private var locationManager
  @Injected(\.networkManager) private var networkManager

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        case .onAppear:
          state.isLoading = true
          state.error = nil
          state.showSnackbar = false

          return .merge(
            .run { send async in
              for await online in networkManager.updates {
                await send(.networkChanged(online))
              }
            },
            .run { send async in
              do {
                let coordinate = try await locationManager.currentLocation()
                let result = try await weatherManager.fetch7DayForecastWithCacheState(for: coordinate)
                await send(.fetchSucceeded(forecasts: result.forecasts, fromCache: result.fromCache))
              } catch {
                await send(.fetchFailed)
              }
            }
          )

        case let .networkChanged(online):
          state.isNetworkAvailable = online
          state.snackbarMessage = online ? "Back online" : "No internet connection"
          state.snackbarColor = online ? .green : .red
          state.showSnackbar = true

          return .run { send in
            try await Task.sleep(for: .seconds(3))
            await send(.autoHideSnackbar)
          }

        case let .fetchSucceeded(forecasts, fromCache):
          state.isLoading = false
          state.forecasts = forecasts
          state.isCached = fromCache
          state.lastUpdated = Date()
          state.error = nil

          if fromCache {
            state.snackbarMessage = "Offline. Showing last updated data."
            state.snackbarColor = .red
            state.showSnackbar = true

            return .run { send in
              try await Task.sleep(for: .seconds(3))
              await send(.autoHideSnackbar)
            }
          }

          return .none

        case .fetchFailed:
          state.isLoading = false

          if state.forecasts.isEmpty {
            state.error = "Cannot fetch data. Please check your network connection."
          } else {
            state.error = nil
          }

          return .none

        case .autoHideSnackbar:
          state.showSnackbar = false
          return .none
      }
    }
  }
}
