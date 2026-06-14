import Foundation

protocol RestoreSessionUseCase {
    func execute() async
}

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

        guard sessionStorage.load() != nil else {
            try? authRepository.signOut()
            return
        }

        guard biometricAuth.isAvailable else { return }

        do {
            try await biometricAuth.execute()
        } catch {
            try? authRepository.signOut()
            try? sessionStorage.clear()
        }
    }
}
