//
//  RideRepository.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

protocol RideRepository {
    func getRides(for driverId: String) async throws -> [Ride]
}
