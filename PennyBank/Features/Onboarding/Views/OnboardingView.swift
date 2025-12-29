import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    let onFinish: () -> Void

    init(viewModel: OnboardingViewModel, onFinish: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TabView(selection: $viewModel.currentPageIndex) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(
                        title: page.title,
                        subtitle: page.subtitle,
                        heroImageName: page.heroImageName,
                        currentPageIndex: viewModel.currentPageIndex,
                        pageCount: viewModel.pages.count,
                        primaryAction: { primaryAction(for: index) }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Button("Skip") {
                onFinish()
            }
            .buttonStyle(SkipButtonStyle())
            .padding(.leading, 20)
            .padding(.top, 12)
        }
        .background(Color.appBackground)
    }

    private func primaryAction(for index: Int) {
        guard index == viewModel.currentPageIndex else { return }
        withAnimation(.easeInOut) {
            viewModel.advanceOrFinish(finish: onFinish)
        }
    }
}

#Preview {
    OnboardingView(
        viewModel: OnboardingViewModel(pages: OnboardingPage.defaultPages),
        onFinish: {}
    )
}
