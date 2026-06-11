import Foundation

protocol ObserveBalanceUseCase {
    func execute() -> AsyncStream<Money>
}

final class DefaultObserveBalanceUseCase: ObserveBalanceUseCase {
    private let accountRepository: AccountRepository

    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute() -> AsyncStream<Money> {
        accountRepository.balanceStream()
    }
}
