import FirebaseCore
import SwiftUI

@main
struct BankApp: App {

    @State private var container: DiContainer
    @Environment(\.scenePhase) private var scenePhase

    init() {
        FirebaseApp.configure()
        _container = State(initialValue: DiContainer())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
                .preferredColorScheme(.dark)
                .overlay {
                    if scenePhase != .active {
                        Color.black
                            .ignoresSafeArea()
                    }
                }
        }
    }
}
