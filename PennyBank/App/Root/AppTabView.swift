import SwiftUI

struct AppTabView: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment
    @State private var selectedTab: AppTab = .home
    @State private var isPresentingScan = false
    @State private var isPresentingMyCode = false
    @State private var shouldPresentMyCodeAfterScanDismiss = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(viewModel: appEnvironment.homeViewModel)
            }
            .tag(AppTab.home)

            NavigationStack {
                InsightsView()
            }
            .tag(AppTab.insights)

            NavigationStack {
                CardsView()
            }
            .tag(AppTab.cards)

            NavigationStack {
                ProfileView(viewModel: appEnvironment.profileViewModel)
            }
            .tag(AppTab.profile)
        }
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            AppTabBar(selectedTab: $selectedTab, onTapScan: { isPresentingScan = true })
        }
        .fullScreenCover(isPresented: $isPresentingScan) {
            ScanQRCodeView(
                onClose: { isPresentingScan = false },
                onShowMyCode: {
                    shouldPresentMyCodeAfterScanDismiss = true
                    isPresentingScan = false
                }
            )
        }
        .onChange(of: isPresentingScan) { _, isPresented in
            guard !isPresented, shouldPresentMyCodeAfterScanDismiss else { return }
            shouldPresentMyCodeAfterScanDismiss = false
            DispatchQueue.main.async {
                isPresentingMyCode = true
            }
        }
        .sheet(isPresented: $isPresentingMyCode) {
            MyQRCodeSheetView(codeString: "pennybank://me", onClose: { isPresentingMyCode = false })
                .presentationDetents([.fraction(0.82)])
                .presentationCornerRadius(28)
                .presentationDragIndicator(.hidden)
        }
    }
}

private enum AppTab: Hashable {
    case home
    case insights
    case cards
    case profile

    var title: String {
        switch self {
        case .home: "Home"
        case .insights: "Insights"
        case .cards: "My Cards"
        case .profile: "Profile"
        }
    }

    var systemImageName: String {
        switch self {
        case .home: "house"
        case .insights: "chart.bar"
        case .cards: "creditcard"
        case .profile: "person"
        }
    }
}

private struct AppTabBar: View {
    @Binding var selectedTab: AppTab
    let onTapScan: () -> Void

    var body: some View {
        HStack {
            tabButton(.home)
            tabButton(.insights)

            Spacer(minLength: 0)

            scanButton

            Spacer(minLength: 0)

            tabButton(.cards)
            tabButton(.profile)
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .background(.thinMaterial)
        .overlay(
            Rectangle()
                .fill(Color.appSeparator)
                .frame(height: 1),
            alignment: .top
        )
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.systemImageName)
                    .font(.system(size: 20, weight: .regular))
                Text(tab.title)
                    .font(.system(size: 11, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(selectedTab == tab ? Color.primary : Color.secondary)
        }
        .accessibilityLabel(tab.title)
    }

    private var scanButton: some View {
        Button {
            onTapScan()
        } label: {
            ZStack {
                CircularIconView(
                    systemImageName: "qrcode.viewfinder",
                    diameter: 54,
                    backgroundColor: Color.brandLime,
                    foregroundColor: .black,
                    font: .system(size: 22, weight: .semibold)
                )
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityLabel("Scan")
    }
}

#Preview {
    AppTabView()
        .environmentObject(AppEnvironment.live)
}
