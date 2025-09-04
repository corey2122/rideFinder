//
//  Untitled.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

protocol RideAPI {
    func fetchRides(for driverId: String) async throws -> [RideDTO]
}

enum RideAPIError: Error { case resourceNotFound }
