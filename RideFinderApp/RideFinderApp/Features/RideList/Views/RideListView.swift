//
//  RideListView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct RideListView: View {
    @StateObject var vm: RideListViewModel

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Available Rides", displayMode: .inline)
                .task { await vm.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            LoadingView(title: "Loading rides…")
        case .error(let message):
            ErrorView(message: message) { Task { await vm.load() } }
        case .loaded(let rides):
            if rides.isEmpty {
                EmptyStateView(
                    title: "No Rides",
                    subtitle: "There are no available rides right now.",
                    systemImage: "car"
                )
            } else {
                List(rides) { ride in
                    let rowVM = RideRowViewModel(ride: ride)
                    NavigationLink(
                        destination: RideDetailsView(vm: RideDetailsViewModel(ride: rowVM.model))
                    ) {
                        RideRowView(vm: rowVM)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct RideListView_Previews: PreviewProvider {
    static var previews: some View {
        RideListView(
            vm: RideListViewModel(
                fetchRides: { _ in [.init(
                    id: "preview-1",
                    endsAt: Date().addingTimeInterval(3600),
                    startsAt: Date(),
                    estimatedEarningsCents: 2500,
                    estimatedRideMiles: 12.3,
                    estimatedRideMinutes: 28,
                    commuteRideMiles: 3.2,
                    commuteRideMinutes: 7,
                    score: 0.87,
                    waypoints: [],
                    overviewPolyline: ""
                )] },
                driverId: "driver-123"
            )
        )
    }
}
