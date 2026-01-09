//
//  WeatherCardView.swift
//  NicolasCast
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import SwiftUI

/// Reusable card component displaying weather information.
/// Features SF Symbols for weather icons, clean typography, and subtle animations.
struct WeatherCardView: View {
    
    // MARK: - Properties
    
    let weatherData: WeatherData
    
    @State private var isAnimating = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
            // City name and country
            VStack(spacing: 4) {
                Text(weatherData.cityName)
                    .font(.system(size: 32, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                if let countryCode = weatherData.countryCode {
                    Text(countryCode)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            // Weather icon with animation
            weatherIcon
                .frame(height: 100)
            
            // Current temperature
            Text(weatherData.formattedCurrentTempFull)
                .font(.system(size: 72, weight: .thin, design: .rounded))
                .foregroundColor(.white)
            
            // Weather description
            Text(weatherData.formattedDescription)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
            
            // Min/Max temperatures
            HStack(spacing: 24) {
                temperatureItem(
                    label: "L:",
                    value: weatherData.formattedMinTemp,
                    icon: "arrow.down"
                )
                
                temperatureItem(
                    label: "H:",
                    value: weatherData.formattedMaxTemp,
                    icon: "arrow.up"
                )
            }
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white.opacity(0.8))
            
            // Additional info
            HStack(spacing: 32) {
                infoItem(icon: "drop.fill", value: weatherData.formattedHumidity)
                infoItem(icon: "thermometer", value: "Feels \(weatherData.formattedFeelsLike)")
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white.opacity(0.7))
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 30 )
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Subviews
    
    private var weatherIcon: some View {
        Image(systemName: weatherData.sfSymbolName)
            .font(.system(size: 80, weight: .medium))
            .symbolRenderingMode(weatherData.iconIsMulticolor ? .multicolor : .hierarchical)
            .foregroundStyle(.white)
            .scaleEffect(isAnimating ? 1.0 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.0)
    }
    
    private func temperatureItem(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
            Text(label)
            Text(value)
                .fontWeight(.semibold)
        }
    }
    
    private func infoItem(icon: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(value)
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        """
        Current weather in \(weatherData.cityName). \
        \(weatherData.formattedCurrentTempFull), \
        \(weatherData.formattedDescription). \
        High of \(weatherData.formattedMaxTemp), \
        Low of \(weatherData.formattedMinTemp). \
        Humidity \(weatherData.formattedHumidity).
        """
    }
}

// MARK: - Preview

#if DEBUG
struct WeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            WeatherCardView(weatherData: .preview)
                .padding()
        }
    }
}
#endif

// Note: WeatherData.preview is defined in Models/Domain/WeatherData.swift
