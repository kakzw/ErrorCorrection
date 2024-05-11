# Error Correction App

This SwiftUI app demonstrates error correction using Hamming Code (7,4) for binary messages. 
It allows users to manually input a message and an error pattern and simulate these inputs to see the error correction process and the resulting corrected message.

## Features
- **Simulation**: Users can input a message and an error pattern to simulate the error correction process.
- **Auto Simulation**: Can auto simulate without tapping on "Simulate" button. It changes the result view as the input changes automatically.
- **Result Display**: Displays the original message, code word, error pattern, corrected code word, corrected message, and whether the message was corrected successfully.

## Screenshots

## Installation
- To run this app, make sure you have `XCode` installed.
- Clone this repository.
- Open `ErrorCorrection.xcodeproj` in `XCode`.
- Build and run the app on your iOS device or simulator.

## Usage
### Manual Simulation
1. **Message Input**: Enter 4 bit binary message (ex. 1001).
2. **Error Pattern Input**: Enter a 7 bit binary error pattern (ex. 1101000).
3. **View Result**: Tap the "Simulate" button to trigger the error correction process.

### Auto Simulation
1. **Auto Simulation Toggle**: Enable the "Auto Simulation" toggle button.
2. **Message and Error Pattern Inputs**: Enter valid message and error pattern similar to manual simulation.
3. **View Result**: Results are displayed automatically upon input.

## Requirements
- iOS 14.0+
- XCode 13.0+
