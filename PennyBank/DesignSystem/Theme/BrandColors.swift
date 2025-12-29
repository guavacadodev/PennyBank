import SwiftUI

extension Color {
    static let brandLime = Color(red: 0.84, green: 1.0, blue: 0.24)
    static var appSeparator: Color { Color(.separator).opacity(0.35) }
    static let appBackground = Color(
        UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return UIColor.systemGroupedBackground
            } else {
                return UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
            }
        }
    )
}
