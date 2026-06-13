import Foundation

struct Money: Equatable {
    let cents: Int

    static let zero = Money(cents: 0)

    init(cents: Int) {
        self.cents = cents
    }

    init?(dollarsText: String) {
        let normalized = dollarsText
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".")
        guard
            normalized.filter({ $0 == "." }).count <= 1,
            let value = Decimal(string: normalized),
            value >= 0
        else { return nil }
        self.cents = NSDecimalNumber(decimal: value * 100).intValue
    }

    init(dollars: Double) {
        self.cents = Int((dollars * 100).rounded())
    }

    var dollars: Decimal {
        Decimal(cents) / 100
    }

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
