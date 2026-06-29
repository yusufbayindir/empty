import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {
    @EnvironmentObject private var appEnvironment: AppEnvironment

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = appEnvironment.adService.currentBannerAdUnitID
        banner.rootViewController = context.coordinator.rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var rootViewController: UIViewController? {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }
    }
}

struct AdBannerContainer: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment

    var body: some View {
        if !appEnvironment.adService.isPremium {
            AdBannerView()
                .frame(height: Spacing.AdBanner.height)
                .frame(maxWidth: .infinity)
                .id("ad-banner-stable")
        }
    }
}
