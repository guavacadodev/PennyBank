import Foundation
import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    let accountRepository: AccountRepository
    let transactionsRepository: TransactionsRepository
    let userProfileRepository: UserProfileRepository

    lazy var homeViewModel: HomeViewModel = {
        HomeViewModel(
            getHomeDashboard: GetHomeDashboardUseCase(
                accountRepository: accountRepository,
                transactionsRepository: transactionsRepository,
                userProfileRepository: userProfileRepository
            )
        )
    }()

    lazy var profileViewModel: ProfileViewModel = {
        ProfileViewModel(
            getUserProfile: GetUserProfileUseCase(userProfileRepository: userProfileRepository)
        )
    }()

    init(
        accountRepository: AccountRepository,
        transactionsRepository: TransactionsRepository,
        userProfileRepository: UserProfileRepository
    ) {
        self.accountRepository = accountRepository
        self.transactionsRepository = transactionsRepository
        self.userProfileRepository = userProfileRepository
    }
}

extension AppEnvironment {
    static let live = AppEnvironment(
        accountRepository: MockAccountRepository(),
        transactionsRepository: MockTransactionsRepository(),
        userProfileRepository: MockUserProfileRepository()
    )
}
