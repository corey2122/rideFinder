//
//  DateFormatterTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class DateFormatterTests: XCTestCase {

    func testDateFormatterFormatsMediumShort() {
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970 UTC
        let formatted = DateFormatters.date.string(from: date)

        // Example: "Jan 1, 1970 at 12:00 AM" (varies by locale/timezone)
        XCTAssertFalse(formatted.isEmpty)
    }
}
