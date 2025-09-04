# RideFinder

A sample iOS app that fetches and displays a driver’s rides using **SwiftUI**, **MVVM**, and **async/await**.  
This project demonstrates clean architecture, separation of concerns, and testability.

---

## Build & Run Instructions

### Requirements
- Xcode 15 or later
- iOS 17 SDK (minimum target iOS 16)
- Swift 5.9

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/corey2122/ridefinder.git
   cd ridefinder
   ```
2. Open `RideFinderApp.xcodeproj` in Xcode.
3. Select an iOS Simulator (e.g., iPhone 15).
4. Press **⌘R** to build and run.

### Running Tests
Run tests in Xcode:
- **Product → Test** (⌘U)

Or via command line:
```bash
xcodebuild   -project RideFinderApp.xcodeproj   -scheme RideFinder   -destination 'platform=iOS Simulator,name=iPhone 15'   test
```

---

## Architectural & Technical Decisions

- **MVVM + Use Case + Repository**: Clear separation between presentation, domain logic, and data access for easier testing and maintenance.
- **Dependency Injection via AppContainer**: Central place to wire `RideAPI` → `RideRepositoryImpl` and expose the `FetchRidesForDriverUseCase` closure: `(String) async throws -> [Ride]`.
- **Domain Model First**: UI works with a clean `Ride` model; DTOs (`RideListResponse`) stay in the data layer.
- **Error Handling**: Repository errors are converted to user-facing states in `RideListViewModel` (`idle`, `loading`, `loaded`, `error`).
- **Concurrency**: Swift **async/await**. `RideListViewModel` is `@MainActor` to ensure UI updates happen on the main thread.
- **Testability**: The ViewModel depends on a function (use case), so tests can inject success/failure behaviors without touching networking.

---

## Third-Party Libraries Used (and Why)

- **None** at runtime. The project uses Apple frameworks only (SwiftUI, Foundation; Combine where applicable).  
  If a real API client is added, it can use `URLSession` without additional dependencies.

---

## AI Tools Disclosure

AI tools (**ChatGPT, GPT-5**) were used to assist with:  
- Generating scaffolding code.  
- Suggesting unit test cases and edge conditions.  
- Drafting and polishing this README.  

All **architectural decisions, code implementations, and final reviews** were done by me.  
The AI acted as a helper, but the overall design and ownership of the project are mine.
