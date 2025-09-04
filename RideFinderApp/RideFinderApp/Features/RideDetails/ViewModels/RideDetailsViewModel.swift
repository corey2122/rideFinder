//
//  RideDetailsViewModel.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import SwiftUI
import CoreLocation

final class RideDetailsViewModel: ObservableObject {
    @Published var ride: Ride
   
    init(ride: Ride) { self.ride = ride }

    private var pickup: Ride.Waypoint? {
        ride.waypoints.first { $0.type == .pickUp }
    }

    private var dropoff: Ride.Waypoint? {
        ride.waypoints.first { $0.type == .dropOff }
    }

    var startLine: String { pickup?.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? pickup!.address : "N/A" }
    var endLine: String   { dropoff?.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? dropoff!.address : "N/A" }
    var earningsText: String { MoneyFormatter.currencyString(fromCents: ride.estimatedEarningsCents) }
    var scoreText: String { String(format: "%.2f", ride.score) }
    var tripText: String {
        let distance = DistanceFormatter.miles(ride.estimatedRideMiles)
        let duration = DurationFormatter.minutes(ride.estimatedRideMinutes)
        return "\(distance) • \(duration)"
    }
    var commuteText: String {
        let distance = DistanceFormatter.miles(ride.commuteRideMiles)
        let duration = DurationFormatter.minutes(ride.commuteRideMinutes)
        return "\(distance) • \(duration)"
    }
    
    var startsAtText: String { DateFormatters.date.string(from: ride.startsAt) }
    var endsAtText: String { DateFormatters.date.string(from: ride.endsAt) }

    // Map
    var startCoordinate: CLLocationCoordinate2D? { ride.waypoints.first?.coordinate }
    var endCoordinate: CLLocationCoordinate2D? { ride.waypoints.last?.coordinate }
    var routeCoordinates: [CLLocationCoordinate2D] { PolylineDecoder.decode(ride.overviewPolyline) }

    var accessibilitySummary: String {
        "Ride from \(startLine) to \(endLine). Earnings \(earningsText). Score \(scoreText). Trip \(tripText). Commute \(commuteText)."
    }
}
