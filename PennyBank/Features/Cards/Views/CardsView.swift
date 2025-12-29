import SwiftUI

struct CardsView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            Text("My Cards")
        }
        .navigationTitle("My Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { CardsView() }
}

