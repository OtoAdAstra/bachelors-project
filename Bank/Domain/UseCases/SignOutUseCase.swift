import Foundation

protocol SignOutUseCase {
    func execute() throws
}

/// Revokes the backend session first, then clears local storage.
/// Errors propagate so a failed wipe is never silently ignored.
final class DefaultSignOutUseCase: SignOutUseCase {
    private let authRepository: AuthRepository
    private let sessionStorage: SessionStorage

    init(authRepository: AuthRepository, sessionStorage: SessionStorage) {
        self.authRepository = authRepository
        self.sessionStorage = sessionStorage
    }

    func execute() throws {
        try authRepository.signOut()
        try sessionStorage.clear()
    }
}
