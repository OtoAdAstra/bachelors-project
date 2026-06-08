import Foundation

protocol AuthRepository {
    var isAuthenticated: Bool { get }
    func signIn(email: String, password: String) async throws
    func signOut() throws
    func authStateStream() -> AsyncStream<Bool>
}
