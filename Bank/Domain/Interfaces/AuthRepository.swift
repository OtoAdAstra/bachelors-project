import Foundation

/// Authentication backend boundary (implemented by Firebase in the Data layer).
/// Knows nothing about session persistence or biometrics — use cases compose those.
protocol AuthRepository {
    var isAuthenticated: Bool { get }
    func signIn(email: String, password: String) async throws -> Session
    func signUp(email: String, password: String, displayName: String) async throws -> Session
    func signOut() throws
    func authStateStream() -> AsyncStream<Bool>
}
