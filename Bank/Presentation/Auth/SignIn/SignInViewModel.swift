import Foundation

@MainActor
@Observable
final class SignInViewModel {
    var email: String = ""
    var password: String = ""
    var rememberMe: Bool = false
    var errorMessage: String?
    var isLoading: Bool = false

    private let signInUseCase: SignInUseCase

    init(signInUseCase: SignInUseCase) {
        self.signInUseCase = signInUseCase
    }

    func signIn() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await signInUseCase.execute(email: email, password: password, rememberMe: rememberMe)
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = AuthError.underlying(error.localizedDescription).errorDescription
        }
    }
}
