import Foundation

/// Persistence boundary for balance, transactions, and money transfers.
protocol AccountRepository {
    /// Live balance updates for the current user.
    func balanceStream() -> AsyncStream<Money>

    /// Live transaction history (newest first) for the current user.
    func transactionsStream() -> AsyncStream<[BankTransaction]>

    /// Atomically moves money from the current user to the recipient (by email).
    func transfer(amount: Money, toEmail: String) async throws
}
