import Foundation

enum Error: LocalizedError, Equatable {
    case emptyFields
    case invalidEmail
    case weakPassword
    case passwordMismatch

    case userNotFound
    case wrongPassword
    case emailAlreadyInUse
    case notAuthenticated

    case accountNotFound
    case transactionNotFound
    case insufficientBalance
    case invalidAmount
    case sameAccountTransfer

    case networkError
    case permissionDenied
    case decodingError
    case firebaseError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Please fill in all fields."

        case .invalidEmail:
            return "Please enter a valid email address."

        case .weakPassword:
            return "Password must be at least 6 characters."

        case .passwordMismatch:
            return "Passwords do not match."

        case .userNotFound:
            return "User was not found."

        case .wrongPassword:
            return "Incorrect password."

        case .emailAlreadyInUse:
            return "This email is already in use."

        case .notAuthenticated:
            return "You need to sign in first."

        case .accountNotFound:
            return "Bank account was not found."

        case .transactionNotFound:
            return "Transaction was not found."

        case .insufficientBalance:
            return "Insufficient balance."

        case .invalidAmount:
            return "Please enter a valid amount."

        case .sameAccountTransfer:
            return "You cannot transfer money to the same account."

        case .networkError:
            return "Network error. Please check your internet connection."

        case .permissionDenied:
            return "You do not have permission to perform this action."

        case .decodingError:
            return "Failed to read data."

        case .firebaseError(let message):
            return message

        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
