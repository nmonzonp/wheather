//
//  PersistenceManager.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
import Combine

// Note: LocationIdentifier is defined in Models/LocationIdentifier.swift

protocol PersistenceManagerProtocol {
    var lastSelectedLocation: String? { get set }
    func clearAll()
}

private enum PersistenceKey: String {
    case lastSelectedLocation = "lastSelectedLocation"
}

final class UserDefaultsPersistenceManager: PersistenceManagerProtocol {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var lastSelectedLocation: String? {
        get {
            defaults.string(forKey: PersistenceKey.lastSelectedLocation.rawValue)
        }
        set {
            if let value = newValue {
                defaults.set(value, forKey: PersistenceKey.lastSelectedLocation.rawValue)
            } else {
                defaults.removeObject(forKey: PersistenceKey.lastSelectedLocation.rawValue)
            }
        }
    }
    
    func clearAll() {
        defaults.removeObject(forKey: PersistenceKey.lastSelectedLocation.rawValue)
    }
}
