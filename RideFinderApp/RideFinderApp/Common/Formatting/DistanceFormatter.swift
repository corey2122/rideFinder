//
//  DistanceFormatter.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import Foundation

enum DistanceFormatter {
    static func miles(_ miles: Double) -> String {
        let rounded = String(format: "%.1f", miles)
        return "\(rounded) mi"
    }
}
