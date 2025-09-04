//
//  RideRowViewModelTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
import CoreLocation
@testable import RideFinderApp

@MainActor
final class RideRowViewModelTests: XCTestCase {

    private func makeRide(
        startAddr: String?,
        endAddr: String?,
        startType: WaypointType? = .pickUp,
        endType: WaypointType? = .dropOff,
        earningsCents: Int = 9_900,
        miles: Double = 7.25,
        mins: Int = 18,
        score: Double = 0.7
    ) -> Ride {
        var waypoints: [Ride.Waypoint] = []
        if let startAddr {
            waypoints.append(.init(id: 1, address: startAddr, coordinate: .init(latitude: 0, longitude: 0), type: startType ?? .pickUp))
        }
        if let endAddr {
            waypoints.append(.init(id: 2, address: endAddr, coordinate: .init(latitude: 0, longitude: 0), type: endType ?? .dropOff))
        }
        return Ride(
            id: "r",
            endsAt: Date(),
            startsAt: Date(),
            estimatedEarningsCents: earningsCents,
            estimatedRideMiles: miles,
            estimatedRideMinutes: mins,
            commuteRideMiles: 0,
            commuteRideMinutes: 0,
            score: score,
            waypoints: waypoints,
            overviewPolyline: ""
        )
    }

    func test_title_usesPickupAndDropoffWithFallbacks() {
        // Both present
        var vm = RideRowViewModel(ride: makeRide(
            startAddr: "A", endAddr: "B",
            startType: .pickUp, endType: .dropOff
        ))
        XCTAssertEqual(vm.title, "A → B")

        // Only start (pickup, no dropoff)
        vm = RideRowViewModel(ride: makeRide(
            startAddr: "A", endAddr: nil,
            startType: .pickUp, endType: nil
        ))
        XCTAssertEqual(vm.title, "A → N/A")

        // Only end (dropoff, no pickup)
        vm = RideRowViewModel(ride: makeRide(
            startAddr: nil, endAddr: "B",
            startType: nil, endType: .dropOff
        ))
        XCTAssertEqual(vm.title, "N/A → B")

        // Neither present
        vm = RideRowViewModel(ride: makeRide(
            startAddr: nil, endAddr: nil,
            startType: nil, endType: nil
        ))
        XCTAssertEqual(vm.title, "N/A → N/A")
    }


    func test_texts_and_scoreFormatting() {
        let vm = RideRowViewModel(ride: makeRide(
            startAddr: "A",
            endAddr: "B",
            earningsCents: 9_900,
            miles: 7.26,
            mins: 18,
            score: 0.7
        ))
        XCTAssertTrue(vm.earningsText.contains("99"))
        XCTAssertEqual(vm.metaText, "7.3 mi • 18 min")
        XCTAssertEqual(vm.score, 0.7, accuracy: 1e-9)
        XCTAssertEqual(vm.scoreText, "0.70")
    }
    
    func test_model_exposesRide() {
        let ride = makeRide(startAddr: "A", endAddr: "B")
        let vm = RideRowViewModel(ride: ride)
        XCTAssertEqual(vm.model.id, ride.id)
    }
}
