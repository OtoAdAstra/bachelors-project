import Foundation

protocol TransferMoneyUseCase {
    func execute(amountText: String, recipientEmail: String) async throws
}

final class DefaultTransferMoneyUseCase: TransferMoneyUseCase {
    private let accountRepository: AccountRepository

    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
    }

    func execute(amountText: String, recipientEmail: String) async throws {
        let email = recipientEmail.trimmingCharacters(in: .whitespaces).lowercased()
        guard email.contains("@"), email.contains(".") else {
            throw BankingError.invalidEmail
        }
        guard let amount = Money(dollarsText: amountText), amount.cents > 0 else {
            throw BankingError.invalidAmount
        }
        try await accountRepository.transfer(amount: amount, toEmail: email)
    }
}
