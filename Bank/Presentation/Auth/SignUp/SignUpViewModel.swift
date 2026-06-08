import Foundation

@MainActor
@Observable
final class SignUpViewModel {
    static let titles: [String] = ["Mr", "Ms", "Mrs", "Dr", "Mx"]

    var title: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var repeatPassword: String = ""
    var errorMessage: String?
    var isLoading: Bool = false

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func signUp() async {
        errorMessage = nil

        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = Error.emptyTitle.errorDescription
            return
        }
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = Error.emptyFirstName.errorDescription
            return
        }
        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = Error.emptyLastName.errorDescription
            return
        }
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = Error.emptyEmail.errorDescription
            return
        }
        guard !password.isEmpty else {
            errorMessage = Error.emptyPassword.errorDescription
            return
        }
        guard password.count >= 6 else {
            errorMessage = Error.weakPassword.errorDescription
            return
        }
        guard password == repeatPassword else {
            errorMessage = Error.passwordMismatch.errorDescription
            return
        }

        isLoading = true
        defer { isLoading = false }

        let displayName = "\(title) \(firstName) \(lastName)"

        do {
            try await authRepository.signUp(email: email, password: password, displayName: displayName)
        } catch let error as Error {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = Error.firebaseError(error.localizedDescription).errorDescription
        }
    }
}
