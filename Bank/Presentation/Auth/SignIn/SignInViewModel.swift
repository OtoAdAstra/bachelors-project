import Foundation
import SwiftUI

@MainActor
@Observable
final class SignInViewModel {
    var email: String = ""
    var password: String = ""
    var rememberMe: Bool = false
    var errorMessage: String?
    var isLoading: Bool = false

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func signIn() async {
        errorMessage = nil

        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = Error.emptyEmail.errorDescription
            return
        }
        guard !password.isEmpty else {
            errorMessage = Error.emptyPassword.errorDescription
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await authRepository.signIn(email: email, password: password, rememberMe: rememberMe)
        } catch let error as Error {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = Error.firebaseError(error.localizedDescription).errorDescription
        }
    }
    
}
