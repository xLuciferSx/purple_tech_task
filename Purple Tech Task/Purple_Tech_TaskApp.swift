//
//  Purple_Tech_TaskApp.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import Atlantis
import ComposableArchitecture
import SwiftUI

@main
struct Purple_Tech_TaskApp: App {
  var body: some Scene {
    WindowGroup {
      WeatherForecastView(
        store: Store(
          initialState: WeatherForecastLogic.State(),
          reducer: { WeatherForecastLogic() }
        )
      )
    }
  }
}
