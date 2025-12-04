//
//  WeatherForecastView.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import ComposableArchitecture
import SwiftUI

struct WeatherForecastView: View {
  @Injected(\.networkManager) var networkManager
  @State var store: StoreOf<WeatherForecastLogic>

  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        content

        if store.showSnackbar, let message = store.snackbarMessage {
          Snackbar(
            text: message,
            background: store.snackbarColor == .red ? .red : .green
          ) {
            store.send(.autoHideSnackbar)
          }
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .padding(.bottom, 10)
          .padding(.horizontal)
        }
      }
      .animation(.spring(), value: store.showSnackbar)
      .navigationTitle(store.forecasts.isEmpty ? "" : "7-Day Forecast")
      .onAppear { store.send(.onAppear) }
    }
  }
}

private extension WeatherForecastView {
  @ViewBuilder
  var content: some View {
    if store.isLoading {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    else if let error = store.error, store.forecasts.isEmpty {
      VStack(spacing: 12) {
        Image(systemName: "wifi.exclamationmark")
          .font(.system(size: 44))
          .foregroundStyle(.orange)

        Text(error)
          .padding(.horizontal)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    else {
      ScrollView {
        LazyVStack(spacing: 12) {
          if store.isCached, let last = store.lastUpdated {
            Text("Last updated at \(last.asLongDateTime)")
              .font(.caption)
              .foregroundStyle(.blue)
              .padding(.top, 6)
          }

          ForEach(Array(store.forecasts.enumerated()), id: \.offset) { index, item in
            WeatherDayCell(item: item, isToday: index == 0)
              .padding(.horizontal)
          }
        }
        .padding(.top, 8)
      }
    }
  }
}
