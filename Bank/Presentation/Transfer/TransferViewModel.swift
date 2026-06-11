import Foundation

@MainActor
@Observable
final class TransferViewModel {
    var recipientEmail: String = ""
    var amount: String = ""
    var errorMessage: String?
    var isLoading: Bool = false
    var didComplete: Bool = false

    private let transferUseCase: TransferMoneyUseCase

    init(transferUseCase: TransferMoneyUseCase) {
        self.transferUseCase = transferUseCase
    }

    func transfer() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await transferUseCase.execute(amountText: amount, recipientEmail: recipientEmail)
            didComplete = true
        } catch let error as BankingError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
