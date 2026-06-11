import Foundation

/// Secure persistence boundary for the user session (implemented by the Keychain).
protocol SessionStorage {
    func save(_ session: Session) throws
    func load() -> Session?
    func clear() throws
}
