//
//  RideDetailsViewModelTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
import CoreLocation
@testable import RideFinderApp

final class RideDetailsViewModelTests: XCTestCase {

    // Helpers
    private func makeRide(
        id: String = "r1",
        startAddr: String = "123 A St",
        endAddr: String = "456 B Ave",
        start: CLLocationCoordinate2D = .init(latitude: 38.5, longitude: -120.2),
        end: CLLocationCoordinate2D = .init(latitude: 40.7, longitude: -120.95),
        startsAt: Date = Date(timeIntervalSince1970: 1_704_166_800), // 2024-01-02T01:00:00Z
        endsAt: Date = Date(timeIntervalSince1970: 1_704_164_645),   // 2024-01-02T03:04:05Z
        earningsCents: Int = 12_345,
        rideMiles: Double = 10.5,
        rideMins: Int = 22,
        commuteMiles: Double = 1.2,
        commuteMins: Int = 5,
        score: Double = 0.876,
        polyline: String = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
    ) -> Ride {
        let wps: [Ride.Waypoint] = [
            .init(id: 1, address: startAddr, coordinate: start, type: .pickUp),
            .init(id: 2, address: endAddr,   coordinate: end,   type: .dropOff),
        ]
        return Ride(
            id: id,
            endsAt: endsAt,
            startsAt: startsAt,
            estimatedEarningsCents: earningsCents,
            estimatedRideMiles: rideMiles,
            estimatedRideMinutes: rideMins,
            commuteRideMiles: commuteMiles,
            commuteRideMinutes: commuteMins,
            score: score,
            waypoints: wps,
            overviewPolyline: polyline
        )
    }

    func test_summaryFields_happyPath() {
        // Given
        let ride = makeRide()
        let vm = RideDetailsViewModel(ride: ride)

        // Then
        XCTAssertEqual(vm.startLine, "123 A St")
        XCTAssertEqual(vm.endLine, "456 B Ave")

        // Currency / score formatting
        XCTAssertTrue(vm.earningsText.contains("123.45")) // locale-safe numeric check
        XCTAssertEqual(vm.scoreText, "0.88") // rounded to 2 decimals

        // Distance/minute combos
        XCTAssertEqual(vm.tripText, "10.5 mi • 22 min")
        XCTAssertEqual(vm.commuteText, "1.2 mi • 5 min")

        // Map bits
        XCTAssertNotNil(vm.startCoordinate)
        XCTAssertNotNil(vm.endCoordinate)
        XCTAssertEqual(vm.routeCoordinates.count, 3) // known example decodes to 3 points

        // Accessibility summary is composed from the parts
        let summary = vm.accessibilitySummary
        XCTAssertTrue(summary.contains("123 A St"))
        XCTAssertTrue(summary.contains("456 B Ave"))
        XCTAssertTrue(summary.contains(vm.earningsText))
        XCTAssertTrue(summary.contains(vm.scoreText))
        XCTAssertTrue(summary.contains(vm.tripText))
        XCTAssertTrue(summary.contains(vm.commuteText))
    }

    func test_fallbacks_whenNoWaypoints() {
        let emptyRide = makeRide(startAddr: "", endAddr: "", polyline: "")
        let vm = RideDetailsViewModel(ride: emptyRide)

        // With no start/end addresses, VM falls back to labels
        XCTAssertEqual(vm.startLine, "N/A")
        XCTAssertEqual(vm.endLine, "N/A")
        XCTAssertTrue(vm.routeCoordinates.isEmpty)
    }

    func test_dateStrings_areConsistentWithSameFormatterConfig() {
        // Create a ride with fixed dates
        let starts = Date(timeIntervalSince1970: 1_704_166_800) // 2024-01-02T01:00:00Z
        let ends   = Date(timeIntervalSince1970: 1_704_164_645) // 2024-01-02T03:04:05Z
        let ride = makeRide(startsAt: starts, endsAt: ends)
        let vm = RideDetailsViewModel(ride: ride)

        // Build an equivalent formatter (same styles as VM uses)
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short

        XCTAssertEqual(vm.startsAtText, f.string(from: starts))
        XCTAssertEqual(vm.endsAtText,   f.string(from: ends))
    }
}
