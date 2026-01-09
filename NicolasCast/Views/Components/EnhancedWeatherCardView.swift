//
//  EnhancedWeatherCardView.swift
//  NicolasCast
//

import SwiftUI
struct EnhancedWeatherCardView: View {
    
    let weatherData: WeatherData
    
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 28) {
            cityHeader
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : -20)
            
            AnimatedWeatherIcon(
                sfSymbolName: weatherData.sfSymbolName,
                weatherConditionId: weatherData.weatherConditionId,
                size: 100
            )
            .frame(height: 120)
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.7)
            
            AnimatedTemperatureView(
                temperature: weatherData.currentTemp.value,
                fontSize: 80,
                fontWeight: .ultraLight
            )
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            
            Text(weatherData.formattedDescription)
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .opacity(isVisible ? 1 : 0)
            
            AnimatedMinMaxView(
                minTemp: weatherData.minTemp.value,
                maxTemp: weatherData.maxTemp.value
            )
            .opacity(isVisible ? 1 : 0)
            
            additionalInfoGrid
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 30)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(cardBackground)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
                isVisible = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var cityHeader: some View {
        VStack(spacing: 4) {
            Text(weatherData.cityName)
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            
            if let country = weatherData.countryCode {
                Text(country)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    private var additionalInfoGrid: some View {
        HStack(spacing: 24) {
            infoItem(
                icon: "drop.fill",
                value: weatherData.formattedHumidity,
                label: "Humidity"
            )
            
            Divider()
                .frame(height: 40)
                .background(Color.white.opacity(0.3))
            
            infoItem(
                icon: "thermometer",
                value: weatherData.formattedFeelsLike,
                label: "Feels Like"
            )
            
            if let windSpeed = weatherData.windSpeed {
                Divider()
                    .frame(height: 40)
                    .background(Color.white.opacity(0.3))
                
                infoItem(
                    icon: "wind",
                    value: String(format: "%.1f m/s", windSpeed),
                    label: "Wind"
                )
            }
        }
        .padding(.top, 8)
    }
    
    private func infoItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 32)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
    
    private var accessibilityLabel: String {
        """
        Current weather in \(weatherData.cityName). \
        \(Int(weatherData.currentTemp.value)) degrees Celsius, \
        \(weatherData.formattedDescription). \
        High of \(Int(weatherData.maxTemp.value)) degrees, \
        Low of \(Int(weatherData.minTemp.value)) degrees. \
        Humidity \(weatherData.formattedHumidity).
        """
    }
}

struct EnhancedLoadingView: View {
    
    @State private var isPulsing = false
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(spacing: 28) {
            ZStack {
                // Outer pulse ring
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    .frame(width: 160, height: 160)
                    .scaleEffect(isPulsing ? 1.3 : 0.9)
                    .opacity(isPulsing ? 0 : 0.6)
                
                // Inner pulse ring
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 120, height: 120)
                    .scaleEffect(isPulsing ? 1.2 : 0.95)
                    .opacity(isPulsing ? 0.3 : 0.8)
                
                // Rotating weather icon
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 60, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    
            }
            
            VStack(spacing: 12) {
                Text("Loading Weather")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 48)
        .padding(.horizontal, 32)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .accessibilityLabel("Loading weather data")
    }
}

#if DEBUG
struct EnhancedWeatherCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BreathingBackground(weatherConditionId: 800, isDaytime: true)
            
            EnhancedWeatherCardView(weatherData: .preview)
                .padding(.horizontal, 24)
        }
    }
}
#endif
