import Foundation

final class KeychainSessionStorage: SessionStorage {
    private enum Keys {
        static let userId = "session.userId"
    }

    private let keychain: KeychainService

    init(keychain: KeychainService = KeychainService()) {
        self.keychain = keychain
    }

    func save(_ session: Session) throws {
        try keychain.setString(session.userId, for: Keys.userId)
    }

    func load() -> Session? {
        guard let userId = try? keychain.string(for: Keys.userId) else { return nil }
        return Session(userId: userId)
    }

    func clear() throws {
        try keychain.remove(for: Keys.userId)
    }
}
