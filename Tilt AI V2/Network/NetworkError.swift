//
//  NetworkError.swift
//  Tilt AI V2
//
//  Created by Steve on 8/21/25.
//

enum NetworkError: Error {
    case invalidURL
    case httpError(Int)
    case decodingError
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .noData:
            return "No data received"
        }
    }
}
