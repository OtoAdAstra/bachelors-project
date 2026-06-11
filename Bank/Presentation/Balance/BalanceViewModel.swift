import Foundation

@MainActor
@Observable
final class BalanceViewModel {
    var displayName: String = ""
    var initials: String = "?"
    var balance: Money = .zero
    var transactions: [BankTransaction] = []
    var isBalanceHidden: Bool = false
    var errorMessage: String?

    private let loadProfileUseCase: LoadProfileUseCase
    private let observeBalanceUseCase: ObserveBalanceUseCase
    private let observeTransactionsUseCase: ObserveTransactionsUseCase

    init(
        loadProfileUseCase: LoadProfileUseCase,
        observeBalanceUseCase: ObserveBalanceUseCase,
        observeTransactionsUseCase: ObserveTransactionsUseCase
    ) {
        self.loadProfileUseCase = loadProfileUseCase
        self.observeBalanceUseCase = observeBalanceUseCase
        self.observeTransactionsUseCase = observeTransactionsUseCase
    }

    var balanceText: String {
        isBalanceHidden ? "••••••" : balance.formatted
    }

    var totalIncome: Money {
        Money(cents: transactions.filter { $0.kind == .income }.reduce(0) { $0 + $1.amount.cents })
    }

    var totalOutcome: Money {
        Money(cents: transactions.filter { $0.kind == .outcome }.reduce(0) { $0 + $1.amount.cents })
    }

    func loadProfile() async {
        do {
            let profile = try await loadProfileUseCase.execute()
            displayName = profile.displayName
            initials = profile.initials
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func observeBalance() async {
        for await value in observeBalanceUseCase.execute() {
            balance = value
        }
    }

    func observeTransactions() async {
        for await value in observeTransactionsUseCase.execute() {
            transactions = value
        }
    }

    func toggleBalanceHidden() {
        isBalanceHidden.toggle()
    }
}
