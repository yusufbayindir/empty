import SwiftUI
import UIKit

@main
struct DocuScanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var appEnvironment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(appEnvironment)
            } else {
                OnboardingView()
                    .environmentObject(appEnvironment)
            }
        }
    }
}
