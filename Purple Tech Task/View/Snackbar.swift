//
//  Snackbar.swift
//  Purple Tech Task
//
//  Created by Raivis on 3/12/25.
//

import SwiftUI

enum SnackbarColor: Equatable, Sendable {
  case red
  case green
}

struct Snackbar: View {
  let text: String
  let background: Color
  let action: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      Text(text)
        .font(.headline)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(background.opacity(0.9))
    .foregroundStyle(.white)
    .cornerRadius(10)
    .padding(.horizontal)
    .padding(.bottom, 20)
    .onTapGesture { action() }
  }
}
