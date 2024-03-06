# iOS Voice Chatbot App

## Description

The iOS Voice Chatbot App is a sophisticated voice-based interaction application that allows users to record messages, send them to a server for processing, and listen to the server's audio response. The app features a simple yet effective user interface that includes a record button, a processing indicator, and playback functionality.

## Features

- **Voice Recording**: Users can record their voice by pressing and holding a dedicated button.
- **Audio Processing**: The recorded audio is sent to a server where it's processed and a response is generated.
- **Response Playback**: The app plays back the server-generated audio response.
- **Activity Indicator**: During processing, the app displays a visual indicator to inform the user that their request is being processed.

## Installation

To get started with the iOS Voice Chatbot App, you need to have Xcode installed on your macOS system. Follow these steps to install and run the app:

1. Clone the repository to your local machine.
2. Open the project in Xcode by double-clicking the `.xcodeproj` file.
3. Configure the app's capabilities and Info.plist as required, specifically:
   - Make sure that the `NSMicrophoneUsageDescription` is set with an appropriate message.
   - If your server does not use HTTPS, configure the `NSAppTransportSecurity` settings in the Info.plist file.
4. Select a simulator or connect an iOS device to run the app.
5. Press the run button (▶️) in Xcode to build and run the app.

## Usage

- **To Start Recording**: Tap the microphone button.
- **To Stop Recording**: Release the microphone button. The recording will automatically be sent for processing.
- **To Hear the Response**: Wait for the processing indicator to disappear, which will be followed by the playback of the server's response.

## Configuration

Ensure the server URL is correctly set in the `NetworkService` class to point to your backend service.

```swift
let serverURL = "https://yourserver.com/process-audio"
