//
//  ErrorView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
  
    var body: some View {
        VStack(spacing: 12) {
            Text(message)
            Button("Retry", action: retry)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
