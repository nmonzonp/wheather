# NicolasCast Weather App

A weather app for iOS that shows real-time weather with smooth animations and a clean interface.

**Author:** Nicolas Monzon  
**Created:** January 8, 2026

## What It Does

This app pulls weather data from OpenWeatherMap and displays it with some nice visual touches:

- Real-time weather for your current location or preset cities (London, Montevideo, Buenos Aires)
- Animated backgrounds that change based on weather and time of day
- Smooth animations for weather icons and temperature changes
- Caches data so you're not hammering the API
- Works with VoiceOver and other accessibility features

## Getting Started

### 1. Get an API Key

You need an OpenWeatherMap API key to run this app:

1. Go to [https://openweathermap.org/api](https://openweathermap.org/api)
2. Sign up for a free account
3. Grab your API key from your account dashboard

### 2. Add Your API Key

1. Copy `NicolasCast/Configuration/Secrets.dist.xcconfig` to `Secrets.xcconfig` in the same folder
2. Open `Secrets.xcconfig` and replace `YOUR_KEY_HERE` with your actual API key:
   ```
   OPENWEATHER_API_KEY = your_actual_key_here
   ```

### 3. Run the App

1. Open `NicolasCast.xcodeproj` in Xcode
2. Pick a simulator or device
3. Hit Run (⌘R)

**Requirements:**
- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

## How It's Built

### Architecture

The app uses MVVM:
- **ViewModels** handle the logic and state
- **Views** are SwiftUI components
- **Models** represent the data
- **Services** talk to external stuff (API, location, storage)

### Project Structure

```
NicolasCast/
├── App/                    # App entry point
├── Configuration/          # API keys and config
├── Models/
│   ├── API/               # API response models
│   └── Domain/            # App data models
├── Networking/            # HTTP client
├── Services/              # Weather, location, persistence
├── ViewModels/            # MVVM ViewModels
├── Views/
│   ├── Screens/          # Main views
│   ├── Components/       # Reusable UI bits
│   └── Animations/       # Custom animations
└── Utils/                # Helpers and extensions

NicolasCastTests/         # Unit tests with mocks
NicolasCastUITests/       # UI tests
```

### Key Features

**Networking**
- Generic HTTP client with retry logic (tries 3 times with backoff)
- Type-safe API endpoints
- Friendly error messages

**Animations**
- "Breathing" aurora background that changes with weather and time
- Animated weather icons (sun pulses, clouds drift, rain bounces, etc.)
- Rolling temperature counter

**State Management**
Clean state enum pattern:
```swift
enum WeatherViewState {
    case idle
    case loading
    case loaded(WeatherData)
    case error(String)
}
```

**Data Handling**
- Caches weather data to reduce API calls
- Auto-refreshes stale data
- Refreshes when you come back to the app

## Testing

The app has unit tests for ViewModels and services. All external dependencies use mocks so tests run fast and don't need network access.

Run tests with ⌘U in Xcode.

## What's Next

Some ideas for future updates:
- Hourly and weekly forecasts
- Weather alerts
- Search for any city
- Home screen widgets
- More weather details (UV index, air quality)

---

Built by Nicolas Monzon
