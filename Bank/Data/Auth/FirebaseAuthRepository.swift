import Foundation
import FirebaseAuth

/// Firebase-backed implementation of `AuthRepository`.
/// Purely an authentication gateway — persistence and biometrics live in use cases.
final class FirebaseAuthRepository: AuthRepository {

    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }

    func signIn(email: String, password: String) async throws -> Session {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return Session(userId: result.user.uid)
    }

    func signUp(email: String, password: String, displayName: String) async throws -> Session {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        return Session(userId: result.user.uid)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func authStateStream() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let handle = Auth.auth().addStateDidChangeListener { _, user in
                continuation.yield(user != nil)
            }
            continuation.onTermination = { _ in
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
}
