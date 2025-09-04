//
//  Address.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import Foundation
import CoreLocation

struct Address {
    let line1: String
    let city: String
    let state: String
    let zip: String
    let coordinate: CLLocationCoordinate2D
}
