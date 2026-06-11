import SwiftUI

struct RootView: View {

    @Environment(DiContainer.self) private var container
    @Environment(\.scenePhase) private var scenePhase
    @State private var authViewModel: AuthViewModel?

    var body: some View {
        Group {
            if let authViewModel {
                content(for: authViewModel)
                    .environment(authViewModel)
            } else {
                ProgressView()
            }
        }
        .task {
            if authViewModel == nil {
                await container.restoreSessionUseCase.execute()
                authViewModel = container.makeAuthViewModel()
            }
            await authViewModel?.observeAuthStateChanges()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                authViewModel?.lockIfAuthenticated()
            }
        }
    }

    @ViewBuilder
    private func content(for authViewModel: AuthViewModel) -> some View {
        if authViewModel.isLocked {
            BiometricLockView()
        } else if authViewModel.isAuthenticated {
            NavigationStack {
                BalanceView(viewModel: container.makeBalanceViewModel())
            }
        } else {
            NavigationStack {
                SignInView(viewModel: container.makeSignInViewModel())
            }
        }
    }
}
