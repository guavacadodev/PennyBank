import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header
                    .padding(.top, 8)

                profileSummary

                menu
                    .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.onAppear()
        }
    }

    private var header: some View {
        HStack {
            Color.clear
                .frame(width: 40, height: 40)

            Spacer(minLength: 0)

            Text(viewModel.state.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer(minLength: 0)

            Color.clear
                .frame(width: 40, height: 40)
        }
    }

    private var profileSummary: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color.secondary.opacity(0.18))
                .frame(width: 84, height: 84)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(Color.secondary)
                )

            VStack(spacing: 4) {
                Text(viewModel.state.displayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(viewModel.state.accountTypeName)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var menu: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.state.menuItems.enumerated()), id: \.element.id) { index, item in
                ProfileMenuRow(
                    systemImageName: item.systemImageName,
                    title: item.title,
                    titleColor: item.isDestructive ? .red : .primary,
                    iconBackground: item.isDestructive ? Color.red.opacity(0.12) : Color.secondary.opacity(0.12),
                    action: {}
                )

                if index < viewModel.state.menuItems.count - 1 {
                    Divider()
                        .padding(.leading, 56)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
        )
    }
}

private struct ProfileMenuRow: View {
    let systemImageName: String
    let title: String
    let titleColor: Color
    let iconBackground: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 36, height: 36)

                    Image(systemName: systemImageName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(titleColor)
                }

                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(titleColor)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            viewModel: ProfileViewModel(
                getUserProfile: GetUserProfileUseCase(userProfileRepository: MockUserProfileRepository())
            )
        )
    }
}
