import Foundation

struct MockTransactionsRepository: TransactionsRepository {
    func fetchRecentTransactions(limit: Int) async throws -> [Transaction] {
        let now = Date()
        let sample: [Transaction] = [
            Transaction(
                id: UUID(),
                title: "Figma",
                timestamp: now,
                category: "Subscriptions",
                direction: .outgoing,
                amount: MoneyAmount(value: 250.00)
            ),
            Transaction(
                id: UUID(),
                title: "Receive from Alex",
                timestamp: now.addingTimeInterval(-60 * 60 * 24),
                category: "Money In",
                direction: .incoming,
                amount: MoneyAmount(value: 580.00)
            ),
            Transaction(
                id: UUID(),
                title: "Medium",
                timestamp: now.addingTimeInterval(-60 * 60 * 24 * 30),
                category: "Subscriptions",
                direction: .outgoing,
                amount: MoneyAmount(value: 99.00)
            ),
        ]

        return Array(sample.prefix(limit))
    }
}

