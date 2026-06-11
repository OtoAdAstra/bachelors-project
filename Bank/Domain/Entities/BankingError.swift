import Foundation

enum BankingError: LocalizedError {
    case notAuthenticated
    case invalidAmount
    case invalidEmail
    case selfTransfer
    case recipientNotFound
    case insufficientFunds
    case underlying(String)

    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "You are not signed in."
        case .invalidAmount:    return "Enter a valid amount."
        case .invalidEmail:     return "Enter a valid recipient email."
        case .selfTransfer:     return "You can't transfer money to yourself."
        case .recipientNotFound: return "No account found for that email."
        case .insufficientFunds: return "Insufficient funds."
        case .underlying(let message): return message
        }
    }
}
