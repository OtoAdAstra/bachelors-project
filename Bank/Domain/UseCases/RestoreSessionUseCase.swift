import Foundation

protocol RestoreSessionUseCase {
    func execute() async
}

/// Decides whether a persisted session may be resumed on launch.
/// A stored session is only honored after a successful biometric check;
/// any failure signs the user out and clears local state.
final class DefaultRestoreSessionUseCase: RestoreSessionUseCase {
    private let authRepository: AuthRepository
    private let sessionStorage: SessionStorage
    private let biometricAuth: AuthenticateWithBiometricsUseCase

    init(
        authRepository: AuthRepository,
        sessionStorage: SessionStorage,
        biometricAuth: AuthenticateWithBiometricsUseCase
    ) {
        self.authRepository = authRepository
        self.sessionStorage = sessionStorage
        self.biometricAuth = biometricAuth
    }

    func execute() async {
        guard authRepository.isAuthenticated else { return }

        // No "remember me" session stored — don't auto-resume.
        guard sessionStorage.load() != nil else {
            try? authRepository.signOut()
            return
        }

        // No biometric hardware enrolled — allow the persisted session through.
        guard biometricAuth.isAvailable else { return }

        do {
            try await biometricAuth.execute()
        } catch {
            try? authRepository.signOut()
            try? sessionStorage.clear()
        }
    }
}
