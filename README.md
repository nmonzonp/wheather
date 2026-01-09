# NicolasCast Weather App
iOS weather application built with SwiftUI that brings weather data to life with stunning animations and an intuitive interface.

**Author:** Nicolas Monzon  
**Created:** January 8, 2026

## What This App Does

NicolasCast is a weather app that goes beyond just showing temperatures. It features:

- **Real-time weather data** from OpenWeatherMap API
- **Beautiful animated backgrounds** that change based on weather conditions and time of day
- **Smooth animations** including breathing aurora effects, animated weather icons, and rolling temperature counters
- **Multiple location support** - check weather for your current location or predefined cities (London, Montevideo, Buenos Aires)
- **Smart caching** with automatic refresh when data becomes stale
- **Accessibility support** throughout the app

## Architecture & Design

This app follows modern iOS development best practices:

### MVVM Architecture
- **ViewModels** handle business logic and state management
- **Views** are purely declarative SwiftUI components
- **Models** represent domain data with proper separation from API responses
- **Services** handle external dependencies (networking, location, persistence)

### Key Components

#### Networking Layer (`Networking/`)
- **APIClient**: Generic, protocol-based HTTP client with automatic retry logic
- **WeatherEndpoint**: Type-safe API endpoint definitions
- **NetworkError**: User-friendly error handling with localized messages
- Supports linear backoff retry (1s, 3s) for transient network failures

#### Services (`Services/`)
- **WeatherService**: Fetches weather data for coordinates or cities
- **LocationManager**: Manages device location with proper permission handling
- **PersistenceManager**: Lightweight UserDefaults wrapper for user preferences

#### Views (`Views/`)
The UI is organized into reusable components:
- **Screens**: Main container views (MainView, PagedWeatherView)
- **Components**: Reusable UI elements (WeatherCardView, ErrorView, LoadingView)
- **Animations**: Custom animated components (AnimatedBackground, AnimatedWeatherIcon, AnimatableNumberModifier)

### Design Highlights

**Dynamic Backgrounds**: The app features a "breathing" aurora effect that adapts to:
- Current weather conditions (clear, rain, snow, clouds, etc.)
- Time of day (day/night color schemes)
- Smooth transitions between states

**Animated Weather Icons**: SF Symbols with condition-specific animations:
- Sun pulses and rotates
- Clouds drift slowly
- Rain bounces
- Thunder flashes
- Snow gently spins

**Rolling Temperature Counter**: Temperatures animate smoothly using `AnimatableModifier` for a polished feel.

## Technical Implementation

### Dependencies
- **SwiftUI** for declarative UI
- **Combine** for reactive programming
- **CoreLocation** for device location
- **Foundation** for networking and data handling

### API Integration
Uses OpenWeatherMap API with:
- Current weather data endpoint
- Metric units (Celsius)
- Proper error handling and retry logic
- Response caching to minimize API calls

### State Management
The app uses a clean state enum pattern:
```swift
enum WeatherViewState {
    case idle
    case loading
    case loaded(WeatherData)
    case error(String)
}
```

### Testing
Includes comprehensive unit tests with:
- Mock implementations for all external dependencies
- Tests for ViewModels, state transitions, and persistence
- Proper async/await test patterns with `@MainActor`

## Project Structure

```
NicolasCast/
├── App/                    # App entry point
├── Configuration/          # API keys and config
├── Models/
│   ├── API/               # API response models
│   └── Domain/            # Domain models (WeatherData)
├── Networking/            # HTTP client and endpoints
├── Services/              # Business logic services
├── ViewModels/            # MVVM ViewModels
├── Views/
│   ├── Screens/          # Full-screen views
│   ├── Components/       # Reusable UI components
│   └── Animations/       # Custom animations
└── Utils/                # Extensions and helpers

NicolasCastTests/
├── Mocks/                # Test doubles
└── WeatherViewModelTests.swift

NicolasCastUITests/       # UI automation tests
```

## Setup & Configuration

1. **API Key**: Add your OpenWeatherMap API key to `Configuration/APIConfiguration.swift`
2. **Build**: Open `NicolasCast.xcodeproj` in Xcode
3. **Run**: Select a simulator or device and hit Run (⌘R)

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Features in Detail

### Location Support
- Automatic current location detection (with permission)
- Fallback to predefined cities if location is denied
- Remembers last selected location across app launches

### Data Freshness
- Weather data is cached to reduce API calls
- Automatically refreshes stale data (configurable interval)
- Refreshes when app returns to foreground

### Error Handling
- User-friendly error messages
- Specific handling for network issues, location errors, and API failures
- Retry functionality built into the UI

### Accessibility
- VoiceOver support throughout
- Semantic labels for all interactive elements
- Proper accessibility hints and traits

## Code Quality

This project emphasizes:
- **Dependency Injection** for testability
- **Protocol-based design** for flexibility
- **Async/await** for modern concurrency
- **Type safety** with Swift's strong typing
- **Clean separation of concerns**
- **Comprehensive error handling**

No AI-generated code slop - just clean, maintainable Swift code written by a human developer.

## Future Enhancements

Potential improvements:
- Hourly and weekly forecasts
- Weather alerts and notifications
- More cities and search functionality
- Weather widgets
- Dark mode refinements
- Additional weather data (UV index, air quality, etc.)

---

Built  by Nicolas Monzon
