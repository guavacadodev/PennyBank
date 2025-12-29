import SwiftUI

struct RootView: View {
    @StateObject private var launchState = AppLaunchState()

    var body: some View {
        Group {
            if launchState.hasSeenOnboarding {
                AppTabView()
            } else {
                OnboardingView(
                    viewModel: OnboardingViewModel(pages: OnboardingPage.defaultPages),
                    onFinish: { launchState.hasSeenOnboarding = true }
                )
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppEnvironment.live)
}
