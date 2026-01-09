//
//  NicolasCastApp.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import SwiftUI

@main
struct NicolasCastApp: App {
    
    var body: some Scene {
        WindowGroup {
            PagedWeatherView()
                .preferredColorScheme(.dark)
        }
    }
}
