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

    private let signUpUseCase: SignUpUseCase

    init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    func signUp() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await signUpUseCase.execute(
                title: title,
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                repeatPassword: repeatPassword
            )
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = AuthError.underlying(error.localizedDescription).errorDescription
        }
    }
}
