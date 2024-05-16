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
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/8f95c2f8-7ab9-40bd-9755-6a9cd38edb27" width="300">
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/ee3e287f-0a88-41df-9814-c8accefb47ad" width="300">
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/4c93b1cf-c1fd-4720-9190-fbd81b155e41" width="300">
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/12ae90aa-2275-4ad7-b69d-7620ab1457ff" width="300">
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/e35f6af6-22e7-4029-a73d-d6b5f0947a91" width="300">
<img src="https://github.com/kakzw/CyclicErrorCorrection/assets/167830553/d3a1a116-1b4f-4dc8-8d72-74e682803f4d" width="300">

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
