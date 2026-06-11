import Foundation

protocol UpdateProfileUseCase {
    func execute(firstName: String, lastName: String) async throws
}

final class DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func execute(firstName: String, lastName: String) async throws {
        let first = firstName.trimmingCharacters(in: .whitespaces)
        let last = lastName.trimmingCharacters(in: .whitespaces)
        guard !first.isEmpty else { throw AuthError.emptyFirstName }
        guard !last.isEmpty else { throw AuthError.emptyLastName }
        try await profileRepository.updateName(firstName: first, lastName: last)
    }
}
