struct TransactionRow: View {
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
