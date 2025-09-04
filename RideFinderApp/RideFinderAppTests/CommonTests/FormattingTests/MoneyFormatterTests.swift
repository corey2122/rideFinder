//
//  MoneyFormatterTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class MoneyFormatterTests: XCTestCase {
    
    // Formatter that always returns nil
    final class NilFormatter: NumberFormatter, @unchecked Sendable {
        override func string(from number: NSNumber) -> String? { nil }
    }

    func test_currencyString_fallsBackToDefault_whenFormatterReturnsNil() {
        let s = MoneyFormatter.currencyString(fromCents: 12_345, using: NilFormatter())
        XCTAssertEqual(s, "$0.00")
    }
    
    func test_currencyString_defaultsToUSD() {
        let s = MoneyFormatter.currencyString(fromCents: 12345) // $123.45
        // Locale-safe assertions: check digits + a currency sign are present.
        XCTAssertTrue(s.contains("123.45") || s.contains("123,45"))
        XCTAssertTrue(s.contains("$"))
    }

    func test_currencyString_otherCurrency() {
        let s = MoneyFormatter.currencyString(fromCents: 9900, currencyCode: "EUR")
        // Different locales place symbol differently; assert numeric portion exists.
        XCTAssertTrue(s.contains("99.00") || s.contains("99,00"))
    }

    func test_currencyString_zeroAndNegative_doNotCrash() {
        XCTAssertTrue(MoneyFormatter.currencyString(fromCents: 0).contains("0"))
        _ = MoneyFormatter.currencyString(fromCents: -123) // should not crash
    }
}
