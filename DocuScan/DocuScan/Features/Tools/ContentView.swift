import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ToolsView()
                .tabItem {
                    Label(String(localized: "tab.tools"), systemImage: "wrench.and.screwdriver.fill")
                }

            RecentView()
                .tabItem {
                    Label(String(localized: "tab.recent"), systemImage: "clock.fill")
                }

            FavoritesView()
                .tabItem {
                    Label(String(localized: "tab.favorites"), systemImage: "star.fill")
                }

            SettingsView()
                .tabItem {
                    Label(String(localized: "tab.settings"), systemImage: "gear")
                }
        }
        .tint(Color.dsPrimary)
    }
}
