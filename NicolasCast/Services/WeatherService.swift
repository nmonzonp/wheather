//
//  WeatherService.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData
    func fetchWeather(for city: TargetCity) async throws -> WeatherData
}

final class WeatherService: WeatherServiceProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let endpoint = WeatherEndpoint.coordinates(latitude: latitude, longitude: longitude)
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        let response: WeatherResponse = try await apiClient.fetch(from: url)
        return WeatherData(from: response)
    }
    
    func fetchWeather(for city: TargetCity) async throws -> WeatherData {
        let endpoint = WeatherEndpoint.city(city)
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        let response: WeatherResponse = try await apiClient.fetch(from: url)
        return WeatherData(from: response)
    }
}
