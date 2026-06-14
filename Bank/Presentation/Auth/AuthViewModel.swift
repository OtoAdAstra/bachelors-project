import Foundation

/// Owns global authentication + app-lock state for the session.
@MainActor
@Observable
final class AuthViewModel {
    var isAuthenticated: Bool
    var isLocked: Bool = false
    var biometricError: String?
    var errorMessage: String?

    var isBiometricAvailable: Bool { biometricAuth.isAvailable }
    var biometricType: BiometricType { biometricAuth.biometricType }

    private let observeAuthState: ObserveAuthStateUseCase
    private let signOutUseCase: SignOutUseCase
    private let biometricAuth: AuthenticateWithBiometricsUseCase

    init(
        observeAuthState: ObserveAuthStateUseCase,
        signOutUseCase: SignOutUseCase,
        biometricAuth: AuthenticateWithBiometricsUseCase
    ) {
        self.observeAuthState = observeAuthState
        self.signOutUseCase = signOutUseCase
        self.biometricAuth = biometricAuth
        self.isAuthenticated = observeAuthState.currentValue
    }

    func observeAuthStateChanges() async {
        for await authenticated in observeAuthState.execute() {
            isAuthenticated = authenticated
            if !authenticated { isLocked = false }
        }
    }

    func signOut() {
        do {
            try signOutUseCase.execute()
            isLocked = false
        } catch {
            errorMessage = "Couldn't sign out. Please try again."
        }
    }

    func lockIfAuthenticated() {
        guard isAuthenticated else { return }
        isLocked = true
        biometricError = nil
    }

    func unlockWithBiometrics() async {
        biometricError = nil
        do {
            try await biometricAuth.execute()
            isLocked = false
        } catch let error as BiometricError {
            switch error {
            case .cancelled:
                break
            case .lockout:
                biometricError = error.errorDescription
                signOut()
            default:
                biometricError = error.errorDescription
            }
        } catch {
            biometricError = error.localizedDescription
        }
    }
}
