//
//  TabBarView.swift
//  ErrorCorrection
//
//  Created by Kento Akazawa on 9/11/23.
//

import SwiftUI

// all tabs on the bottom of screen
enum Tab: String, CaseIterable {
  case home = "house"
  case codeword = "message"
  case syndrom = "exclamationmark.bubble"
}

struct TabBarView: View {
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      HStack {
        Picker(selection: $selectedTab) {
          ForEach(Tab.allCases, id: \.self) {
            // fill image when selected
            Image(systemName: selectedTab == $0 ? fillImage : $0.rawValue)
              .scaleEffect(selectedTab == $0 ? 1.25 : 1)
          }
        } label: {
          EmptyView()
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      .cornerRadius(10)
    }
  }
  
  // makes the image to be .fill (SF symbol)
  private var fillImage: String {
    selectedTab.rawValue + ".fill"
  }
}

#Preview {
  TabBarView(selectedTab: .constant(.home))
}
