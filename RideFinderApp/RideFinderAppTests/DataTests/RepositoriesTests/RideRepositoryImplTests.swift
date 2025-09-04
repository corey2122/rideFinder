//
//  RideRepositoryImplTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
import CoreLocation
@testable import RideFinderApp

// MARK: - Test doubles
private final class FakeRideAPI: RideAPI {
    var result: Result<[RideDTO], Error>
    init(result: Result<[RideDTO], Error>) { self.result = result }
    func fetchRides(for driverId: String) async throws -> [RideDTO] {
        try result.get()
    }
}

private struct AnyError: Error {}

final class RideRepositoryImplTests: XCTestCase {

    // Helpers to make DTOs quickly
    private func makeWaypoint(id: Int, addr: String, lat: Double, lng: Double, type: String) -> RideDTO.WaypointDTO {
        .init(id: id, location: .init(address: addr, lat: lat, lng: lng), waypointType: WaypointType(rawValue: type) ?? .pickUp)
    }

    private func makeDTO(
        tripUUID: String? = nil,
        uuid: String? = nil,
        score: Double,
        startsAt: Date,
        endsAt: Date,
        waypoints: [RideDTO.WaypointDTO] = [],
        overviewPolyline: String = ""
    ) -> RideDTO {
        .init(
            tripUUID: tripUUID,
            uuid: uuid,
            endsAt: endsAt,
            startsAt: startsAt,
            estimatedEarningsCents: 1234,
            estimatedRideMiles: 12.3,
            estimatedRideMinutes: 27,
            commuteRideMiles: 3.4,
            commuteRideMinutes: 8,
            score: score,
            orderedWaypoints: waypoints,
            overviewPolyline: overviewPolyline
        )
    }

    func test_mapsDTOToDomain_includingWaypoints_andSortsByScoreDesc() async throws {
        let wp1 = makeWaypoint(id: 1, addr: "123 A St", lat: 38.5, lng: -120.2, type: "pickup")
        let wp2 = makeWaypoint(id: 2, addr: "456 B St", lat: 40.7, lng: -120.95, type: "dropoff")

        let d1 = makeDTO(tripUUID: "trip-1", uuid: nil, score: 0.6,
                         startsAt: Date(timeIntervalSince1970: 100),
                         endsAt:   Date(timeIntervalSince1970: 200),
                         waypoints: [wp1, wp2],
                         overviewPolyline: "_p~iF~ps|U_ulLnnqC_mqNvxq`@")
        let d2 = makeDTO(tripUUID: nil, uuid: "legacy-2", score: 0.9,
                         startsAt: Date(timeIntervalSince1970: 300),
                         endsAt:   Date(timeIntervalSince1970: 400),
                         waypoints: [], overviewPolyline: "")

        let api = FakeRideAPI(result: .success([d1, d2]))
        let sut = RideRepositoryImpl(api: api)

        let rides = try await sut.getRides(for: "driver-xyz")

        // Sorted by score DESC: d2 first, then d1
        XCTAssertEqual(rides.count, 2)
        XCTAssertEqual(rides[0].score, 0.9, accuracy: 1e-9)
        XCTAssertEqual(rides[1].score, 0.6, accuracy: 1e-9)

        // ID fallback logic
        XCTAssertEqual(rides[0].id, "legacy-2")     // from uuid
        XCTAssertEqual(rides[1].id, "trip-1")       // from tripUUID

        // Mapping fields
        let r1 = rides[1]
        XCTAssertEqual(r1.estimatedEarningsCents, 1234)
        XCTAssertEqual(r1.estimatedRideMiles, 12.3, accuracy: 1e-9)
        XCTAssertEqual(r1.estimatedRideMinutes, 27)
        XCTAssertEqual(r1.commuteRideMiles, 3.4, accuracy: 1e-9)
        XCTAssertEqual(r1.commuteRideMinutes, 8)
        XCTAssertEqual(r1.overviewPolyline, "_p~iF~ps|U_ulLnnqC_mqNvxq`@")

        // Waypoint mapping
        XCTAssertEqual(r1.waypoints.count, 2)
        XCTAssertEqual(r1.waypoints[0].id, 1)
        XCTAssertEqual(r1.waypoints[0].address, "123 A St")
        XCTAssertEqual(r1.waypoints[0].type, .pickUp)
        XCTAssertEqual(r1.waypoints[0].coordinate.latitude, 38.5, accuracy: 1e-9)
        XCTAssertEqual(r1.waypoints[0].coordinate.longitude, -120.2, accuracy: 1e-9)
    }

    func test_idFallback_generatesUUIDWhenBothNil() async throws {
        let dto = makeDTO(tripUUID: nil, uuid: nil, score: 0.1,
                          startsAt: Date(), endsAt: Date(), waypoints: [])
        let api = FakeRideAPI(result: .success([dto]))
        let sut = RideRepositoryImpl(api: api)

        let rides = try await sut.getRides(for: "d")
        XCTAssertEqual(rides.count, 1)
        XCTAssertFalse(rides[0].id.isEmpty) // generated UUID string
    }

    func test_propagatesAPIError() async {
        let api = FakeRideAPI(result: .failure(AnyError()))
        let sut = RideRepositoryImpl(api: api)

        do {
            _ = try await sut.getRides(for: "d")
            XCTFail("Expected error to be thrown")
        } catch {
            // success: error bubbled up
        }
    }
}
