//
//  WeatherData.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
import SwiftUI

struct WeatherData: Identifiable, Equatable {
    let id: UUID
    let cityName: String
    let countryCode: String?
    let description: String
    let sfSymbolName: String
    let iconIsMulticolor: Bool
    let currentTemp: Measurement<UnitTemperature>
    let minTemp: Measurement<UnitTemperature>
    let maxTemp: Measurement<UnitTemperature>
    let feelsLike: Measurement<UnitTemperature>
    let humidity: Int
    let windSpeed: Double?
    let sunrise: Date
    let sunset: Date
    let fetchedAt: Date
    let weatherConditionId: Int
    
    var formattedCurrentTemp: String {
        formatTemperature(currentTemp, style: .short)
    }
    
    var formattedMinTemp: String {
        formatTemperature(minTemp, style: .short)
    }
    
    var formattedMaxTemp: String {
        formatTemperature(maxTemp, style: .short)
    }
    
    var formattedFeelsLike: String {
        formatTemperature(feelsLike, style: .short)
    }
    
    var formattedCurrentTempFull: String {
        formatTemperature(currentTemp, style: .medium)
    }
    
    var formattedDescription: String {
        description.capitalized
    }
    
    var formattedHumidity: String {
        "\(humidity)%"
    }
    
    private func formatTemperature(_ temp: Measurement<UnitTemperature>, style: Formatter.UnitStyle) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = style
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: temp)
    }
    
    init(from response: WeatherResponse) {
        self.id = UUID()
        self.cityName = response.name
        self.countryCode = response.sys.country
        
        let condition = response.weather.first
        self.description = condition?.description ?? "Unknown"
        self.sfSymbolName = condition?.sfSymbolName ?? "cloud.fill"
        self.iconIsMulticolor = condition?.isMulticolor ?? false
        self.weatherConditionId = condition?.id ?? 0
        
        self.currentTemp = Measurement(value: response.main.temp, unit: UnitTemperature.celsius)
        self.minTemp = Measurement(value: response.main.tempMin, unit: UnitTemperature.celsius)
        self.maxTemp = Measurement(value: response.main.tempMax, unit: UnitTemperature.celsius)
        self.feelsLike = Measurement(value: response.main.feelsLike, unit: UnitTemperature.celsius)
        
        self.humidity = response.main.humidity
        self.windSpeed = response.wind?.speed
        self.sunrise = response.sys.sunrise
        self.sunset = response.sys.sunset
        self.fetchedAt = Date()
    }
    
    var isStale: Bool {
        Date().timeIntervalSince(fetchedAt) > APIConfiguration.dataFreshnessInterval
    }
    
    var isDaytime: Bool {
        let now = Date()
        return now >= sunrise && now < sunset
    }
}

extension WeatherData {
    
    var backgroundGradient: LinearGradient {
        let colors: [Color]
        
        switch weatherConditionId {
        case 200...299:
            colors = [Color(hex: "1a1a2e"), Color(hex: "4a4e69")]
        case 300...399, 500...599:
            colors = isDaytime
                ? [Color(hex: "4a5568"), Color(hex: "718096")]
                : [Color(hex: "2d3748"), Color(hex: "4a5568")]
        case 600...699:
            colors = [Color(hex: "e2e8f0"), Color(hex: "a0aec0")]
        case 700...799:
            colors = [Color(hex: "9ca3af"), Color(hex: "d1d5db")]
        case 800:
            colors = isDaytime
                ? [Color(hex: "3b82f6"), Color(hex: "93c5fd")]
                : [Color(hex: "1e3a5f"), Color(hex: "312e81")]
        case 801...804:
            colors = isDaytime
                ? [Color(hex: "6b7280"), Color(hex: "9ca3af")]
                : [Color(hex: "374151"), Color(hex: "4b5563")]
        default:
            colors = [Color(hex: "3b82f6"), Color(hex: "60a5fa")]
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#if DEBUG
extension WeatherData {
    static var preview: WeatherData {
        WeatherData.mock()
    }
    
    static func mock(
        cityName: String = "London",
        countryCode: String = "GB",
        description: String = "clear sky",
        temp: Double = 20.0,
        tempMin: Double = 15.0,
        tempMax: Double = 25.0,
        weatherConditionId: Int = 800
    ) -> WeatherData {
        let response = WeatherResponse(
            coord: Coordinates(lon: 0, lat: 0),
            weather: [WeatherCondition(
                id: weatherConditionId,
                main: "Clear",
                description: description,
                icon: "01d"
            )],
            main: MainWeather(
                temp: temp,
                feelsLike: temp - 1,
                tempMin: tempMin,
                tempMax: tempMax,
                pressure: 1013,
                humidity: 60
            ),
            wind: WindInfo(speed: 5.0, deg: 180, gust: nil),
            clouds: CloudInfo(all: 0),
            dt: Date(),
            sys: SysInfo(
                type: 1,
                id: 1,
                country: countryCode,
                sunrise: Date(),
                sunset: Date().addingTimeInterval(43200)
            ),
            timezone: 0,
            id: 1,
            name: cityName,
            cod: 200
        )
        return WeatherData(from: response)
    }
}
#endif
