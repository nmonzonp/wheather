//
//  LocationManager.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {
    
    @Published private(set) var location: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var locationError: Error?
    @Published private(set) var isLoading: Bool = false
    
    private let manager: CLLocationManager
    
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    
    var isAuthorized: Bool {
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            return false
        }
    }
    
    var isAuthorizationDetermined: Bool {
        authorizationStatus != .notDetermined
    }
    
    override init() {
        self.manager = CLLocationManager()
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        guard isAuthorized else {
            requestAuthorization()
            return
        }
        
        locationError = nil
        isLoading = true
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            self.location = location
            self.isLoading = false
            self.onLocationUpdate?(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locationError = error
            self.isLoading = false
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            self.onAuthorizationChange?(manager.authorizationStatus)
            
            if self.authorizationStatus == .authorizedWhenInUse || self.authorizationStatus == .authorizedAlways {
                self.requestLocation()
            }
        }
    }
}

extension LocationManager {
    
    var locationErrorMessage: String? {
        guard let error = locationError as? CLError else {
            return locationError?.localizedDescription
        }
        
        switch error.code {
        case .denied:
            return "Location access denied. Please enable in Settings."
        case .locationUnknown:
            return "Unable to determine location. Please try again."
        case .network:
            return "Network error while fetching location."
        default:
            return "Location error: \(error.localizedDescription)"
        }
    }
}
