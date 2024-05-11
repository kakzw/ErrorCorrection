# Error Correction App

This SwiftUI app demonstrates error correction using Hamming Code (7,4) for binary messages. 
It allows users to manually input a message and an error pattern and simulate these inputs to see the error correction process and the resulting corrected message.

## Features
- **Simulation**: Users can input a message and an error pattern to simulate the error correction process.
- **Auto Simulation**: Can auto simulate without tapping on "Simulate" button. It changes the result view as the input changes automatically.
- **Result Display**: Displays the original message, code word, error pattern, corrected code word, corrected message, and whether the message was corrected successfully.
- **Code Word View**: Displays a list of all message and code word pairs.
- **Syndrom View**: Displays a list of all syndrom and error pattern pairs.

## Screenshots
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/92794ec4-f945-473d-9fe2-c0147b8e2d73" width="300">
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/9e42d732-0960-40cf-8b50-533ac8425eb7" width="300">
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/28f76af8-fb0e-467a-9ea6-7597a624e7e3" width="300">
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/a27df2d9-70aa-42aa-808a-6fe59626298d" width="300">
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/511f7b4b-a830-4c6b-8813-0f7ffe1cf9dd" width="300">
<img src="https://github.com/kakzw/TitanicSurvivalSimulator/assets/167830553/70321520-751e-47f3-9afa-3c802b077176" width="300">

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
