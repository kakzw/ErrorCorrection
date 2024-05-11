//
//  ErrorCorrectionModel.swift
//  ErrorCorrection
//
//  Created by Kento Akazawa on 8/28/23.
//

import SwiftUI

// list of results that should be displayed in ResultView
enum Results: String, CaseIterable {
  case originalMessage = "Original Message"
  case originalCodeWord = "Original Code Word"
  case errorPattern = "Error Pattern"
  case errorCodeWord = "Error Code Word"
  case syndrom = "Syndrom"
  case correctedCodeWord = "Corrected Code Word"
  case correctedMessage = "Corrected Message"
  case isCorrected = "Message Corrected"
  
  // value of result
  var val: String {
    switch self {
      case .originalMessage:
        return ErrorCorrectionModel.shared.originalMessage
      case .originalCodeWord:
        return String(ErrorCorrectionModel.shared.originalCodeWord)
      case .errorPattern:
        return String(ErrorCorrectionModel.shared.errorPattern)
      case .errorCodeWord:
        return String(ErrorCorrectionModel.shared.errorCodeWord)
      case .syndrom:
        return ErrorCorrectionModel.shared.syndrom
      case .correctedCodeWord:
        return String(ErrorCorrectionModel.shared.correctedCodeWord)
      case .correctedMessage:
        return ErrorCorrectionModel.shared.correctedMessage
      case .isCorrected:
        return ErrorCorrectionModel.shared.isCorrected.description
    }
  }
  
  // color of the text that's used to display each result
  var color: Color {
    switch self {
      case .errorPattern, .errorCodeWord:
        return .red
      default:
        return .green
    }
  }
}

class ErrorCorrectionModel: NSObject {
  // singleton instance of the class
  static let shared: ErrorCorrectionModel = ErrorCorrectionModel()
  
  @Published var originalMessage = ""
  @Published var originalCodeWord = [Character]()
  @Published var errorPattern = [Character]()
  @Published var errorCodeWord = [Character]()
  @Published var syndrom = ""
  @Published var correctedCodeWord = [Character]()
  @Published var correctedMessage = ""
  @Published var isCorrected = false
  
  var messages = [String]()
  var messageToCodeWordMap = [String: String]()
  
  // map for each possible syndrom to errorpattern
  var syndromMap = [String: String]()
  
  // it's (7,4)
  // codeword is 7 bit and message is 4 bit
  let n = 7
  let k = 4
  
  // matrix of h transpose
  private let ht = [[1,0,0],
                    [0,1,0],
                    [0,0,1],
                    [1,1,1],
                    [1,0,1],
                    [0,1,1],
                    [1,1,0]]
  
  // MARK: - Initialization
  
  override init() {
    super.init()
    createMessages()
    createCodeWordMap()
    createMap()
  }
  
  // MARK: - Public Functions
  
  // resets the properties and simulates error correction
  func simulate(message: String, errorPattern error: String) {
    originalMessage = message
    originalCodeWord = [Character]()
    errorPattern = Array(error)
    errorCodeWord = [Character]()
    correctedCodeWord = [Character]()
    correctedMessage = ""
    
    createCodeWord()
    addError()
    correctMessage()
  }
  
  // MARK: - Private Functions
  
  // creates all messages possible and store in @messages
  private func createMessages() {
    // starts from 0 and 1
    // keeps adding 0 and 1 to current list
    // at the end of for loop, messages will have
    // all k bit binary numbers in ascending order
    messages = ["0", "1"]
    for _ in 1..<k {
      let c = messages.count
      for _ in 0..<c {
        let str = messages.remove(at: 0)
        messages.append(str + "0")
        messages.append(str + "1")
      }
    }
  }
  
  // creates map from all messages to code word
  private func createCodeWordMap() {
    for message in messages {
      messageToCodeWordMap[message] = addParity(to: message)
    }
  }
  
  // creates a map for syndrom to error pattern
  private func createMap() {
    for (i, ele) in ht.enumerated() {
      var errorPattern = ""
      for j in 0..<ht.count {
        if j == i {
          errorPattern += "1"
        } else {
          errorPattern += "0"
        }
      }
      syndromMap[ele.description] = errorPattern
    }
    
    // adds correct syndrom and error pattern (all 0s) to the map
    var correctSyndrom = [Int]()
    for _ in 0..<n-k {
      correctSyndrom.append(0)
    }
    var correctErrorPattern = ""
    for _ in 0..<n {
      correctErrorPattern += "0"
    }
    syndromMap[correctSyndrom.description] = correctErrorPattern
  }
  
  // adds parity bits to @message
  private func addParity(to message: String) -> String {
    let messageArray  = Array(message)
    var parity = ""
    // calculates parity bits
    for i in 0..<ht[0].count {
      var temp = 0
      for j in n-k..<ht.count {
        temp += (Int(String(messageArray[j-(n-k)])) ?? 0) * ht[j][i]
      }
      temp %= 2
      parity += String(temp)
    }
    return parity + message
  }
  
  // determines the original code word from original message
  private func createCodeWord() {
    guard let codeWord = messageToCodeWordMap[originalMessage] else {
      print("Error")
      return
    }
    originalCodeWord = Array(codeWord)
  }
  
  // add error to the code word
  private func addError() {
    errorCodeWord = originalCodeWord
    // iterates the whole errorPattern
    // and if it's 1, flip the bit
    // if it's 0, it does not have to do anything
    // because originalCodeWord is assigned to errorCodeWord above
    for i in 0..<n {
      if errorPattern[i] == "1" {
        // flip the bit
        if originalCodeWord[i] == "0" {
          errorCodeWord[i] = "1"
        } else {
          errorCodeWord[i] = "0"
        }
      }
    }
  }
  
  // corrects the errored code word
  private func correctMessage() {
    var syndrom: [Int] = []
    // matrix multiplication of message by ht
    // to get syndrom
    for i in 0..<ht[0].count {
      var temp = 0
      for j in 0..<ht.count {
        temp += (Int(String(errorCodeWord[j])) ?? 0) * ht[j][i]
      }
      temp %= 2
      syndrom.append(temp)
    }
    self.syndrom = syndrom.description
    
    // determine the error pattern from syndrom
    var errorPattern: String
    if syndromMap.keys.contains(syndrom.description) {
      errorPattern = syndromMap[syndrom.description]!
    } else {
      print("error \(syndrom.description)(key is not in the map)")
      return
    }
    
    // determine the correct code word
    // by xor errored code word and error pattern
    correctedCodeWord = []
    for (i, ele) in errorPattern.enumerated() {
      // if the certain bit is not error bit,
      // simply append the code word
      // otherwise, flip the bit
      if ele == "0" {
        correctedCodeWord.append(errorCodeWord[i])
      } else {
        if errorCodeWord[i] == "0" {
          correctedCodeWord.append("1")
        } else {
          correctedCodeWord.append("0")
        }
      }
    }
    isCorrected = messageToCodeWordMap.values.contains(String(correctedCodeWord))
    // the actual message is from 3 bit onwards
    // since the first 3 bits are parity bits
    correctedMessage = String(Array(correctedCodeWord[n-k..<correctedCodeWord.count]))
  }
}
