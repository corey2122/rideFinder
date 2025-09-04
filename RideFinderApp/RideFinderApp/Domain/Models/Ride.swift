//
//  Ride.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation
import CoreLocation

struct Ride: Identifiable {
    let id: String
    let endsAt: Date
    let startsAt: Date

    let estimatedEarningsCents: Int
    let estimatedRideMiles: Double
    let estimatedRideMinutes: Int

    let commuteRideMiles: Double
    let commuteRideMinutes: Int

    let score: Double
    let waypoints: [Waypoint]
    let overviewPolyline: String

    struct Waypoint: Identifiable {
        let id: Int
        let address: String
        let coordinate: CLLocationCoordinate2D
        let type: WaypointType
    }
}
