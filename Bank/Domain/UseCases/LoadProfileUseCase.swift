import Foundation

protocol LoadProfileUseCase {
    func execute() async throws -> UserProfile
}

final class DefaultLoadProfileUseCase: LoadProfileUseCase {
    private let profileRepository: ProfileRepository

    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

    func execute() async throws -> UserProfile {
        try await profileRepository.loadProfile()
    }
}
