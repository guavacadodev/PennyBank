import SwiftUI

struct CircularIconView: View {
    let systemImageName: String

    var diameter: CGFloat = 44
    var backgroundColor: Color = Color(.systemBackground)
    var foregroundColor: Color = .primary
    var font: Font = .system(size: 18, weight: .medium)
    var strokeColor: Color? = nil
    var strokeLineWidth: CGFloat = 0

    var body: some View {
        Circle()
            .fill(backgroundColor)
            .frame(width: diameter, height: diameter)
            .overlay {
                if let strokeColor, strokeLineWidth > 0 {
                    Circle()
                        .stroke(strokeColor, lineWidth: strokeLineWidth)
                }
            }
            .overlay(
                Image(systemName: systemImageName)
                    .font(font)
                    .foregroundStyle(foregroundColor)
            )
    }
}

