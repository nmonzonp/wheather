//
//  WeatherModels.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation

struct WeatherResponse: Codable, Equatable {
    let coord: Coordinates
    let weather: [WeatherCondition]
    let main: MainWeather
    let wind: WindInfo?
    let clouds: CloudInfo?
    let dt: Date
    let sys: SysInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinates: Codable, Equatable {
    let lon: Double
    let lat: Double
}

struct WeatherCondition: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

/// Main weather metrics including temperature
struct MainWeather: Codable, Equatable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct WindInfo: Codable, Equatable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct CloudInfo: Codable, Equatable {
    let all: Int
}

struct SysInfo: Codable, Equatable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Date
    let sunset: Date
}


extension WeatherCondition {
    
    var sfSymbolName: String {
        // Icon codes: https://openweathermap.org/weather-conditions
        switch icon {
        case "01d": return "sun.max.fill"           // Clear sky (day)
        case "01n": return "moon.fill"              // Clear sky (night)
        case "02d": return "cloud.sun.fill"         // Few clouds (day)
        case "02n": return "cloud.moon.fill"        // Few clouds (night)
        case "03d", "03n": return "cloud.fill"      // Scattered clouds
        case "04d", "04n": return "smoke.fill"      // Broken clouds
        case "09d", "09n": return "cloud.drizzle.fill" // Shower rain
        case "10d": return "cloud.sun.rain.fill"    // Rain (day)
        case "10n": return "cloud.moon.rain.fill"   // Rain (night)
        case "11d", "11n": return "cloud.bolt.fill" // Thunderstorm
        case "13d", "13n": return "snow"            // Snow
        case "50d", "50n": return "cloud.fog.fill"  // Mist
        default: return "cloud.fill"
        }
    }
    
    /// Color for the weather icon to use with symbolRenderingMode
    var isMulticolor: Bool {
        switch icon {
        case "01d", "02d", "10d": return true
        default: return false
        }
    }
}
