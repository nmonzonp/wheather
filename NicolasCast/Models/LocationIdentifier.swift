//
//  LocationIdentifier.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//  Defines selectable locations for the weather app
//

import Foundation


enum LocationIdentifier: String, CaseIterable, Identifiable {
    case currentLocation = "current"
    case london = "london"
    case montevideo = "montevideo"
    case buenosAires = "buenosAires"
    
    var id: String { rawValue }
    
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
    
    var icon: String {
        switch self {
        case .currentLocation:
            return "location.fill"
        case .london, .montevideo, .buenosAires:
            return "building.2.fill"
        }
    }
    
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
    
    init?(persistedValue: String?) {
        guard let value = persistedValue else { return nil }
        self.init(rawValue: value)
    }
}

