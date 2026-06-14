import Foundation

protocol AccountRepository {
    func balanceStream() -> AsyncStream<Money>
    func transactionsStream() -> AsyncStream<[BankTransaction]>
    func transfer(amount: Money, toEmail: String) async throws
}
