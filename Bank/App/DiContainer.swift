import Foundation

@Observable
final class DiContainer {
    let authRepository: AuthRepository

    init() {
        self.authRepository = AuthRepositoryImpl()
    }

    @MainActor
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(authRepository: authRepository)
    }

    @MainActor
    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(authRepository: authRepository)
    }

    @MainActor
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(authRepository: authRepository)
    }
}
