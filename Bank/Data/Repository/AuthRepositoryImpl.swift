import Foundation
import FirebaseAuth

final class AuthRepositoryImpl: AuthRepository {

    private let sessionStorage: SessionStorage

    init(sessionStorage: SessionStorage) {
        self.sessionStorage = sessionStorage
    }

    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }

    func signIn(email: String, password: String, rememberMe: Bool) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        if rememberMe {
            try sessionStorage.save(Session(userId: result.user.uid))
        } else {
            try sessionStorage.clear()
        }
    }

    func signUp(email: String, password: String, displayName: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        try sessionStorage.save(Session(userId: result.user.uid))
    }

    func signOut() throws {
        try Auth.auth().signOut()
        try sessionStorage.clear()
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

    func restoreSessionIfNeeded() async {
        guard Auth.auth().currentUser != nil else { return }
        if sessionStorage.load() == nil {
            try? Auth.auth().signOut()
        }
    }
}
