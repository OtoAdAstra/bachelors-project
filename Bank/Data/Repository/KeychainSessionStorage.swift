import Foundation

final class KeychainSessionStorage: SessionStorage {
    private enum Keys {
        static let userId = "session.userId"
        static let token = "session.token"
    }

    private let keychain: KeychainService

    init(keychain: KeychainService = KeychainService()) {
        self.keychain = keychain
    }

    func save(_ session: Session) throws {
        try keychain.setString(session.userId, for: Keys.userId)
        try keychain.setString(session.token, for: Keys.token)
    }

    func load() -> Session? {
        guard
            let userId = try? keychain.string(for: Keys.userId),
            let token = try? keychain.string(for: Keys.token)
        else { return nil }
        return Session(userId: userId, token: token)
    }

    func clear() throws {
        try keychain.remove(for: Keys.userId)
        try keychain.remove(for: Keys.token)
    }
}
