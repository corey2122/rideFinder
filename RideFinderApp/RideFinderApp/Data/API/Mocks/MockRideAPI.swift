//
//  MockRideAPI.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

final class MockRideAPI: RideAPI {
    func fetchRides(for driverId: String) async throws -> [RideDTO] {
        try await Task.sleep(nanoseconds: 120_000_000)
        guard let url = Bundle.main.url(forResource: "rides_sample", withExtension: "json") else {
            throw RideAPIError.resourceNotFound
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(RideListResponse.self, from: data)
        return response.rides
    }
}
