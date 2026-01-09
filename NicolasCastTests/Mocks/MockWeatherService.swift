//
//  MockWeatherService.swift
//  NicolasCastTests
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
@testable import NicolasCast

final class MockWeatherService: WeatherServiceProtocol {
    
    var result: Result<WeatherData, Error>?
    
    var delay: TimeInterval = 0
    private(set) var fetchCallCount = 0
    private(set) var lastRequestedLatitude: Double?
    private(set) var lastRequestedLongitude: Double?
    private(set) var lastRequestedCity: TargetCity?
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        fetchCallCount += 1
        lastRequestedLatitude = latitude
        lastRequestedLongitude = longitude
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard let result = result else {
            throw NetworkError.noData
        }
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func fetchWeather(for city: TargetCity) async throws -> WeatherData {
        fetchCallCount += 1
        lastRequestedCity = city
        
        if delay > 0 {
            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
        
        guard let result = result else {
            throw NetworkError.noData
        }
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        result = nil
        delay = 0
        fetchCallCount = 0
        lastRequestedLatitude = nil
        lastRequestedLongitude = nil
        lastRequestedCity = nil
    }
}

extension WeatherData {
    
    static func mock(
        cityName: String = "Test City",
        countryCode: String = "TC",
        description: String = "clear sky",
        temp: Double = 20.0,
        tempMin: Double = 15.0,
        tempMax: Double = 25.0,
        humidity: Int = 60,
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
                humidity: humidity
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
