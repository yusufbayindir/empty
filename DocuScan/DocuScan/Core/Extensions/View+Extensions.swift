import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.dsSurface)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.CornerRadius.card))
    }

    func withAdBanner() -> some View {
        self.safeAreaInset(edge: .bottom, spacing: 0) {
            AdBannerContainer()
        }
    }
}
