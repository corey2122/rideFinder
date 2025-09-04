//
//  AppContainer.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

final class AppContainer {
    let repository: RideRepository
    let fetchRidesForDriver: FetchRidesForDriverUseCase

    private init(repository: RideRepository) {
        self.repository = repository
        self.fetchRidesForDriver = { driverId in
            try await repository.getRides(for: driverId)
        }
    }

    static func make() -> AppContainer {
        let api = MockRideAPI()
        let repository = RideRepositoryImpl(api: api)
        return AppContainer(repository: repository)
    }
}
