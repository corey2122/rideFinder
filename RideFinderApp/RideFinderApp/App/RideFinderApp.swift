//
//  RideFinderApp.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

@main
struct RideFinderApp: App {
    private let container = AppContainer.make()

    var body: some Scene {
        WindowGroup {
            RideListView(
                vm: RideListViewModel(
                    fetchRides: container.fetchRidesForDriver,
                    driverId: "driver-123"
                )
            )
        }
    }
}
