import SwiftUI

struct TransferView: View {
    @Environment(\.dismiss) private var dismiss
    @State var viewModel: TransferViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0A1628").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        header

                        field(icon: "envelope.fill", placeholder: "Recipient email") {
                            TextField("", text: $viewModel.recipientEmail)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textContentType(.emailAddress)
                                .privacySensitive()
                        }

                        field(icon: "dollarsign.circle.fill", placeholder: "Amount") {
                            TextField("", text: $viewModel.amount)
                                .keyboardType(.decimalPad)
                                .privacySensitive()
                        }

                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.system(size: 13))
                                .foregroundColor(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        sendButton

                        Spacer()
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Transfer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .onChange(of: viewModel.didComplete) { _, completed in
                if completed { dismiss() }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 44))
                .foregroundColor(Color(hex: "4A9EFF"))
            Text("Send money")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text("Transfer to another SecureBank user by email")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private func field<Content: View>(
        icon: String,
        placeholder: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.35))
                .frame(width: 20)
            ZStack(alignment: .leading) {
                if isEmptyField(placeholder) {
                    Text(placeholder).foregroundColor(.white.opacity(0.35))
                }
                content()
                    .foregroundColor(.white)
                    .tint(Color(hex: "4A9EFF"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func isEmptyField(_ placeholder: String) -> Bool {
        switch placeholder {
        case "Recipient email": return viewModel.recipientEmail.isEmpty
        case "Amount":          return viewModel.amount.isEmpty
        default:                return false
        }
    }

    private var sendButton: some View {
        Button {
            Task { await viewModel.transfer() }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Send")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(hex: "2D6FD4"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(viewModel.isLoading)
    }
}
