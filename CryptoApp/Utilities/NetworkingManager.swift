//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Bhavin Matreja on 10/05/25.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse (url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): "[🔥] Bad response from URL: \(url)"
            case .unknown: "[⚠️] Unkown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            // .subscribe(on: DispatchQueue.global(qos: .default)) | dataTaskPublisher automatically goes to background thread, so this not needed
            .tryMap { try handleURLResponse(output: $0, url: url) }
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output:  URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        // throw NetworkingError.badURLResponse(url: url)
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("finished")
            break
        case .failure(let error):
            print("Error \(error.localizedDescription) \(error)")
        }
    }
}
