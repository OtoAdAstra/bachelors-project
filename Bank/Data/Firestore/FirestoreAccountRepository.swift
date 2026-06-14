import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirestoreAccountRepository: AccountRepository {

    private let db = Firestore.firestore()
    private var users: CollectionReference { db.collection("users") }

    func balanceStream() -> AsyncStream<Money> {
        AsyncStream { continuation in
            guard let uid = Auth.auth().currentUser?.uid else {
                continuation.finish()
                return
            }
            let listener = users.document(uid).addSnapshotListener { snapshot, _ in
                let dollars = (snapshot?.data()?["balance"] as? NSNumber)?.doubleValue ?? 0
                continuation.yield(Money(dollars: dollars))
            }
            continuation.onTermination = { _ in listener.remove() }
        }
    }

    func transactionsStream() -> AsyncStream<[BankTransaction]> {
        AsyncStream { continuation in
            guard let uid = Auth.auth().currentUser?.uid else {
                continuation.finish()
                return
            }
            let listener = users.document(uid).collection("transactions")
                .order(by: "date", descending: true)
                .addSnapshotListener { snapshot, _ in
                    let items = snapshot?.documents.compactMap { doc in
                        (try? doc.data(as: TransactionDTO.self))?.toDomain()
                    } ?? []
                    continuation.yield(items)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }

    func transfer(amount: Money, toEmail: String) async throws {
        guard let sender = Auth.auth().currentUser else { throw BankingError.notAuthenticated }

        let matches = try await users.whereField("email", isEqualTo: toEmail).limit(to: 1).getDocuments()
        guard let recipientDoc = matches.documents.first else { throw BankingError.recipientNotFound }
        let recipientUid = recipientDoc.documentID
        guard recipientUid != sender.uid else { throw BankingError.selfTransfer }

        let senderRef = users.document(sender.uid)
        let recipientRef = users.document(recipientUid)
        let amountCents = amount.cents

        do {
            _ = try await db.runTransaction { transaction, errorPointer in
                let senderSnap: DocumentSnapshot
                let recipientSnap: DocumentSnapshot
                do {
                    senderSnap = try transaction.getDocument(senderRef)
                    recipientSnap = try transaction.getDocument(recipientRef)
                } catch let nsError as NSError {
                    errorPointer?.pointee = nsError
                    return nil
                }

                let senderCents = Self.cents(from: senderSnap.data()?["balance"])
                let recipientCents = Self.cents(from: recipientSnap.data()?["balance"])

                guard senderCents >= amountCents else {
                    errorPointer?.pointee = NSError(
                        domain: "Banking",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: BankingError.insufficientFunds.errorDescription ?? ""]
                    )
                    return nil
                }

                let senderName = senderSnap.data()?["displayName"] as? String ?? ""
                let senderEmail = senderSnap.data()?["email"] as? String ?? ""
                let recipientName = recipientSnap.data()?["displayName"] as? String ?? ""
                let recipientEmail = recipientSnap.data()?["email"] as? String ?? toEmail

                let amountDollars = amount.dollarValue
                transaction.updateData(["balance": Double(senderCents - amountCents) / 100], forDocument: senderRef)
                transaction.updateData(["balance": Double(recipientCents + amountCents) / 100], forDocument: recipientRef)

                let now = Timestamp(date: Date())
                transaction.setData([
                    "type": "outcome",
                    "amount": amountDollars,
                    "counterpartyName": recipientName,
                    "counterpartyEmail": recipientEmail,
                    "date": now
                ], forDocument: senderRef.collection("transactions").document())
                transaction.setData([
                    "type": "income",
                    "amount": amountDollars,
                    "counterpartyName": senderName,
                    "counterpartyEmail": senderEmail,
                    "date": now
                ], forDocument: recipientRef.collection("transactions").document())

                return nil
            }
        } catch let error as NSError where error.domain == "Banking" && error.code == 1 {
            throw BankingError.insufficientFunds
        } catch {
            throw BankingError.underlying(error.localizedDescription)
        }
    }

    private static func cents(from value: Any?) -> Int {
        guard let number = value as? NSNumber else { return 0 }
        return Int((number.doubleValue * 100).rounded())
    }
}
