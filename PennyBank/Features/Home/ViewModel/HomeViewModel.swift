import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    struct State: Equatable {
        struct TransactionRow: Identifiable, Equatable {
            enum Kind: Equatable {
                case debit
                case credit
            }

            let id: UUID
            let title: String
            let subtitle: String
            let category: String
            let amountText: String
            let kind: Kind
        }

        var greetingTitle: String
        var greetingSubtitle: String
        var isBalanceHidden: Bool
        var balanceText: String
        var transactionsTitle: String
        var transactions: [TransactionRow]
    }

    @Published private(set) var state = State(
        greetingTitle: "Hi, —",
        greetingSubtitle: "",
        isBalanceHidden: false,
        balanceText: "—",
        transactionsTitle: "Transactions",
        transactions: []
    )

    private let getHomeDashboard: GetHomeDashboardUseCase
    private var latestBalance: MoneyAmount?
    private var hasLoadedOnce = false

    init(getHomeDashboard: GetHomeDashboardUseCase) {
        self.getHomeDashboard = getHomeDashboard
    }

    func onAppear() {
        guard !hasLoadedOnce else { return }
        hasLoadedOnce = true

        Task { [weak self] in
            await self?.load()
        }
    }

    func toggleBalanceVisibility() {
        state.isBalanceHidden.toggle()
        if let latestBalance {
            state.balanceText = formatBalance(latestBalance)
        }
    }

    private func load() async {
        do {
            let dashboard = try await getHomeDashboard.execute()
            latestBalance = dashboard.totalBalance

            state.greetingTitle = "Hi, \(dashboard.userProfile.displayName)"
            state.greetingSubtitle = "Good Morning!"
            state.balanceText = formatBalance(dashboard.totalBalance)
            state.transactions = dashboard.recentTransactions.map(mapTransactionRow)
        } catch {
            state.greetingTitle = "Hi"
            state.greetingSubtitle = "Good Morning!"
            state.balanceText = "—"
            state.transactions = []
        }
    }

    private func formatBalance(_ balance: MoneyAmount) -> String {
        state.isBalanceHidden ? "••••••" : formatCurrency(balance)
    }

    private func mapTransactionRow(_ transaction: Transaction) -> State.TransactionRow {
        let amountText: String
        let kind: State.TransactionRow.Kind

        switch transaction.direction {
        case .incoming:
            amountText = "+\(formatCurrency(transaction.amount))"
            kind = .credit
        case .outgoing:
            amountText = "-\(formatCurrency(transaction.amount))"
            kind = .debit
        }

        return State.TransactionRow(
            id: transaction.id,
            title: transaction.title,
            subtitle: formatTimestamp(transaction.timestamp),
            category: transaction.category,
            amountText: amountText,
            kind: kind
        )
    }

    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatCurrency(_ amount: MoneyAmount) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = amount.currencyCode
        return formatter.string(from: amount.value as NSDecimalNumber) ?? "\(amount.value)"
    }
}

