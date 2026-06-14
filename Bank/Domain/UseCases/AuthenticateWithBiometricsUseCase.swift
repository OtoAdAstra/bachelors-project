import Foundation

protocol AuthenticateWithBiometricsUseCase {
    var biometricType: BiometricType { get }
    var isAvailable: Bool { get }
    func execute() async throws
}

final class DefaultAuthenticateWithBiometricsUseCase: AuthenticateWithBiometricsUseCase {
    private static let reason = "Verify your identity to access SecureBank"

    private let authenticator: BiometricAuthenticator

    init(authenticator: BiometricAuthenticator) {
        self.authenticator = authenticator
    }

    var biometricType: BiometricType { authenticator.biometricType }
    var isAvailable: Bool { authenticator.isAvailable }

    func execute() async throws {
        try await authenticator.authenticate(reason: Self.reason)
    }
}
