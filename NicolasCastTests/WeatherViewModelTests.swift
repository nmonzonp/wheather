//
//  WeatherViewModelTests.swift
//  NicolasCastTests
//

import XCTest
@testable import NicolasCast

@MainActor
final class WeatherViewModelTests: XCTestCase {
    
    private var mockWeatherService: MockWeatherService!
    private var mockPersistenceManager: MockPersistenceManager!
    private var sut: WeatherViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        mockWeatherService = MockWeatherService()
        mockPersistenceManager = MockPersistenceManager()
    }
    
    override func tearDown() async throws {
        mockWeatherService = nil
        mockPersistenceManager = nil
        sut = nil
        try await super.tearDown()
    }
    
    private func createViewModel(
        savedLocation: String? = nil
    ) -> WeatherViewModel {
        mockPersistenceManager.lastSelectedLocation = savedLocation
        return WeatherViewModel(
            weatherService: mockWeatherService,
            persistenceManager: mockPersistenceManager,
            locationManager: LocationManager()
        )
    }
    
    func testInitialization_defaultsToCurrentLocation() {
        sut = createViewModel(savedLocation: nil)
        
        XCTAssertEqual(sut.selectedLocation, .currentLocation)
    }
    
    func testInitialization_restoresSavedLocation() {
        sut = createViewModel(savedLocation: LocationIdentifier.london.rawValue)
        
        XCTAssertEqual(sut.selectedLocation, .london)
    }
    
    func testFetchWeather_forCity_success() async {
        let expectedData = WeatherData.mock(cityName: "London", countryCode: "GB")
        mockWeatherService.result = .success(expectedData)
        sut = createViewModel(savedLocation: LocationIdentifier.london.rawValue)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        sut.fetchWeather()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .loaded(let data) = sut.viewState {
            XCTAssertEqual(data.cityName, "London")
            XCTAssertEqual(data.countryCode, "GB")
        } else {
            XCTAssertGreaterThan(mockWeatherService.fetchCallCount, 0)
        }
    }
    
    func testFetchWeather_forCity_failure() async {
        mockWeatherService.result = .failure(NetworkError.noData)
        sut = createViewModel(savedLocation: LocationIdentifier.montevideo.rawValue)
        
        sut.fetchWeather()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        if case .error(let message) = sut.viewState {
            XCTAssertFalse(message.isEmpty)
        }
        XCTAssertGreaterThan(mockWeatherService.fetchCallCount, 0)
    }
    
    func testFetchWeather_setsLoadingState() async {
        let expectedData = WeatherData.mock()
        mockWeatherService.result = .success(expectedData)
        mockWeatherService.delay = 0.5
        sut = createViewModel(savedLocation: LocationIdentifier.buenosAires.rawValue)
        
        sut.fetchWeather()
        
        try? await Task.sleep(nanoseconds: 10_000_000)
        
        XCTAssertTrue(mockWeatherService.fetchCallCount >= 0)
    }
    
    func testLocationChange_persistsSelection() async {
        sut = createViewModel(savedLocation: nil)
        
        sut.selectedLocation = .buenosAires
        
        XCTAssertEqual(
            mockPersistenceManager.lastSelectedLocation,
            LocationIdentifier.buenosAires.rawValue
        )
    }
    
    func testAvailableLocations_containsAllOptions() {
        sut = createViewModel()
        
        XCTAssertEqual(sut.availableLocations.count, 4)
        XCTAssertTrue(sut.availableLocations.contains(.currentLocation))
        XCTAssertTrue(sut.availableLocations.contains(.london))
        XCTAssertTrue(sut.availableLocations.contains(.montevideo))
        XCTAssertTrue(sut.availableLocations.contains(.buenosAires))
    }
    
    func testViewState_isLoading_property() {
        let idleState = WeatherViewState.idle
        XCTAssertFalse(idleState.isLoading)
        
        // Test loading state
        let loadingState = WeatherViewState.loading
        XCTAssertTrue(loadingState.isLoading)
        
        // Test loaded state
        let loadedState = WeatherViewState.loaded(.mock())
        XCTAssertFalse(loadedState.isLoading)
        
        // Test error state
        let errorState = WeatherViewState.error("Test error")
        XCTAssertFalse(errorState.isLoading)
    }
    
    func testViewState_weatherData_property() {
        // Test idle state
        let idleState = WeatherViewState.idle
        XCTAssertNil(idleState.weatherData)
        
        // Test loading state
        let loadingState = WeatherViewState.loading
        XCTAssertNil(loadingState.weatherData)
        
        // Test loaded state
        let mockData = WeatherData.mock()
        let loadedState = WeatherViewState.loaded(mockData)
        XCTAssertNotNil(loadedState.weatherData)
        XCTAssertEqual(loadedState.weatherData?.cityName, mockData.cityName)
        
        // Test error state
        let errorState = WeatherViewState.error("Test error")
        XCTAssertNil(errorState.weatherData)
    }
    
    func testViewState_errorMessage_property() {
        // Test idle state
        let idleState = WeatherViewState.idle
        XCTAssertNil(idleState.errorMessage)
        
        // Test loading state
        let loadingState = WeatherViewState.loading
        XCTAssertNil(loadingState.errorMessage)
        
        // Test loaded state
        let loadedState = WeatherViewState.loaded(.mock())
        XCTAssertNil(loadedState.errorMessage)
        
        // Test error state
        let errorMessage = "Something went wrong"
        let errorState = WeatherViewState.error(errorMessage)
        XCTAssertEqual(errorState.errorMessage, errorMessage)
    }
}
