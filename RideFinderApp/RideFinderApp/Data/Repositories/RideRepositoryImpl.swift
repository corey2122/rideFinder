//
//  RideRepositoryImpl.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation
import CoreLocation

final class RideRepositoryImpl: RideRepository {
    private let api: RideAPI
   
    init(api: RideAPI) { self.api = api }

    func getRides(for driverId: String) async throws -> [Ride] {
        let dtos = try await api.fetchRides(for: driverId)
        let rides = dtos.map { dto in
            Ride(
                id: dto.tripUUID ?? dto.uuid ?? UUID().uuidString,
                endsAt: dto.endsAt,
                startsAt: dto.startsAt,
                estimatedEarningsCents: dto.estimatedEarningsCents,
                estimatedRideMiles: dto.estimatedRideMiles,
                estimatedRideMinutes: dto.estimatedRideMinutes,
                commuteRideMiles: dto.commuteRideMiles,
                commuteRideMinutes: dto.commuteRideMinutes,
                score: dto.score,
                waypoints: dto.orderedWaypoints.map { wp in
                    Ride.Waypoint(
                        id: wp.id,
                        address: wp.location.address,
                        coordinate: .init(latitude: wp.location.lat, longitude: wp.location.lng),
                        type: wp.waypointType
                    )
                },
                overviewPolyline: dto.overviewPolyline
            )
        }
        return rides.sorted { $0.score > $1.score }
    }
}
