//
//  WeatherEndpoint.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation


enum WeatherEndpoint {
    
    case coordinates(latitude: Double, longitude: Double)
    
    case city(TargetCity)
    
    
    var url: URL? {
        var components = URLComponents(string: APIConfiguration.openWeatherMapBaseURL + "/weather")
        
        let (lat, lon) = self.coordinates
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: APIConfiguration.openWeatherMapAPIKey),
            URLQueryItem(name: "units", value: APIConfiguration.units)
        ]
        
        return components?.url
    }
    
    
    private var coordinates: (latitude: Double, longitude: Double) {
        switch self {
        case .coordinates(let latitude, let longitude):
            return (latitude, longitude)
        case .city(let city):
            return city.coordinates
        }
    }
}



enum TargetCity: String, CaseIterable, Identifiable {
    case london = "London"
    case montevideo = "Montevideo"
    case buenosAires = "Buenos Aires"
    
    var id: String { rawValue }
    

    var coordinates: (latitude: Double, longitude: Double) {
        switch self {
        case .london:
            return (51.5074, -0.1278)
        case .montevideo:
            return (-34.9011, -56.1645)
        case .buenosAires:
            return (-34.6037, -58.3816)
        }
    }
    
    var flag: String {
        switch self {
        case .london:
            return "🇬🇧"
        case .montevideo:
            return "🇺🇾"
        case .buenosAires:
            return "🇦🇷"
        }
    }
}
