import SwiftUI
import FirebaseCore

@main
struct BankApp: App {

    @State private var container = DiContainer()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
                .preferredColorScheme(.dark)
        }
    }
}
