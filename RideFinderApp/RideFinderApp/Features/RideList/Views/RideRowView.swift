//
//  RideRowView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct RideRowView: View {
    @ObservedObject var vm: RideRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(vm.title)
                    .font(.body)
                Spacer()
                RideScoreBadge(score: vm.score)
            }
            HStack {
                Text(vm.earningsText)
                    .font(.subheadline).bold()
                Spacer()
                Text(vm.metaText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(vm.title). Earnings \(vm.earningsText). Score \(vm.scoreText)")
    }
}
