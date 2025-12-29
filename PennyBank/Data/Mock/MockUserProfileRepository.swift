import Foundation

struct MockUserProfileRepository: UserProfileRepository {
    func fetchUserProfile() async throws -> UserProfile {
        UserProfile(displayName: "Jennifer Lopez", accountTypeName: "Personal Account")
    }
}

