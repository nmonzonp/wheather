//
//  APIClient.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
    func fetchWithRetry<T: Decodable>(from url: URL, maxRetries: Int) async throws -> T
}

extension APIClientProtocol {
    func fetchWithRetry<T: Decodable>(from url: URL, maxRetries: Int = 2) async throws -> T {
        try await fetch(from: url)
    }
}

final class URLSessionAPIClient: APIClientProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let retryDelays: [UInt64] = [1_000_000_000, 3_000_000_000]
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        try await performFetch(from: url)
    }
    
    func fetchWithRetry<T: Decodable>(from url: URL, maxRetries: Int = 2) async throws -> T {
        var lastError: Error = NetworkError.noData
        let attempts = min(maxRetries + 1, retryDelays.count + 1)
        
        for attempt in 0..<attempts {
            do {
                return try await performFetch(from: url)
            } catch let error as NetworkError {
                lastError = error
                
                guard isTransientError(error), attempt < attempts - 1 else {
                    throw error
                }
                
                let delay = attempt < retryDelays.count ? retryDelays[attempt] : retryDelays.last!
                try await Task.sleep(nanoseconds: delay)
            } catch {
                throw error
            }
        }
        
        throw lastError
    }
    
    private func performFetch<T: Decodable>(from url: URL) async throws -> T {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: 0)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 429:
            throw NetworkError.rateLimited
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    private func isTransientError(_ error: NetworkError) -> Bool {
        switch error {
        case .requestFailed(let underlyingError):
            if let urlError = underlyingError as? URLError {
                switch urlError.code {
                case .timedOut,
                     .networkConnectionLost,
                     .notConnectedToInternet,
                     .cannotConnectToHost:
                    return true
                default:
                    return false
                }
            }
            return false
        case .serverError:
            return true
        default:
            return false
        }
    }
}

