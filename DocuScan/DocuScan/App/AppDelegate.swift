import UIKit
import UserMessagingPlatform
import GoogleMobileAds
import AppTrackingTransparency

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        requestConsentAndStartAds()
        return true
    }

    private func requestConsentAndStartAds() {
        let params = UMPRequestParameters()
        params.tagForUnderAgeOfConsent = false

        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: params) { [weak self] error in
            guard error == nil else { return }
            // UMP callbacks arrive on an arbitrary thread — switch to main before accessing UIKit.
            DispatchQueue.main.async {
                self?.presentConsentFormIfRequired()
            }
        }
    }

    private func presentConsentFormIfRequired() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else { return }

        UMPConsentForm.loadAndPresentIfRequired(from: root) { [weak self] _ in
            // Step 2: UMP resolved — request ATT, then start AdMob.
            DispatchQueue.main.async {
                self?.requestATTThenStartAdMob()
            }
        }
    }

    private func requestATTThenStartAdMob() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            ATTrackingManager.requestTrackingAuthorization { [weak self] _ in
                DispatchQueue.main.async {
                    self?.startAdMob()
                }
            }
        } else {
            startAdMob()
        }
    }

    private func startAdMob() {
        GADMobileAds.sharedInstance().start()
    }
}
