//
//  LoadingView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI

struct LoadingView: View {
    let title: String
    
    var body: some View {
        ProgressView(title)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
    }
}
