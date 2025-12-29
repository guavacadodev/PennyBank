import Foundation

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let heroImageName: String
}

extension OnboardingPage {
    static let defaultPages: [OnboardingPage] = [
        OnboardingPage(
            title: "The Modern Way\nYour Money",
            subtitle: "Spend, save, and grow their money all\ntogether in on place.",
            heroImageName: "Onboarding1"
        ),
        OnboardingPage(
            title: "Pay Your Way\nWorldwide",
            subtitle: "Spend, save, and grow their money all\ntogether in on place.",
            heroImageName: "Onboarding2"
        ),
    ]
}

