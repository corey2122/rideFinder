//
//  DistanceFormatterTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class DistanceFormatterTests: XCTestCase {
    func test_miles_roundsToOneDecimal() {
        XCTAssertEqual(DistanceFormatter.miles(1.24), "1.2 mi")
        XCTAssertEqual(DistanceFormatter.miles(1.26), "1.3 mi")
        XCTAssertEqual(DistanceFormatter.miles(0), "0.0 mi")
    }
}
