//
//  DurationFormatterTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class DurationFormatterTests: XCTestCase {
    func test_minutes_formatsWholeMinutes() {
        XCTAssertEqual(DurationFormatter.minutes(0), "0 min")
        XCTAssertEqual(DurationFormatter.minutes(1), "1 min")
        XCTAssertEqual(DurationFormatter.minutes(90), "90 min")
    }
}
