import Foundation

protocol ObserveTransactionsUseCase {
    func execute() -> AsyncStream<[BankTransaction]>
}

final class DefaultObserveTransactionsUseCase: ObserveTransactionsUseCase {
    private let accountRepository: AccountRepository

    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute() -> AsyncStream<[BankTransaction]> {
        accountRepository.transactionsStream()
    }
}
