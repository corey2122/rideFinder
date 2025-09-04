//
//  RideRowViewModel.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

@MainActor
final class RideRowViewModel: ObservableObject {
    private let ride: Ride

    init(ride: Ride) {
        self.ride = ride
    }
    
    var title: String {
        func clean(_ s: String?) -> String {
            guard let t = s?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !t.isEmpty else { return "N/A" }
            return t
        }

        let pickup = ride.waypoints.first { $0.type == .pickUp }
        let dropoff =  ride.waypoints.first { $0.type == .dropOff }

        let start = clean(pickup?.address)
        let end   = clean(dropoff?.address)

        return "\(start) → \(end)"
    }
    var earningsText: String { MoneyFormatter.currencyString(fromCents: ride.estimatedEarningsCents) }
    var metaText: String {
        let dist = DistanceFormatter.miles(ride.estimatedRideMiles)
        let dur  = DurationFormatter.minutes(ride.estimatedRideMinutes)
        return "\(dist) • \(dur)"
    }
    var score: Double { ride.score }
    var scoreText: String { String(format: "%.2f", ride.score) }

    var model: Ride { ride }
}
