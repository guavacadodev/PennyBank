import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPageIndex: Int = 0

    let pages: [OnboardingPage]

    init(pages: [OnboardingPage]) {
        self.pages = pages
    }

    func advanceOrFinish(finish: () -> Void) {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
        } else {
            finish()
        }
    }
}
