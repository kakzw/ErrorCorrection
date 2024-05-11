//
//  ContentView.swift
//  ErrorCorrection
//
//  Created by Kento Akazawa on 8/28/23.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab: Tab = .home
  @State private var autoSimulate = false
  @State private var message: String = ""
  @State private var errorPattern: String = ""
  
  var body: some View {
    NavigationStack {
      VStack {
        switch selectedTab {
          case .home:
            SimulationToggleButton(autoSimulate: $autoSimulate)
            
            Spacer()
            
            if autoSimulate {
              AutoSimulationView(message: $message,
                                 errorPattern: $errorPattern)
              .shadow(color: .white, radius: 100)
            } else {
              NormalSimulationView(message: $message,
                                   errorPattern: $errorPattern)
              .shadow(color: .white, radius: 200)
            }
          case .codeword:
            CodeWordView()
          case .syndrom:
            SyndromView()
        }
        
        Spacer()
        
        TabBarView(selectedTab: $selectedTab)
        
        Spacer()
          .frame(height: 20)
      }
      .navigationTitle("Error Correction")
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbarBackground(.orange, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      // make foreground color of title to white
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}

// Toggle button for simulating automatically
struct SimulationToggleButton: View {
  @Binding var autoSimulate: Bool
  
  var body: some View {
    HStack {
      Spacer()
      Text("Auto Simulation")
        .bold()
        .opacity(0.8)
      Toggle("", isOn: $autoSimulate)
        .padding(EdgeInsets())
        .bold()
        .opacity(0.8)
        .frame(width: 50)
    }
    .padding()
  }
}

// View used when simulating automatically
struct AutoSimulationView: View {
  @Binding var message: String
  @Binding var errorPattern: String
  @State private var inputUpdated = false
  @State private var isInputValid = false
  
  var body: some View {
    VStack(spacing: 5) {
      // Message Text Field
      TextFieldView(inputType: .message,
                    input: $message, isInputValid: $isInputValid,
                    update: $inputUpdated,
                    autoSimulate: true,
                    headerFont: .subheadline,
                    textFont: .body)
      .padding(.horizontal)
      
      // Error Pattern Text Field
      TextFieldView(inputType: .errorPattern,
                    input: $errorPattern,
                    isInputValid: $isInputValid,
                    update: $inputUpdated,
                    autoSimulate: true,
                    headerFont: .headline,
                    textFont: .title3)
      .padding(.horizontal)
      
      // if statement to update view when input is updated
      if inputUpdated {
        ResultView(autoSimulate: true)
      } else {
        ResultView(autoSimulate: true)
      }
    }
  }
}

// View displayed when simulating normally
struct NormalSimulationView: View {
  @Binding var message: String
  @Binding var errorPattern: String
  @State private var isInputValid = false
  @State private var isExpanded = false
  @State private var sendTapped = false
  @State private var inputUpdated = true
  @ObservedObject var inputModel = InputModel.shared
  
  var body: some View {
    VStack(spacing: 5) {
      // Message Text Field
      TextFieldView(inputType: .message,
                    input: $message,
                    isInputValid: $isInputValid,
                    update: $inputUpdated,
                    autoSimulate: false,
                    headerFont: .headline,
                    textFont: .title3)
      
      Spacer()
        .frame(height: 30)
      
      // Error Pattern Text Field
      TextFieldView(inputType: .errorPattern,
                    input: $errorPattern,
                    isInputValid: $isInputValid,
                    update: $inputUpdated,
                    autoSimulate: false,
                    headerFont: .headline,
                    textFont: .title3)
      
      Spacer(minLength: 10)
      
      // button to simulate
      Button {
        // if valid message is entered
        // start simulating
        // otherwise show that the message entered is invalid
        if InputModel.shared.allInputsEntered {
          ErrorCorrectionModel.shared.simulate(message: message,
                                               errorPattern: errorPattern)
          sendTapped = true
        } else {
          isInputValid = true
        }
      } label: {
        Text("Simulate")
          .frame(width: 200, height: 30)
          .font(.title)
          .bold()
          .foregroundColor(.white)
          .padding()
          .background(.green)
          .cornerRadius(10)
          .opacity(inputModel.allInputsEntered ? 1 : 0.45)
      }
      
      Spacer()
        .frame(height: 10)
    }
    .navigationDestination(isPresented: $sendTapped) {
      ResultView(autoSimulate: false)
    }
    .padding()
  }
}

// Extracted view for message text field
struct TextFieldView: View {
  var inputType: InputType
  @Binding var input: String
  @Binding var isInputValid: Bool
  @Binding var update: Bool
  var autoSimulate: Bool
  var headerFont: Font
  var textFont: Font
  
  var body: some View {
    Text(inputType.rawValue)
      .font(headerFont)
      .bold()
      .opacity(0.5)
      .frame(maxWidth: .infinity, alignment: .leading)
      .offset(x: 10)
    
    Section {
      TextField("\(inputType.numOfBit) bit binary number", text: $input)
        .keyboardType(.numberPad)
        .font(headerFont)
        .bold()
        .padding()
        .foregroundColor(isInputValid && !inputType.inputEntered ? .red : .black)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onChange(of: input) { _, newValue in
          // can only type 0 or 1
          input = newValue.filter { "01".contains($0) }
          InputModel.shared.latchSetUnset(inputType,
                                          isSet: input.count == inputType.numOfBit)
          InputModel.shared.setCurrentInput(inputType, to: newValue)
          if InputModel.shared.allInputsEntered{
            isInputValid = false
            // if auto simulating
            // once valid message is entered
            // start simulation
            if autoSimulate {
              ErrorCorrectionModel.shared.simulate(message: InputModel.shared.message,
                                                   errorPattern: InputModel.shared.errorPattern)
              
              // used to update the result UI
              update.toggle()
            }
          }
        }
    } footer: {
      // error message when invalid message is entered
      Text("You must enter \(inputType.numOfBit) bit binary number")
        .foregroundColor(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
        .opacity(isInputValid && !inputType.inputEntered ? 1 : 0)
    }
  }
}

// Extracted view to show all the messages and corresponding code words
struct CodeWordView: View {
  
  var body: some View {
    HStack {
      Spacer()
      List {
        // header for each column
        HStack {
          Text("Message")
            .font(.title3)
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
          Spacer()
          Text("Code Word")
            .font(.title3)
            .bold()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
        ForEach(ErrorCorrectionModel.shared.messages, id: \.self) { msg in
          HStack {
            Text(msg)
              .monospacedDigit()
              .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Text(ErrorCorrectionModel.shared.messageToCodeWordMap[msg] ?? "")
              .monospacedDigit()
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      .listStyle(.plain)
      .padding(.horizontal)
      
      Spacer()
    }
  }
}

// Extracted view of all syndrom and corresponding error patterns
struct SyndromView: View {
  
  var body: some View {
    List {
      // Header
      HStack {
        Text("Syndrom")
          .font(.title3)
          .bold()
          .frame(maxWidth: .infinity, alignment: .center)
        Spacer()
        Text("Error Pattern")
          .font(.title3)
          .bold()
          .frame(maxWidth: .infinity, alignment: .center)
      }
      
      ForEach(ErrorCorrectionModel.shared.syndromMap.sorted(by: <), id: \.key) { syndrom in
        HStack {
          // syndrom is the key
          Text(syndrom.key)
            .monospacedDigit()
            .frame(maxWidth: .infinity, alignment: .center)
          Spacer()
          // error pattern is value
          Text(syndrom.value.description)
            .monospacedDigit()
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
    }
    .listStyle(.plain)
    .padding(.horizontal)
  }
}

#Preview {
  ContentView()
}
