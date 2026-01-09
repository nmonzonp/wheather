//
//  WeatherViewState.swift
//  NicolasCast
//

import Foundation

enum WeatherViewState: Equatable {
    case idle
    case loading
    case loaded(WeatherData)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var weatherData: WeatherData? {
        if case .loaded(let data) = self { return data }
        return nil
    }
    
    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }
    
    var hasData: Bool {
        weatherData != nil
    }
}
