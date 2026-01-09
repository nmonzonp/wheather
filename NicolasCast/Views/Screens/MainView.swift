//
//  MainView.swift
//  NicolasCast
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: WeatherViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    init(viewModel: WeatherViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? WeatherViewModel())
    }
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                locationPicker
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
                
                contentView
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                
                Spacer()
            }
            .padding(.bottom, 40)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.viewState)
        .onAppear {
            viewModel.fetchWeather()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if let weatherData = viewModel.viewState.weatherData,
                   weatherData.isStale {
                    viewModel.fetchWeather()
                }
            }
        }
    }
    
    @ViewBuilder
    private var backgroundGradient: some View {
        if let weatherData = viewModel.viewState.weatherData {
            weatherData.backgroundGradient
                .animation(.easeInOut(duration: 1.0), value: weatherData.weatherConditionId)
        } else {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var locationPicker: some View {
        Menu {
            ForEach(viewModel.availableLocations) { location in
                Button {
                    viewModel.selectedLocation = location
                } label: {
                    Label {
                        Text(location.displayName)
                    } icon: {
                        if location == viewModel.selectedLocation {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: viewModel.selectedLocation.icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(viewModel.selectedLocation.displayName)
                    .font(.system(size: 16, weight: .semibold))
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.viewState {
        case .idle:
            EmptyView()
            
        case .loading:
            LoadingView()
            
        case .loaded(let weatherData):
            WeatherCardView(weatherData: weatherData)
                .padding(.horizontal, 24)
            
        case .error(let message):
            ErrorView(
                message: message,
                onRetry: { viewModel.retry() },
                onRequestPermission: viewModel.selectedLocation == .currentLocation && !viewModel.isLocationAuthorized
                    ? { viewModel.requestLocationPermission() }
                    : nil
            )
            .padding(.horizontal, 24)
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
