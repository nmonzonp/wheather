//
//  LocationIdentifier.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//  Defines selectable locations for the weather app
//

import Foundation

// MARK: - Location Identifier

/// Represents a selectable location in the weather app.
/// Supports current device location and fixed cities.
enum LocationIdentifier: String, CaseIterable, Identifiable {
    case currentLocation = "current"
    case london = "london"
    case montevideo = "montevideo"
    case buenosAires = "buenosAires"
    
    var id: String { rawValue }
    
    /// Human-readable display name
    var displayName: String {
        switch self {
        case .currentLocation:
            return "Current Location"
        case .london:
            return "London"
        case .montevideo:
            return "Montevideo"
        case .buenosAires:
            return "Buenos Aires"
        }
    }
    
    /// Maps to the target city enum for API calls (nil for current location)
    var targetCity: TargetCity? {
        switch self {
        case .currentLocation:
            return nil
        case .london:
            return .london
        case .montevideo:
            return .montevideo
        case .buenosAires:
            return .buenosAires
        }
    }
    
    /// Icon for the location picker
    var icon: String {
        switch self {
        case .currentLocation:
            return "location.fill"
        case .london, .montevideo, .buenosAires:
            return "building.2.fill"
        }
    }
    
    /// Flag emoji for visual enhancement
    var flag: String {
        switch self {
        case .currentLocation:
            return "📍"
        case .london:
            return "🇬🇧"
        case .montevideo:
            return "🇺🇾"
        case .buenosAires:
            return "🇦🇷"
        }
    }
    
    /// Creates a LocationIdentifier from a persisted string value.
    /// Returns nil if the string is invalid or nil.
    init?(persistedValue: String?) {
        guard let value = persistedValue else { return nil }
        self.init(rawValue: value)
    }
}

// Note: TargetCity enum is defined in Networking/WeatherEndpoint.swift
