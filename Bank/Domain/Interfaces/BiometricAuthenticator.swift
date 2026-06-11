import Foundation

/// Local biometric verification boundary (implemented via LocalAuthentication).
protocol BiometricAuthenticator {
    var biometricType: BiometricType { get }
    var isAvailable: Bool { get }
    func authenticate(reason: String) async throws
}
