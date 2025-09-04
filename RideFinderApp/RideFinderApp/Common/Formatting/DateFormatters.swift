//
//  DateFormatters.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import Foundation

enum DateFormatters {
    static let date: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()
}
