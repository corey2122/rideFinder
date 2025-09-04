//
//  RideDetailsView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct RideDetailsView: View {
    @ObservedObject var vm: RideDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                summary
                RideMapView(routeCoordinates: vm.routeCoordinates,
                            start: vm.startCoordinate,
                            end: vm.endCoordinate)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            .accessibilityLabel(vm.accessibilitySummary)
        }
        .navigationTitle("Ride Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vm.startLine)
            Text("→ \(vm.endLine)")
            Divider()
            LabeledValueRow(label: "Earnings", value: vm.earningsText)
            LabeledValueRow(label: "Score", value: vm.scoreText)
            LabeledValueRow(label: "Trip", value: vm.tripText)
            LabeledValueRow(label: "Commute", value: vm.commuteText)
            LabeledValueRow(label: "Starts", value: vm.startsAtText)
            LabeledValueRow(label: "Ends", value: vm.endsAtText)
        }
    }
}
