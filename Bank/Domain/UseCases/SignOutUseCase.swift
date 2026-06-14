import Foundation

protocol SignOutUseCase {
    func execute() throws
}

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
