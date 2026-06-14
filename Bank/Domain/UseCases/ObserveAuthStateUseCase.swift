import Foundation

protocol ObserveAuthStateUseCase {
    var currentValue: Bool { get }
    func execute() -> AsyncStream<Bool>
}

final class DefaultObserveAuthStateUseCase: ObserveAuthStateUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    var currentValue: Bool {
        authRepository.isAuthenticated
    }

    func execute() -> AsyncStream<Bool> {
        authRepository.authStateStream()
    }
}
