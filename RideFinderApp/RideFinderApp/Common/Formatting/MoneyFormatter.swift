//
//  MoneyFormatter.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

enum MoneyFormatter {
    static func currencyString(fromCents cents: Int,
                               currencyCode: String = "USD",
                               using formatter: NumberFormatter = NumberFormatter()) -> String {
        let amount = NSDecimalNumber(value: cents).dividing(by: 100)
        let f = formatter
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        return f.string(from: amount) ?? "$0.00"
    }
}

