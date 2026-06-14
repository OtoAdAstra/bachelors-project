import Foundation

protocol AuthRepository {
    var isAuthenticated: Bool { get }
    func signIn(email: String, password: String) async throws -> Session
    func signUp(email: String, password: String, displayName: String) async throws -> Session
    func signOut() throws
    func authStateStream() -> AsyncStream<Bool>
}
