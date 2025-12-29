import Foundation

protocol TransactionsRepository {
    func fetchRecentTransactions(limit: Int) async throws -> [Transaction]
}

