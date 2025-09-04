//
//  PolylineDecoderTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
import CoreLocation
@testable import RideFinderApp

final class PolylineDecoderTests: XCTestCase {

    func test_decode_knownGoogleExample() {
        // From Google's polyline docs:
        let encoded = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
        let coords = PolylineDecoder.decode(encoded)

        XCTAssertEqual(coords.count, 3)

        let tol = 1e-5
        XCTAssertEqual(coords[0].latitude, 38.5, accuracy: tol)
        XCTAssertEqual(coords[0].longitude, -120.2, accuracy: tol)

        XCTAssertEqual(coords[1].latitude, 40.7, accuracy: tol)
        XCTAssertEqual(coords[1].longitude, -120.95, accuracy: tol)

        XCTAssertEqual(coords[2].latitude, 43.252, accuracy: tol)
        XCTAssertEqual(coords[2].longitude, -126.453, accuracy: tol)
    }

    func test_decode_emptyOrWhitespace_returnsEmpty() {
        XCTAssertTrue(PolylineDecoder.decode("").isEmpty)
        XCTAssertTrue(PolylineDecoder.decode("  \n\t ").isEmpty)
    }

    func test_decode_truncated_returnsNoPoints() {
        let coords = PolylineDecoder.decode("_p~iF")
        XCTAssertTrue(coords.isEmpty)
    }

    func test_decode_garbage_doesNotCrash() {
        _ = PolylineDecoder.decode("!@#$%^&*()")
        _ = PolylineDecoder.decode("a")
        _ = PolylineDecoder.decode("////")
    }
}
