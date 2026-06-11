import Foundation

/// Composition root. Builds the dependency graph: Data → Use Cases → View Models.
@Observable
final class DiContainer {

    // MARK: Data layer
    private let authRepository: AuthRepository
    private let sessionStorage: SessionStorage
    private let biometricAuthenticator: BiometricAuthenticator

    // MARK: Use cases
    private let signInUseCase: SignInUseCase
    private let signUpUseCase: SignUpUseCase
    private let signOutUseCase: SignOutUseCase
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    private let biometricAuthUseCase: AuthenticateWithBiometricsUseCase
    let restoreSessionUseCase: RestoreSessionUseCase

    init() {
        // Data
        let authRepository = FirebaseAuthRepository()
        let sessionStorage = KeychainSessionStorage()
        let biometricAuthenticator = BiometricService()
        self.authRepository = authRepository
        self.sessionStorage = sessionStorage
        self.biometricAuthenticator = biometricAuthenticator

        // Use cases
        let biometricAuthUseCase = DefaultAuthenticateWithBiometricsUseCase(
            authenticator: biometricAuthenticator
        )
        self.biometricAuthUseCase = biometricAuthUseCase
        self.signInUseCase = DefaultSignInUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage
        )
        self.signUpUseCase = DefaultSignUpUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage
        )
        self.signOutUseCase = DefaultSignOutUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage
        )
        self.observeAuthStateUseCase = DefaultObserveAuthStateUseCase(
            authRepository: authRepository
        )
        self.restoreSessionUseCase = DefaultRestoreSessionUseCase(
            authRepository: authRepository,
            sessionStorage: sessionStorage,
            biometricAuth: biometricAuthUseCase
        )
    }

    // MARK: View model factories

    @MainActor
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            observeAuthState: observeAuthStateUseCase,
            signOutUseCase: signOutUseCase,
            biometricAuth: biometricAuthUseCase
        )
    }

    @MainActor
    func makeSignInViewModel() -> SignInViewModel {
        SignInViewModel(signInUseCase: signInUseCase)
    }

    @MainActor
    func makeSignUpViewModel() -> SignUpViewModel {
        SignUpViewModel(signUpUseCase: signUpUseCase)
    }
}
