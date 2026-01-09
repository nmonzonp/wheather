//
//  NicolasCastApp.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import SwiftUI

/// Main entry point for the Weather App.
/// Uses the enhanced PagedWeatherView for Apple Weather-like experience.
@main
struct NicolasCastApp: App {
    
    var body: some Scene {
        WindowGroup {
            PagedWeatherView()
                .preferredColorScheme(.dark) // Weather apps look best in dark mode
        }
    }
}
