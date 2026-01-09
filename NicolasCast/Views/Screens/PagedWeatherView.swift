//
//  PagedWeatherView.swift
//  NicolasCast
//

import SwiftUI

struct PagedWeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            backgroundView
            
            if let data = selectedWeatherData, data.weatherConditionId >= 801 {
                FloatingClouds()
                    .opacity(0.3)
            }
            
            VStack(spacing: 0) {
                pageIndicator
                    .padding(.top, 8)
                
                TabView(selection: $viewModel.selectedLocation) {
                    ForEach(viewModel.availableLocations) { location in
                        WeatherPageView(
                            viewModel: viewModel,
                            location: location
                        )
                        .tag(location)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: viewModel.selectedLocation) { _ in
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if let data = viewModel.viewState.weatherData, data.isStale {
                    viewModel.fetchWeather()
                }
            }
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if let data = viewModel.viewState.weatherData {
            BreathingBackground(
                weatherConditionId: data.weatherConditionId,
                isDaytime: data.isDaytime
            )
        } else {
            DefaultBreathingBackground()
        }
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.availableLocations) { location in
                Circle()
                    .fill(viewModel.selectedLocation == location ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .scaleEffect(viewModel.selectedLocation == location ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedLocation)
            }
        }
        .padding(.vertical, 12)
        .accessibilityHidden(true)
    }
    
    private var selectedWeatherData: WeatherData? {
        viewModel.viewState.weatherData
    }
}

struct WeatherPageView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    let location: LocationIdentifier
    
    var body: some View {
        VStack {
            Spacer()
            
            contentView
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            
            Spacer()
            
            locationLabel
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if location == viewModel.selectedLocation {
            switch viewModel.viewState {
            case .idle:
                EmptyView()
                
            case .loading:
                EnhancedLoadingView()
                
            case .loaded(let data):
                EnhancedWeatherCardView(weatherData: data)
                
            case .error(let message):
                ErrorView(
                    message: message,
                    onRetry: { viewModel.retry() },
                    onRequestPermission: location == .currentLocation && !viewModel.isLocationAuthorized
                        ? { viewModel.requestLocationPermission() }
                        : nil
                )
            }
        } else {
            Color.clear
        }
    }
    
    private var locationLabel: some View {
        HStack(spacing: 6) {
            if location == .currentLocation {
                Image(systemName: "location.fill")
                    .font(.system(size: 12, weight: .semibold))
            }
            
            Text(location.displayName)
                .font(.system(size: 14, weight: .medium, design: .rounded))
        }
        .foregroundColor(.white.opacity(0.7))
    }
}

#if DEBUG
struct PagedWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        PagedWeatherView()
    }
}
#endif
