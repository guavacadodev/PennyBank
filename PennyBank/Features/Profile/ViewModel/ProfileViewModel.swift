import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    struct State: Equatable {
        struct MenuItem: Identifiable, Equatable {
            let id: String
            let systemImageName: String
            let title: String
            let isDestructive: Bool
        }

        var title: String
        var displayName: String
        var accountTypeName: String
        var menuItems: [MenuItem]
    }

    @Published private(set) var state = State(
        title: "Profile",
        displayName: "—",
        accountTypeName: "",
        menuItems: []
    )

    private let getUserProfile: GetUserProfileUseCase
    private var hasLoadedOnce = false

    init(getUserProfile: GetUserProfileUseCase) {
        self.getUserProfile = getUserProfile
    }

    func onAppear() {
        guard !hasLoadedOnce else { return }
        hasLoadedOnce = true

        Task { [weak self] in
            await self?.load()
        }
    }

    private func load() async {
        do {
            let profile = try await getUserProfile.execute()
            state.displayName = profile.displayName
            state.accountTypeName = profile.accountTypeName
        } catch {
            state.displayName = "—"
            state.accountTypeName = ""
        }

        state.menuItems = [
            State.MenuItem(id: "member_id", systemImageName: "qrcode", title: "Member ID", isDestructive: false),
            State.MenuItem(id: "settings", systemImageName: "gearshape", title: "Settings", isDestructive: false),
            State.MenuItem(id: "privacy", systemImageName: "lock", title: "Privacy & Security", isDestructive: false),
            State.MenuItem(id: "help", systemImageName: "questionmark.circle", title: "Help Center", isDestructive: false),
            State.MenuItem(id: "logout", systemImageName: "rectangle.portrait.and.arrow.right", title: "Log Out", isDestructive: true),
        ]
    }
}

