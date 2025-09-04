//
//  MeasurementFormatter.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import Foundation

enum MeasurementFormatter {
    static func makeDistance() -> Foundation.MeasurementFormatter {
        let mf = Foundation.MeasurementFormatter()
        mf.unitStyle = .medium
        mf.unitOptions = .providedUnit
        return mf
    }
}
