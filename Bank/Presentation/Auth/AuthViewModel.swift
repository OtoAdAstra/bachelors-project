import Foundation
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {
    var isAuthenticated: Bool

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.isAuthenticated = authRepository.isAuthenticated
    }

    func observeAuthState() async {
        for await authenticated in authRepository.authStateStream() {
            isAuthenticated = authenticated
        }
    }

    func signOut() {
        try? authRepository.signOut()
    }
}
