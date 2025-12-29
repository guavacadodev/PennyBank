import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                balanceSection
                    .padding(.top, 8)

                quickActions

                transactionsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color.appBackground)
        .safeAreaInset(edge: .top, spacing: 0) {
            HomeNavigationBar(
                title: viewModel.state.greetingTitle,
                subtitle: viewModel.state.greetingSubtitle
            ) {
                NotificationButton(hasUnread: true) {
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Text("Total Balance")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)

                Button {
                    viewModel.toggleBalanceVisibility()
                } label: {
                    Image(systemName: viewModel.state.isBalanceHidden ? "eye.slash" : "eye")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(viewModel.state.isBalanceHidden ? "Show balance" : "Hide balance")
            }

            Text(viewModel.state.balanceText)
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.primary)
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            PillActionButton(
                title: "Transfer",
                systemImageName: "arrow.up",
                style: .filled,
                action: {}
            )

            PillActionButton(
                title: "Receive",
                systemImageName: "arrow.down",
                style: .filled,
                action: {}
            )

            PillActionButton(
                title: "",
                systemImageName: "line.3.horizontal",
                style: .iconOnly,
                action: {}
            )
        }
    }

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.state.transactionsTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)

                Button("See All") {}
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }

            VStack(spacing: 12) {
                ForEach(viewModel.state.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
    }
}

private struct NotificationButton: View {
    let hasUnread: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.primary)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)

                if hasUnread {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle().stroke(Color(.systemBackground), lineWidth: 2)
                        )
                        .offset(x: -2, y: 2)
                }
            }
        }
        .accessibilityLabel("Notifications")
    }
}

private struct HomeNavigationBar<Trailing: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.secondary)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                trailing()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)

            Rectangle()
                .fill(Color.appSeparator)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
    }
}

private struct PillActionButton: View {
    enum Style {
        case filled
        case iconOnly
    }

    let title: String
    let systemImageName: String
    let style: Style
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 34, height: 34)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )

                    Image(systemName: systemImageName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                }

                if style == .filled {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: style == .filled ? .infinity : 56)
            .frame(height: 48)
            .background(
                Capsule(style: .continuous)
                    .fill(style == .filled ? Color.brandLime : Color(.systemBackground))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.black.opacity(style == .filled ? 0 : 0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TransactionRow: View {
    let transaction: HomeViewModel.State.TransactionRow

    var body: some View {
        HStack(spacing: 12) {
            icon

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(transaction.subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 2) {
                Text(transaction.amountText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(transaction.category)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(iconBackground)
                .frame(width: 44, height: 44)

            Image(systemName: iconSymbolName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black.opacity(0.8))
        }
    }

    private var iconBackground: Color {
        switch transaction.kind {
        case .credit: Color.brandLime.opacity(0.6)
        case .debit: Color.secondary.opacity(0.15)
        }
    }

    private var iconSymbolName: String {
        switch transaction.kind {
        case .credit: "arrow.down"
        case .debit: "circle.fill"
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(
                getHomeDashboard: GetHomeDashboardUseCase(
                    accountRepository: MockAccountRepository(),
                    transactionsRepository: MockTransactionsRepository(),
                    userProfileRepository: MockUserProfileRepository()
                )
            )
        )
    }
}
