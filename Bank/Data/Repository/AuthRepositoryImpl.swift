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
            let token = try await result.user.getIDToken()
            try sessionStorage.save(Session(userId: result.user.uid, token: token))
        } else {
            try? sessionStorage.clear()
        }
    }

    func signUp(email: String, password: String, displayName: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        let token = try await result.user.getIDToken()
        try sessionStorage.save(Session(userId: result.user.uid, token: token))
    }

    func signOut() throws {
        try? sessionStorage.clear()
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

    func restoreSessionIfNeeded() async {
        guard Auth.auth().currentUser != nil else { return }
        if sessionStorage.load() == nil {
            try? Auth.auth().signOut()
        }
    }
}
