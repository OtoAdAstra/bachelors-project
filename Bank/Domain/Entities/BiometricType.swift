import Foundation

enum BiometricType {
    case none
    case faceID
    case touchID
}

enum BiometricError: LocalizedError {
    case notAvailable
    case cancelled
    case lockout
    case failed

    var errorDescription: String? {
        switch self {
        case .notAvailable: return "Biometric authentication is not available on this device."
        case .cancelled:    return "Authentication was cancelled."
        case .lockout:      return "Too many failed attempts. Please sign in with your password."
        case .failed:       return "Authentication failed. Please try again."
        }
    }
}
