import Foundation

protocol SignInUseCase {
    func execute(email: String, password: String, rememberMe: Bool) async throws
}

/// Validates credentials, signs in, and persists the session only when "remember me" is on.
final class DefaultSignInUseCase: SignInUseCase {
    private let authRepository: AuthRepository
    private let sessionStorage: SessionStorage
    private let validator: CredentialValidator

    init(
        authRepository: AuthRepository,
        sessionStorage: SessionStorage,
        validator: CredentialValidator = CredentialValidator()
    ) {
        self.authRepository = authRepository
        self.sessionStorage = sessionStorage
        self.validator = validator
    }

    func execute(email: String, password: String, rememberMe: Bool) async throws {
        try validator.validateSignIn(email: email, password: password)
        let session = try await authRepository.signIn(email: email, password: password)
        if rememberMe {
            try sessionStorage.save(session)
        } else {
            try sessionStorage.clear()
        }
    }
}
