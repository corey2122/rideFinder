//
//  LabeledValueRow.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct LabeledValueRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(value)")
    }
}
