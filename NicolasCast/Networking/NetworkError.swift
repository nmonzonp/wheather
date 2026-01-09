//
//  NetworkError.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case noData
    case unauthorized
    case rateLimited
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .requestFailed(let error):
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    return "No internet connection. Please check your network settings."
                case .timedOut:
                    return "Request timed out. Please try again."
                default:
                    return "Network error: \(urlError.localizedDescription)"
                }
            }
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Server returned an invalid response (code: \(statusCode))."
        case .decodingFailed:
            return "Unable to process weather data."
        case .noData:
            return "No data received from server."
        case .unauthorized:
            return "API key is invalid. Please check configuration."
        case .rateLimited:
            return "Too many requests. Please wait a moment and try again."
        case .serverError:
            return "Weather service is temporarily unavailable."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .requestFailed:
            return "Check your internet connection and try again."
        case .rateLimited:
            return "Wait a few seconds before retrying."
        case .serverError:
            return "Try again later."
        default:
            return "Please try again."
        }
    }
}
