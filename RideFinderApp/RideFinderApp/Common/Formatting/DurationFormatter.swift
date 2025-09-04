//
//  DurationFormatter.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import Foundation

enum DurationFormatter {
    static func minutes(_ minutes: Int) -> String {
        let totalSeconds = TimeInterval(minutes * 60)
        let minutesPart = Int(totalSeconds) / 60
        return "\(minutesPart) min"
    }
}
