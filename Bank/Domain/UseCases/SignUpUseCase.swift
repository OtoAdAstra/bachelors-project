import Foundation

protocol SignUpUseCase {
    func execute(
        title: String,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        repeatPassword: String
    ) async throws
}

/// Validates the registration form, creates the account, and persists the new session.
final class DefaultSignUpUseCase: SignUpUseCase {
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

    func execute(
        title: String,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        repeatPassword: String
    ) async throws {
        try validator.validateSignUp(
            title: title,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            repeatPassword: repeatPassword
        )
        let displayName = "\(title) \(firstName) \(lastName)"
        let session = try await authRepository.signUp(
            email: email,
            password: password,
            displayName: displayName
        )
        try sessionStorage.save(session)
    }
}
