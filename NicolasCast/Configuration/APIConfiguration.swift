//
//  APIConfiguration.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation

enum APIConfiguration {
    
    static let openWeatherMapAPIKey: String = {
        // Correct way to read from the Info.plist dictionary
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPIKey") as? String else {
            fatalError("OpenWeatherAPIKey not found in Info.plist. Ensure it is added in the 'Info' tab of your Target.")
        }
        return key
    }()
    
    static let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5"
    static let openWeatherMapIconBaseURL = "https://openweathermap.org/img/wn"
    static let units = "metric"
    static let dataFreshnessInterval: TimeInterval = 600
}
