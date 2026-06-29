import UIKit
import UserMessagingPlatform
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        requestConsentAndStartAds()
        return true
    }

    private func requestConsentAndStartAds() {
        // Step 1: UMP consent (must happen before AdMob start)
        let params = UMPRequestParameters()
        params.tagForUnderAgeOfConsent = false

        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: params) { [weak self] error in
            guard error == nil else { return }
            self?.presentConsentFormIfRequired()
        }
    }

    private func presentConsentFormIfRequired() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }

        UMPConsentForm.loadAndPresentIfRequired(from: root) { [weak self] _ in
            // Step 2: After UMP resolved, check ATT + start AdMob
            self?.startAdMobIfConsented()
        }
    }

    private func startAdMobIfConsented() {
        // Step 3: Start Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start()
    }
}
