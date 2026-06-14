import Foundation

protocol BiometricAuthenticator {
    var biometricType: BiometricType { get }
    var isAvailable: Bool { get }
    func authenticate(reason: String) async throws
}
