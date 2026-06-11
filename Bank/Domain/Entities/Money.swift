import Foundation

/// Value object representing a monetary amount, stored as integer cents
/// to avoid floating-point rounding errors.
struct Money: Equatable {
    let cents: Int

    static let zero = Money(cents: 0)

    init(cents: Int) {
        self.cents = cents
    }

    init?(dollarsText: String) {
        let trimmed = dollarsText.trimmingCharacters(in: .whitespaces)
        guard let value = Decimal(string: trimmed), value >= 0 else { return nil }
        self.cents = NSDecimalNumber(decimal: value * 100).intValue
    }

    /// Build from a plain dollar amount (e.g. read from Firestore).
    init(dollars: Double) {
        self.cents = Int((dollars * 100).rounded())
    }

    var dollars: Decimal {
        Decimal(cents) / 100
    }

    /// Plain dollar amount for persistence (e.g. writing to Firestore).
    var dollarValue: Double {
        Double(cents) / 100
    }

    var formatted: String {
        Self.formatter.string(from: NSDecimalNumber(decimal: dollars)) ?? "$0.00"
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
}
