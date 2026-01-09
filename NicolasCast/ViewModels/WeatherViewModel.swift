//
//  WeatherViewModel.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published private(set) var viewState: WeatherViewState = .idle
    @Published var selectedLocation: LocationIdentifier = .currentLocation {
        didSet {
            guard selectedLocation != oldValue else { return }
            persistenceManager.lastSelectedLocation = selectedLocation.rawValue
            fetchWeather()
        }
    }
    
    private let weatherService: WeatherServiceProtocol
    private var persistenceManager: PersistenceManagerProtocol
    private let locationManager: LocationManager
    
    private var currentTask: Task<Void, Never>?
    
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        persistenceManager: PersistenceManagerProtocol = UserDefaultsPersistenceManager(),
        locationManager: LocationManager
    ) {
        self.weatherService = weatherService
        self.persistenceManager = persistenceManager
        self.locationManager = locationManager
        
        restoreLastLocation()
        
        setupLocationCallback()
    }
    
    convenience init() {
        self.init(
            weatherService: WeatherService(),
            persistenceManager: UserDefaultsPersistenceManager(),
            locationManager: LocationManager()
        )
    }
    
    func fetchWeather() {
        currentTask?.cancel()
        
        currentTask = Task {
            await performFetch()
        }
    }
    
    func retry() {
        fetchWeather()
    }
    
    func requestLocationPermission() {
        locationManager.requestAuthorization()
    }
    
    var locationAuthorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    var isLocationAuthorized: Bool {
        locationManager.isAuthorized
    }
    
    var availableLocations: [LocationIdentifier] {
        LocationIdentifier.allCases
    }
    
    private func restoreLastLocation() {
        if let savedLocation = LocationIdentifier(persistedValue: persistenceManager.lastSelectedLocation) {
            if savedLocation == .currentLocation && !locationManager.isAuthorized {
                selectedLocation = .london
            } else {
                selectedLocation = savedLocation
            }
        } else {
            selectedLocation = .currentLocation
        }
    }
    
    private func setupLocationCallback() {
        locationManager.onLocationUpdate = { [weak self] location in
            Task { @MainActor [weak self] in
                guard let self = self,
                      self.selectedLocation == .currentLocation else { return }
                await self.fetchWeatherForCoordinates(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
        }
        
        locationManager.onAuthorizationChange = { [weak self] status in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    if self.selectedLocation == .currentLocation {
                        self.fetchWeather()
                    }
                }
            }
        }
    }
    
    private func performFetch() async {
        guard !Task.isCancelled else { return }
        
        viewState = .loading
        
        do {
            let weatherData: WeatherData
            
            if selectedLocation == .currentLocation {
                if !locationManager.isAuthorized {
                    if !locationManager.isAuthorizationDetermined {
                        locationManager.requestAuthorization()
                        return
                    } else {
                        viewState = .error("Location access required. Please enable in Settings.")
                        return
                    }
                }
                
                locationManager.requestLocation()
                
                if let location = locationManager.location {
                    weatherData = try await weatherService.fetchWeather(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    
                    guard !Task.isCancelled else { return }
                    viewState = .loaded(weatherData)
                } else {
                    return
                }
            } else if let city = selectedLocation.targetCity {
                weatherData = try await weatherService.fetchWeather(for: city)
                
                guard !Task.isCancelled else { return }
                viewState = .loaded(weatherData)
            } else {
                viewState = .error("Unknown location selected.")
            }
        } catch let error as NetworkError {
            guard !Task.isCancelled else { return }
            viewState = .error(error.localizedDescription)
        } catch {
            guard !Task.isCancelled else { return }
            viewState = .error("An unexpected error occurred. Please try again.")
        }
    }
    
    private func fetchWeatherForCoordinates(latitude: Double, longitude: Double) async {
        viewState = .loading
        
        do {
            let weatherData = try await weatherService.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
            viewState = .loaded(weatherData)
        } catch let error as NetworkError {
            viewState = .error(error.localizedDescription)
        } catch {
            viewState = .error("An unexpected error occurred. Please try again.")
        }
    }
}
