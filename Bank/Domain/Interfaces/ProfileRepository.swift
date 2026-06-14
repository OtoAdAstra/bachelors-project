import Foundation

protocol ProfileRepository {
    func createProfile(
        uid: String,
        email: String,
        title: String,
        firstName: String,
        lastName: String
    ) async throws
    func loadProfile() async throws -> UserProfile
    func updateName(firstName: String, lastName: String) async throws
}
