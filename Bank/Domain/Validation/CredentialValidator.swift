import Foundation

struct CredentialValidator {

    private static let minPasswordLength = 6

    func validateSignIn(email: String, password: String) throws {
        try requireEmail(email)
        try requirePassword(password)
    }

    func validateSignUp(
        title: String,
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        repeatPassword: String
    ) throws {
        guard !isBlank(title) else { throw AuthError.emptyTitle }
        guard !isBlank(firstName) else { throw AuthError.emptyFirstName }
        guard !isBlank(lastName) else { throw AuthError.emptyLastName }
        try requireEmail(email)
        try requirePassword(password)
        guard password.count >= Self.minPasswordLength else { throw AuthError.weakPassword }
        guard password == repeatPassword else { throw AuthError.passwordMismatch }
    }

    private func requireEmail(_ email: String) throws {
        guard !isBlank(email) else { throw AuthError.emptyEmail }
    }

    private func requirePassword(_ password: String) throws {
        guard !password.isEmpty else { throw AuthError.emptyPassword }
    }

    private func isBlank(_ value: String) -> Bool {
        value.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
