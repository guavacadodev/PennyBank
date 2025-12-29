import Foundation

protocol AccountRepository {
    func fetchTotalBalance() async throws -> MoneyAmount
}

