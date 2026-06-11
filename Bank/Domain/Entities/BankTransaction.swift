import Foundation

/// A single ledger entry in the user's account.
/// Named `BankTransaction` to avoid colliding with `FirebaseFirestore.Transaction`.
struct BankTransaction: Identifiable, Equatable {
    enum Kind {
        case income
        case outcome
    }

    let id: String
    let kind: Kind
    let amount: Money
    let counterpartyName: String
    let counterpartyEmail: String
    let date: Date
}
