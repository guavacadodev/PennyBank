import Foundation

struct HomeDashboard: Equatable {
    let userProfile: UserProfile
    let totalBalance: MoneyAmount
    let recentTransactions: [Transaction]
}

struct GetHomeDashboardUseCase {
    let accountRepository: AccountRepository
    let transactionsRepository: TransactionsRepository
    let userProfileRepository: UserProfileRepository

    func execute() async throws -> HomeDashboard {
        async let profile = userProfileRepository.fetchUserProfile()
        async let balance = accountRepository.fetchTotalBalance()
        async let transactions = transactionsRepository.fetchRecentTransactions(limit: 10)

        return HomeDashboard(
            userProfile: try await profile,
            totalBalance: try await balance,
            recentTransactions: try await transactions
        )
    }
}

