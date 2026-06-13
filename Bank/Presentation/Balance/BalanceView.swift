import SwiftUI

struct BalanceView: View {
    @Environment(DiContainer.self) private var container
    @State var viewModel: BalanceViewModel
    @State private var showTransfer = false

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    welcomeHeader

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(.red.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    balanceCard
                        .privacySensitive()
                    actionButtons
                    summaryRow
                        .privacySensitive()
                    transactionsSection
                        .privacySensitive()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AccountView(viewModel: container.makeAccountViewModel())
                } label: {
                    accountAvatar
                }
            }
        }
        .sheet(isPresented: $showTransfer) {
            TransferView(viewModel: container.makeTransferViewModel())
        }
        .task { await viewModel.loadProfile() }
        .task { await viewModel.observeBalance() }
        .task { await viewModel.observeTransactions() }
    }

    // MARK: - Header

    private var welcomeHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.5))
            Text(viewModel.displayName)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var accountAvatar: some View {
        Text(viewModel.initials)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(Color(hex: "2D6FD4"))
            .clipShape(Circle())
    }

    // MARK: - Balance card

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Total Balance")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            Text(viewModel.balanceText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(hex: "2D6FD4"), Color(hex: "16294A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - Actions

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { viewModel.toggleBalanceHidden() }
            } label: {
                actionLabel(
                    icon: viewModel.isBalanceHidden ? "eye.fill" : "eye.slash.fill",
                    title: viewModel.isBalanceHidden ? "Show" : "Hide"
                )
            }

            Button {
                showTransfer = true
            } label: {
                actionLabel(icon: "arrow.up.right", title: "Transfer")
            }
        }
    }

    private func actionLabel(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(title).font(.system(size: 15, weight: .semibold))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Income / Outcome summary

    private var summaryRow: some View {
        HStack(spacing: 12) {
            summaryCard(title: "Income", amount: viewModel.totalIncome, color: Color.green, icon: "arrow.down.left")
            summaryCard(title: "Outcome", amount: viewModel.totalOutcome, color: Color.red, icon: "arrow.up.right")
        }
    }

    private func summaryCard(title: String, amount: Money, color: Color, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
            Text(amount.formatted)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Transactions

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transactions")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            if viewModel.transactions.isEmpty {
                Text("No transactions yet")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Transaction row

private struct TransactionRow: View {
    let transaction: BankTransaction

    private var isIncome: Bool { transaction.kind == .income }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: isIncome ? "arrow.down.left" : "arrow.up.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isIncome ? .green : .red)
                .frame(width: 40, height: 40)
                .background((isIncome ? Color.green : Color.red).opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.counterpartyName.isEmpty ? transaction.counterpartyEmail : transaction.counterpartyName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Text(transaction.date, format: .dateTime.day().month().year())
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }

            Spacer()

            Text("\(isIncome ? "+" : "-")\(transaction.amount.formatted)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isIncome ? .green : .white)
        }
        .padding(.vertical, 8)
    }
}
