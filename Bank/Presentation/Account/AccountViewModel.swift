import Foundation

@MainActor
@Observable
final class AccountViewModel {
    var firstName: String = ""
    var lastName: String = ""
    var errorMessage: String?
    var successMessage: String?
    var isLoading: Bool = false

    private let loadProfileUseCase: LoadProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase

    init(
        loadProfileUseCase: LoadProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase
    ) {
        self.loadProfileUseCase = loadProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
    }

    func load() async {
        do {
            let profile = try await loadProfileUseCase.execute()
            firstName = profile.firstName
            lastName = profile.lastName
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func save() async {
        errorMessage = nil
        successMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await updateProfileUseCase.execute(firstName: firstName, lastName: lastName)
            successMessage = "Changes saved."
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
