import SwiftUI

struct RootView: View {

    @Environment(DiContainer.self) private var container
    @State private var authViewModel: AuthViewModel?

    var body: some View {
        Group {
            if let authViewModel {
                if authViewModel.isAuthenticated {
                    HomePlaceholderView()
                        .environment(authViewModel)
                } else {
                    NavigationStack {
                        SignInView(viewModel: container.makeSignInViewModel())
                    }
                    .environment(authViewModel)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            if authViewModel == nil {
                authViewModel = container.makeAuthViewModel()
            }
            await authViewModel?.observeAuthState()
        }
    }
}

private struct HomePlaceholderView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Signed in")
                .font(.title)
            Button("Sign Out") {
                authViewModel.signOut()
            }
        }
    }
}
