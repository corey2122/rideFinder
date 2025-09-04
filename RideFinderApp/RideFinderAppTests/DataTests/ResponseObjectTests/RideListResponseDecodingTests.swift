//
//  RideListResponseDecodingTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

final class RideListResponseDecodingTests: XCTestCase {

    private let iso = ISO8601DateFormatter()

    func test_decodesHappyPath_withPaginationAndISO8601Dates() throws {
        let json = """
        {
          "rides": [
            {
              "trip_uuid": "abc-123",
              "uuid": null,
              "ends_at": "2024-01-02T03:04:05Z",
              "starts_at": "2024-01-02T01:00:00Z",
              "estimated_earnings_cents": 2500,
              "estimated_ride_miles": 10.5,
              "estimated_ride_minutes": 22,
              "commute_ride_miles": 1.2,
              "commute_ride_minutes": 5,
              "score": 0.75,
              "ordered_waypoints": [
                {
                  "id": 1,
                  "location": { "address": "123 A St", "lat": 38.5, "lng": -120.2 },
                  "waypoint_type": "pick_up"
                }
              ],
              "overview_polyline": "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
            }
          ],
          "pagination": { "current_page": 1, "page_size": 50, "next_page": 2, "total_pages": 3 }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let res = try decoder.decode(RideListResponse.self, from: json)
        XCTAssertEqual(res.rides.count, 1)

        let r = res.rides[0]
        XCTAssertEqual(r.tripUUID, "abc-123")
        XCTAssertNil(r.uuid)
        XCTAssertEqual(iso.string(from: r.startsAt), "2024-01-02T01:00:00Z")
        XCTAssertEqual(iso.string(from: r.endsAt),   "2024-01-02T03:04:05Z")
        XCTAssertEqual(r.estimatedEarningsCents, 2500)
        XCTAssertEqual(r.estimatedRideMiles, 10.5, accuracy: 1e-9)
        XCTAssertEqual(r.orderedWaypoints.count, 1)
        XCTAssertEqual(r.orderedWaypoints.first?.waypointType, .pickUp)
        XCTAssertEqual(r.overviewPolyline, "_p~iF~ps|U_ulLnnqC_mqNvxq`@")

        XCTAssertEqual(res.pagination?.currentPage, 1)
        XCTAssertEqual(res.pagination?.pageSize, 50)
        XCTAssertEqual(res.pagination?.nextPage, 2)
        XCTAssertEqual(res.pagination?.totalPages, 3)
    }

    func test_decodesWithoutNextPage_andEmptyRides() throws {
        let json = """
        {
          "rides": [],
          "pagination": { "current_page": 1, "page_size": 25, "total_pages": 1 }
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let res = try decoder.decode(RideListResponse.self, from: json)
        XCTAssertTrue(res.rides.isEmpty)
        XCTAssertEqual(res.pagination?.currentPage, 1)
        XCTAssertEqual(res.pagination?.pageSize, 25)
        XCTAssertNil(res.pagination?.nextPage) // optional as intended
        XCTAssertEqual(res.pagination?.totalPages, 1)
    }
}
