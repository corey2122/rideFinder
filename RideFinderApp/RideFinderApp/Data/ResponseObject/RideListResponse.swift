//
//  RideListResponse.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

enum WaypointType: String, Decodable {
    case pickUp = "pick_up"
    case dropOff = "drop_off"
}

struct RideListResponse: Decodable {
    let rides: [RideDTO]
    let pagination: Pagination?
}

struct Pagination: Decodable {
    let currentPage: Int
    let pageSize: Int
    let nextPage: Int?
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case pageSize = "page_size"
        case nextPage = "next_page"
        case totalPages = "total_pages"
    }
}

struct RideDTO: Decodable {
    struct WaypointDTO: Decodable {
        let id: Int
        let location: LocationDTO
        let waypointType: WaypointType

        enum CodingKeys: String, CodingKey {
            case id, location
            case waypointType = "waypoint_type"
        }
    }

    struct LocationDTO: Decodable {
        let address: String
        let lat: Double
        let lng: Double
    }

    let tripUUID: String?
    let uuid: String?
    let endsAt: Date
    let startsAt: Date

    let estimatedEarningsCents: Int
    let estimatedRideMiles: Double
    let estimatedRideMinutes: Int

    let commuteRideMiles: Double
    let commuteRideMinutes: Int

    let score: Double
    let orderedWaypoints: [WaypointDTO]
    let overviewPolyline: String

    enum CodingKeys: String, CodingKey {
        case tripUUID = "trip_uuid"
        case uuid
        case endsAt = "ends_at"
        case startsAt = "starts_at"
        case estimatedEarningsCents = "estimated_earnings_cents"
        case estimatedRideMiles = "estimated_ride_miles"
        case estimatedRideMinutes = "estimated_ride_minutes"
        case commuteRideMiles = "commute_ride_miles"
        case commuteRideMinutes = "commute_ride_minutes"
        case score
        case orderedWaypoints = "ordered_waypoints"
        case overviewPolyline = "overview_polyline"
    }
}
