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

final class DefaultSignUpUseCase: SignUpUseCase {
    private let authRepository: AuthRepository
    private let profileRepository: ProfileRepository
    private let sessionStorage: SessionStorage
    private let validator: CredentialValidator

    init(
        authRepository: AuthRepository,
        profileRepository: ProfileRepository,
        sessionStorage: SessionStorage,
        validator: CredentialValidator = CredentialValidator()
    ) {
        self.authRepository = authRepository
        self.profileRepository = profileRepository
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
        try await profileRepository.createProfile(
            uid: session.userId,
            email: email,
            title: title,
            firstName: firstName,
            lastName: lastName
        )
        try sessionStorage.save(session)
    }
}
