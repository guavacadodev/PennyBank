import Foundation

protocol UserProfileRepository {
    func fetchUserProfile() async throws -> UserProfile
}

