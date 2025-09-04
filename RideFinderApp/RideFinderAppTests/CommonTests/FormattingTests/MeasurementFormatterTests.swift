//
//  MeasurementFormatterFactoryTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class MeasurementFormatterFactoryTests: XCTestCase {
    func test_makeDistance_configAndSampleString() {
        let mf = MeasurementFormatter.makeDistance()
        XCTAssertEqual(mf.unitStyle, .medium)
        XCTAssertEqual(mf.unitOptions, .providedUnit)

        let s = mf.string(from: Measurement(value: 1.0, unit: UnitLength.miles))
        XCTAssertTrue(s.contains("mi") || s.lowercased().contains("mile"))
    }
}
