import SwiftUI
import FirebaseCore

@main
struct BankApp: App {

    @State private var container: DiContainer

    init() {
        // Firebase must be configured before the DI container builds Firestore repositories.
        FirebaseApp.configure()
        _container = State(initialValue: DiContainer())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
                .preferredColorScheme(.dark)
        }
    }
}
