import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AudioRecorderViewModel()

    var body: some View {
        VStack {
            Button(action: {
                // This will either start or stop recording based on the current state
                viewModel.recordButtonTapped()
            }) {
                Image(systemName: viewModel.isRecording ? "stop.circle" : "mic.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(viewModel.isRecording ? .red : .blue)
            }
            .padding()

            // Optionally, you can add a play button that becomes enabled once a recording exists
            if viewModel.hasRecordedFile {
                Button(action: {
                    // This plays back the recorded audio
                    viewModel.playbackRecordedAudio()
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
                .padding()
            }

            // Handle error messages
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

