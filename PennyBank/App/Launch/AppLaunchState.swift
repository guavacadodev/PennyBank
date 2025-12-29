import Foundation
import Combine

@MainActor
final class AppLaunchState: ObservableObject {
    @Published var hasSeenOnboarding: Bool {
        didSet {
            store.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding)
        }
    }

    private let store: KeyValueStoring

    init(store: KeyValueStoring = UserDefaults.standard) {
        self.store = store
        self.hasSeenOnboarding = store.bool(forKey: Keys.hasSeenOnboarding)
    }
}

private enum Keys {
    static let hasSeenOnboarding = "hasSeenOnboarding"
}
