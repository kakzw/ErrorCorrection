//
//  ResultView.swift
//  ErrorCorrection
//
//  Created by Kento Akazawa on 8/28/23.
//

import SwiftUI

struct ResultView: View {
  var autoSimulate: Bool
  
  var body: some View {
    List(Results.allCases, id: \.self) { result in
      // when used for auto simulation,
      // don't display original messasge and error pattern
      if !autoSimulate || (result != .originalMessage && result != .errorPattern) {
        ResultViewCell(result: result)
      }
    }
    .listStyle(.plain)
    .padding(.horizontal)
    .navigationTitle(autoSimulate ? "Error Correction" : "Result")
    .navigationBarTitleDisplayMode(.inline)
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    // make foreground color of title to white
    .toolbarColorScheme(.dark, for: .navigationBar)
  }
}

// Extracted view for each cell in result
struct ResultViewCell: View {
  var result: Results
  
  var body: some View {
    Section {
      Text(result.val)
        .bold()
        .listRowBackground(RoundedRectangle(cornerRadius: 10)
          .fill(result.color.opacity(0.2)))
        .listRowSeparator(.hidden)
    } header: {
      Text(result.rawValue)
        .foregroundColor(result.color)
    }
  }
}

#Preview {
  ResultView(autoSimulate: false)
}
