import Foundation
import Combine

class NetworkService {

    func uploadAudioFile(url: URL) -> Future<URL, Error> {
        return Future { promise in
            let boundary = "Boundary-\(UUID().uuidString)"
            guard let uploadURL = URL(string: "http://80.158.59.245:8000/process-audio") else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: uploadURL)
            request.timeoutInterval = 600
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var data = Data()
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(url.lastPathComponent)\"\r\n")
            data.append("Content-Type: audio/wav\r\n\r\n")
            do {
                let fileData = try Data(contentsOf: url)
                data.append(fileData)
                data.append("\r\n--\(boundary)--\r\n")
            } catch {
                promise(.failure(error))
                return
            }
            
            let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let mimeType = httpResponse.mimeType,
                      mimeType == "audio/wav",
                      let responseData = data else {
                    let error = NSError(domain: "NetworkService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                    promise(.failure(error))
                    return
                }
                
                let fileManager = FileManager.default
                let tempDirectory = fileManager.temporaryDirectory
                let responseFileName = "response.wav"
                let responseFileURL = tempDirectory.appendingPathComponent(responseFileName)
                
                do {
                    try responseData.write(to: responseFileURL)
                    promise(.success(responseFileURL))
                } catch {
                    promise(.failure(error))
                }
            }
            
            task.resume()
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}



