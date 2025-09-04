//
//  RideListViewModelTests.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/29/25.
//

import XCTest
@testable import RideFinderApp

@MainActor
final class RideListViewModelTests: XCTestCase {

    private final class FakeRideRepository: RideRepository {
        var result: Result<[Ride], Error>

        init(result: Result<[Ride], Error>) {
            self.result = result
        }

        func getRides(for driverId: String) async throws -> [Ride] {
            return try result.get()
        }
    }

    actor DelayRepo: RideRepository {
        let rides: [Ride]
        init(rides: [Ride]) { self.rides = rides }
        func getRides(for driverId: String) async throws -> [Ride] {
            try? await Task.sleep(nanoseconds: 50_000) // 0.05 ms
            return rides
        }
    }

    // MARK: - Helpers
    private func makeRide(id: String = "r", score: Double = 0.5) -> Ride {
        Ride(
            id: id,
            endsAt: Date(),
            startsAt: Date(),
            estimatedEarningsCents: 1000,
            estimatedRideMiles: 1.0,
            estimatedRideMinutes: 5,
            commuteRideMiles: 0.0,
            commuteRideMinutes: 0,
            score: score,
            waypoints: [],
            overviewPolyline: ""
        )
    }

    private func useCase(from repo: RideRepository) -> FetchRidesForDriverUseCase {
        { driverId in try await repo.getRides(for: driverId) }
    }

    private func assertLoaded(_ sut: RideListViewModel, ids expected: [String]) {
        switch sut.state {
        case .loaded(let rides):
            XCTAssertEqual(rides.map(\.id), expected)
        default:
            XCTFail("Expected .loaded, got \(sut.state)")
        }
    }

    private func assertError(_ sut: RideListViewModel) {
        switch sut.state {
        case .error:
            break
        default:
            XCTFail("Expected .error, got \(sut.state)")
        }
    }

    func test_load_success_setsLoaded() async {
        let expected = [makeRide(id: "a"), makeRide(id: "b")]
        let repo = FakeRideRepository(result: .success(expected))
        let sut = RideListViewModel(fetchRides: useCase(from: repo), driverId: "driver-123")

        await sut.load()

        assertLoaded(sut, ids: ["a", "b"])
    }

    func test_load_transitions_loading_then_loaded() async {
        let repo = DelayRepo(rides: [makeRide(id: "z")])
        let sut = RideListViewModel(fetchRides: useCase(from: repo), driverId: "x")

        let task = Task { await sut.load() }
        await Task.yield()

        await task.value
        assertLoaded(sut, ids: ["z"])
    }

    func test_load_failure_setsError() async {
        // Given
        enum TestError: Error { case fail }
        let repo = FakeRideRepository(result: .failure(TestError.fail))
        let sut = RideListViewModel(fetchRides: useCase(from: repo), driverId: "x")

        // When
        await sut.load()

        // Then
        assertError(sut)
    }

    func test_retry_invokesUseCaseTwice_and_endsLoaded() async {
        // Given
        final class CountingRepo: RideRepository {
            var count = 0
            func getRides(for driverId: String) async throws -> [Ride] {
                count += 1
                return [Ride(
                    id: "r\(count)",
                    endsAt: Date(),
                    startsAt: Date(),
                    estimatedEarningsCents: 1000,
                    estimatedRideMiles: 1.0,
                    estimatedRideMinutes: 5,
                    commuteRideMiles: 0.0,
                    commuteRideMinutes: 0,
                    score: 0.5,
                    waypoints: [],
                    overviewPolyline: ""
                )]
            }
        }

        let repo = CountingRepo()
        let sut = RideListViewModel(fetchRides: useCase(from: repo), driverId: "x")

        // When
        await sut.load()
        await sut.retry()

        // Then
        XCTAssertEqual(repo.count, 2, "Expected load + retry to call use case twice")
        switch sut.state {
        case .loaded(let rides):
            XCTAssertEqual(rides.count, 1)
        default:
            XCTFail("Expected .loaded after retry, got \(sut.state)")
        }
    }
}
