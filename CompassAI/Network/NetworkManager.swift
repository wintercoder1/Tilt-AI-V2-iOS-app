//
//  NetworkManager.swift
//  Compass AI V2
//
//  Created by Steve on 8/21/25.
//
import UIKit
import Foundation

// MARK: - Network Manager
class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://compass-ai-internal-api.com"
//    private let baseURL = "YOUR_VITE_BASE_URL_HERE" // Replace with your actual base URL
//    private let baseURL = "http://127.0.0.1:8000"
    
    private init() {}
    
    private func makeRequest<T: Codable>(
        endpoint: String,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                print("Network error: \(error.localizedDescription)")
                completion(.failure(.httpError(0)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpError(0)))
                return
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
//                print("Raw decodedResponse: \(decodedResponse)\n")
                completion(.success(decodedResponse))
            } catch {
//                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func getPoliticalLeaning(for topic: String, completion: @escaping (Result<PoliticalLeaningResponse, NetworkError>) -> Void) {
        let encodedTopic = topic.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        makeRequest(
            endpoint: "/getPoliticalLeaning/\(encodedTopic)",
            responseType: PoliticalLeaningResponse.self,
            completion: completion
        )
    }
    
    func getFinancialContributionsOverview(for topic: String, completion: @escaping (Result<FinancialContributionsResponse, NetworkError>) -> Void) {
        let encodedTopic = topic.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        makeRequest(
            endpoint: "/getFinancialContributionsOverview/\(encodedTopic)",
            responseType: FinancialContributionsResponse.self,
            completion: completion
        )
    }
}
