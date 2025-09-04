//
//  FetchRidesForDriversUseCase.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

typealias FetchRidesForDriverUseCase = (_ driverId: String) async throws -> [Ride]
