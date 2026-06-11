import Foundation

struct UserProfile: Equatable {
    let uid: String
    let email: String
    var title: String
    var firstName: String
    var lastName: String

    var displayName: String {
        "\(title) \(firstName) \(lastName)"
            .trimmingCharacters(in: .whitespaces)
    }

    var initials: String {
        let first = firstName.first.map(String.init) ?? ""
        let last = lastName.first.map(String.init) ?? ""
        let combined = (first + last).uppercased()
        return combined.isEmpty ? "?" : combined
    }
}
