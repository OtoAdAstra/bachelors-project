import Foundation
import FirebaseFirestore

/// Firestore document at `users/{uid}`.
/// `balance` is stored in plain dollars (so a value of 10000 means $10,000.00).
struct UserProfileDTO: Codable {
    @DocumentID var id: String?
    var email: String
    var title: String
    var firstName: String
    var lastName: String
    var displayName: String
    var balance: Double

    func toDomain(uid: String) -> UserProfile {
        UserProfile(uid: uid, email: email, title: title, firstName: firstName, lastName: lastName)
    }
}

/// Firestore document at `users/{uid}/transactions/{txId}`.
/// `amount` is stored in plain dollars.
struct TransactionDTO: Codable {
    @DocumentID var id: String?
    var type: String
    var amount: Double
    var counterpartyName: String
    var counterpartyEmail: String
    var date: Date

    func toDomain() -> BankTransaction? {
        guard let id else { return nil }
        let kind: BankTransaction.Kind = (type == "income") ? .income : .outcome
        return BankTransaction(
            id: id,
            kind: kind,
            amount: Money(dollars: amount),
            counterpartyName: counterpartyName,
            counterpartyEmail: counterpartyEmail,
            date: date
        )
    }
}
