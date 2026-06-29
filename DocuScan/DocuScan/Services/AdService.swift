import Foundation
import GoogleMobileAds
import UIKit

@MainActor
final class AdService: ObservableObject {
    @Published private(set) var interstitialAd: GADInterstitialAd?
    @Published private(set) var isPremium: Bool = false

    private var launchCount: Int {
        UserDefaults.standard.integer(forKey: "launchCount")
    }
    private var lastInterstitialTime: Date?
    private let interstitialInterval: TimeInterval = 60

    #if DEBUG
    private let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    private let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    private let bannerAdUnitID = "ca-app-pub-REPLACE_WITH_REAL_ID/BANNER"
    private let interstitialAdUnitID = "ca-app-pub-REPLACE_WITH_REAL_ID/INTERSTITIAL"
    #endif

    init() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        incrementLaunchCount()
        preloadInterstitial()
    }

    var currentBannerAdUnitID: String { bannerAdUnitID }

    func preloadInterstitial() {
        guard !isPremium else { return }
        let request = GADRequest()
        // swiftlint:disable:next identifier_name
        GADInterstitialAd.load(withAdUnitID: interstitialAdUnitID, request: request) { [weak self] ad, _ in
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self as? GADFullScreenContentDelegate
        }
    }

    func showInterstitialIfReady(from viewController: UIViewController) {
        guard !isPremium,
              launchCount > 3,
              let interstitial = interstitialAd,
              canShowInterstitial() else { return }

        interstitial.present(fromRootViewController: viewController)
        lastInterstitialTime = Date()
        interstitialAd = nil
        preloadInterstitial()
    }

    func unlockPremium() {
        isPremium = true
        UserDefaults.standard.set(true, forKey: "isPremium")
        interstitialAd = nil
    }

    private func canShowInterstitial() -> Bool {
        guard let last = lastInterstitialTime else { return true }
        return Date().timeIntervalSince(last) >= interstitialInterval
    }

    private func incrementLaunchCount() {
        UserDefaults.standard.set(launchCount + 1, forKey: "launchCount")
    }
}
