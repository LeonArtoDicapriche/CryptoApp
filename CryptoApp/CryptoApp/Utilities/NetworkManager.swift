import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badURLResponce(url: URL), unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponce(let url):
                return "[⛔️] Bad responce from URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured."
            }
        }
    }
    
    static func download(urlSession: URLSession, url: URL) -> AnyPublisher<Data, Error> {
        return urlSession.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponce(output: $0, url: url)})
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(receiveCompletion: Subscribers.Completion<Error>, result: ((String) -> Void)? = nil) {
        switch receiveCompletion {
        case .finished:
            result?("finished")
        case .failure(let error):
            result?("failure")
            NSLog(error.localizedDescription)
        }
    }
    
    static private func handleURLResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let responce = output.response as? HTTPURLResponse,
              responce.statusCode >= 200 && responce.statusCode < 300
        else { throw NetworkError.badURLResponce(url: url) }
        return output.data
    }
}
// swiftlint:disable foundation_using
