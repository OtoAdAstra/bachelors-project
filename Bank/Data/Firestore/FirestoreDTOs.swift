import Foundation
import FirebaseFirestore

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
