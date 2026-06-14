import Foundation

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
