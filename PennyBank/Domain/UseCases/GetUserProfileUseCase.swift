import Foundation

struct GetUserProfileUseCase {
    let userProfileRepository: UserProfileRepository

    func execute() async throws -> UserProfile {
        try await userProfileRepository.fetchUserProfile()
    }
}

