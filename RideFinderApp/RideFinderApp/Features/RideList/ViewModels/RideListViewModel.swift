//
//  RideListViewModel.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation

@MainActor
final class RideListViewModel: ObservableObject {
    enum State { case idle,
                      loading,
                      loaded([Ride]),
                      error(String) }
    @Published private(set) var state: State = .idle

    private let fetchRides: FetchRidesForDriverUseCase
    private let driverId: String

    init(fetchRides: @escaping FetchRidesForDriverUseCase, driverId: String) {
        self.fetchRides = fetchRides
        self.driverId = driverId
    }

    func load() async {
        state = .loading
        do {
            let rides = try await fetchRides(driverId)
            state = .loaded(rides)
        } catch {
            state = .error("Failed to load rides. Please try again.")
        }
    }
    
    func retry() async { await load() }
}
