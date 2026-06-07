import Foundation

enum Error: LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case weakPassword
    case firebaseError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Email is required."
        case .emptyPassword:
            return "Password is required."
        case .invalidEmail:
            return "Enter a valid email."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .firebaseError(let message):
            return message
        case .unknown:
            return "Something went wrong."
        }
    }
}
