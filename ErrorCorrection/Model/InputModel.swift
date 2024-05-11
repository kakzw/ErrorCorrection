//
//  InputModel.swift
//  ErrorCorrection
//
//  Created by Kento Akazawa on 9/11/23.
//

import SwiftUI

enum InputType: String {
  case message = "Message"
  case errorPattern = "Error Pattern"
  
  var numOfBit: Int {
    switch self {
      case .message:
        return ErrorCorrectionModel.shared.k
      case .errorPattern:
        return ErrorCorrectionModel.shared.n
    }
  }
  
  var inputEntered: Bool {
    switch self{
      case .message:
        return InputModel.shared.messageEntered
      case .errorPattern:
        return InputModel.shared.errorPatternEntered
    }
  }
}

class InputModel: ObservableObject {
  // singleton instance of this class
  static let shared = InputModel()
  
  @Published var allInputsEntered = false
  var messageEntered = false
  var errorPatternEntered = false
  var message = ""
  var errorPattern = ""
  
  // MARK: - Public Functions
  
  // Update a specific input flag and determine if all required inputs are entered
  func latchSetUnset(_ flag: InputType, isSet: Bool) {
    switch flag {
      case .message:
        messageEntered = isSet
      case .errorPattern:
        errorPatternEntered = isSet
    }
    allInputsEntered = messageEntered && errorPatternEntered
  }
  
  func setCurrentInput(_ flag: InputType, to value: String) {
    switch flag {
      case .message:
        message = value
      case .errorPattern:
        errorPattern = value
    }
  }
}
