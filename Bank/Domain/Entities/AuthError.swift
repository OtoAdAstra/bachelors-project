import Foundation

enum AuthError: LocalizedError {
    case emptyEmail
    case emptyPassword
    case emptyFirstName
    case emptyLastName
    case emptyTitle
    case invalidEmail
    case weakPassword
    case passwordMismatch
    case underlying(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .emptyEmail:       return "Email is required."
        case .emptyPassword:    return "Password is required."
        case .emptyFirstName:   return "First name is required."
        case .emptyLastName:    return "Last name is required."
        case .emptyTitle:       return "Please select a title."
        case .invalidEmail:     return "Enter a valid email."
        case .weakPassword:     return "Password must be at least 6 characters."
        case .passwordMismatch: return "Passwords do not match."
        case .underlying(let message): return message
        case .unknown:          return "Something went wrong."
        }
    }
}
