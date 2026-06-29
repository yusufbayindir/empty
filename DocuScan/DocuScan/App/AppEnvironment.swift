import SwiftUI
import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    let adService: AdService
    let documentStore: DocumentStore

    init() {
        self.adService = AdService()
        self.documentStore = DocumentStore()
    }
}
