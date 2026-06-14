import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirestoreProfileRepository: ProfileRepository {

    private static let knownTitles: Set<String> = ["Mr", "Ms", "Mrs", "Dr", "Mx"]

    private let db = Firestore.firestore()
    private var users: CollectionReference { db.collection("users") }

    func createProfile(
        uid: String,
        email: String,
        title: String,
        firstName: String,
        lastName: String
    ) async throws {
        let displayName = "\(title) \(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        let dto = UserProfileDTO(
            id: nil,
            email: email.lowercased(),
            title: title,
            firstName: firstName,
            lastName: lastName,
            displayName: displayName,
            balance: 0
        )
        let data = try Firestore.Encoder().encode(dto)
        try await users.document(uid).setData(data, merge: true)
    }

    func loadProfile() async throws -> UserProfile {
        guard let user = Auth.auth().currentUser else { throw BankingError.notAuthenticated }
        let ref = users.document(user.uid)
        let snapshot = try await ref.getDocument()

        if snapshot.exists, let data = snapshot.data() {
            var title = data["title"] as? String ?? ""
            var first = data["firstName"] as? String ?? ""
            var last = data["lastName"] as? String ?? ""
            let email = (data["email"] as? String) ?? (user.email ?? "").lowercased()

            if first.isEmpty && last.isEmpty {
                let parsed = Self.split(user.displayName ?? "")
                title = parsed.title
                first = parsed.first
                last = parsed.last
                let displayName = "\(title) \(first) \(last)".trimmingCharacters(in: .whitespaces)
                try await ref.setData([
                    "title": title,
                    "firstName": first,
                    "lastName": last,
                    "displayName": displayName,
                    "email": email.lowercased()
                ], merge: true)
            }
            return UserProfile(uid: user.uid, email: email, title: title, firstName: first, lastName: last)
        }

        let (title, first, last) = Self.split(user.displayName ?? "")
        let email = (user.email ?? "").lowercased()
        try await createProfile(uid: user.uid, email: email, title: title, firstName: first, lastName: last)
        return UserProfile(uid: user.uid, email: email, title: title, firstName: first, lastName: last)
    }

    func updateName(firstName: String, lastName: String) async throws {
        guard let user = Auth.auth().currentUser else { throw BankingError.notAuthenticated }
        let ref = users.document(user.uid)
        let snapshot = try await ref.getDocument()
        let title = snapshot.data()?["title"] as? String ?? ""
        let displayName = "\(title) \(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)

        try await ref.updateData([
            "firstName": firstName,
            "lastName": lastName,
            "displayName": displayName
        ])

        let change = user.createProfileChangeRequest()
        change.displayName = displayName
        try await change.commitChanges()
    }

    private static func split(_ displayName: String) -> (title: String, first: String, last: String) {
        var parts = displayName.split(separator: " ").map(String.init)
        var title = ""
        if let head = parts.first, knownTitles.contains(head) {
            title = head
            parts.removeFirst()
        }
        let first = parts.first ?? ""
        let last = parts.count > 1 ? parts.dropFirst().joined(separator: " ") : ""
        return (title, first, last)
    }
}
