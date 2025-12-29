import SwiftUI

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let heroImageName: String
    let currentPageIndex: Int
    let pageCount: Int
    let primaryAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)

            OnboardingHeroImageView(imageName: heroImageName)
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .padding(.horizontal, 16)

            Spacer(minLength: 24)

            VStack(spacing: 14) {
                Text(title)
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                OnboardingPageIndicator(currentIndex: currentPageIndex, pageCount: pageCount)
                    .padding(.top, 2)

                Button(action: primaryAction) {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.top, 26)
            .padding(.bottom, 24)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct OnboardingHeroImageView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(y: -70)
            .clipped()
            .accessibilityHidden(true)
    }
}

private struct OnboardingPageIndicator: View {
    let currentIndex: Int
    let pageCount: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.blue : Color.secondary.opacity(0.35))
                    .frame(width: 7, height: 7)
            }
        }
    }
}
