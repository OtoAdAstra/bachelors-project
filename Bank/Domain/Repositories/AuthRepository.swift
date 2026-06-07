import Foundation

protocol AuthRepository {
    func signIn(email: String, password: String) async throws
    func signOut() throws
}
