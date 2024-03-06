import Combine
import SwiftUI

class AudioRecorderViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var hasRecordedFile = false
    @Published var errorMessage: String?
    
    private var audioService = AudioService()
    private var networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    func recordButtonTapped() {
        if isRecording {
            audioService.stopRecording()
            uploadRecording()
        } else {
            audioService.startRecording()
            // Reset the state if needed
            hasRecordedFile = false
            errorMessage = nil
        }
        isRecording.toggle()
    }

    private func uploadRecording() {
        guard let recordedURL = audioService.recordedAudioURL else {
            errorMessage = "There is no recording to upload."
            return
        }
        
        networkService.uploadAudioFile(url: recordedURL)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Upload failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] returnedURL in
                self?.audioService.playAudio(from: returnedURL) { success in
                    DispatchQueue.main.async {
                        self?.isPlaying = success
                        if !success {
                            self?.errorMessage = "Could not play the recorded audio."
                        }
                    }
                }
                self?.hasRecordedFile = true
            })
            .store(in: &cancellables)
    }

    func playbackRecordedAudio() {
        guard let url = audioService.recordedAudioURL else {
            errorMessage = "There is no recorded audio to play."
            return
        }
        audioService.playAudio(from: url) { [weak self] success in
            DispatchQueue.main.async {
                self?.isPlaying = success
                if !success {
                    self?.errorMessage = "Could not play the recorded audio."
                }
            }
        }
    }
}


