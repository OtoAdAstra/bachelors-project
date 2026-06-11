import Foundation

/// Persistence boundary for the user's profile document.
protocol ProfileRepository {
    /// Creates the backing profile document (called at sign-up). Balance starts at zero.
    func createProfile(
        uid: String,
        email: String,
        title: String,
        firstName: String,
        lastName: String
    ) async throws

    /// Loads the profile, creating a fallback document if one doesn't exist yet.
    func loadProfile() async throws -> UserProfile

    /// Updates the editable name fields (and keeps the auth display name in sync).
    func updateName(firstName: String, lastName: String) async throws
}
