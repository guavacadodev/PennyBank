import Foundation

struct MockAccountRepository: AccountRepository {
    func fetchTotalBalance() async throws -> MoneyAmount {
        MoneyAmount(value: 12_765.00, currencyCode: "USD")
    }
}

