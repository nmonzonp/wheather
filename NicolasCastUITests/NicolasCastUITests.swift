//
//  NicolasCastUITests.swift
//  NicolasCastUITests
//
//  Created by Nicolas Monzon on 08/01/2026.
//

import XCTest

final class NicolasCastUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        

    }
    
    override func tearDownWithError() throws {}
    
    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
