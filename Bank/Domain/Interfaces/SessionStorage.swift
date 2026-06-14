import Foundation

protocol SessionStorage {
    func save(_ session: Session) throws
    func load() -> Session?
    func clear() throws
}
