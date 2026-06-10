import Foundation

protocol AuthRepository {
    var isAuthenticated: Bool { get }
    func signIn(email: String, password: String, rememberMe: Bool) async throws
    func signUp(email: String, password: String, displayName: String) async throws
    func signOut() throws
    func authStateStream() -> AsyncStream<Bool>
    func restoreSessionIfNeeded() async
}
