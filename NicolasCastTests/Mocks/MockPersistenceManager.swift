//
//  MockPersistenceManager.swift
//  NicolasCastTests
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import Foundation
@testable import NicolasCast

final class MockPersistenceManager: PersistenceManagerProtocol {
    
    private var storage: [String: Any] = [:]
    
    private(set) var clearAllCallCount = 0
    
    var lastSelectedLocation: String? {
        get {
            storage["lastSelectedLocation"] as? String
        }
        set {
            if let value = newValue {
                storage["lastSelectedLocation"] = value
            } else {
                storage.removeValue(forKey: "lastSelectedLocation")
            }
        }
    }
    
    func clearAll() {
        clearAllCallCount += 1
        storage.removeAll()
    }
    
    func reset() {
        storage.removeAll()
        clearAllCallCount = 0
    }
}
