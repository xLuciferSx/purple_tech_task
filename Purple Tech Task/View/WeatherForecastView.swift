//
//  WeatherForecastView.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import ComposableArchitecture
import SwiftUI

struct WeatherForecastView: View {
  @State var store: StoreOf<WeatherForecastLogic>

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  WeatherForecastView(store: .init(
    initialState: WeatherForecastLogic.State(),
    reducer: {
      WeatherForecastLogic()
    })
  )
}
