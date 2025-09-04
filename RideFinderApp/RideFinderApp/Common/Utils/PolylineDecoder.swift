//
//  PolylineDecoder.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//
import CoreLocation

enum PolylineDecoder {
    static func decode(_ encoded: String) -> [CLLocationCoordinate2D] {
        let trimmed = encoded.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let bytes = Array(trimmed.utf8)
        var coords: [CLLocationCoordinate2D] = []
        var index = 0, lat = 0, lon = 0

        @inline(__always)
        func nextDelta() -> Int? {
            var result = 0, shift = 0
            while index < bytes.count {
                let b = Int(bytes[index]) - 63
                index += 1
                result |= (b & 0x1F) << shift
                if b < 0x20 {
                    return (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
                }
                shift += 5
                if shift > 30 { break } // safety
            }
            return nil
        }

        while index < bytes.count {
            guard let dLat = nextDelta() else { break }
            lat += dLat
            guard let dLon = nextDelta() else { break }
            lon += dLon
            coords.append(.init(latitude: Double(lat) * 1e-5,
                                longitude: Double(lon) * 1e-5))
        }
        return coords
    }
}
