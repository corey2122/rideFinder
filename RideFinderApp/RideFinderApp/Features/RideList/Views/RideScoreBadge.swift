//
//  RideScoreBadge.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct RideScoreBadge: View {
    let score: Double
    var body: some View {
        Text(String(format: "%.1f", score))
            .font(.subheadline)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .accessibilityLabel("Ride score \(score)")
    }
}
