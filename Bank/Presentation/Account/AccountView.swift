import SwiftUI

struct AccountView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State var viewModel: AccountViewModel

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    field(title: "First name") {
                        TextField("", text: $viewModel.firstName)
                            .textContentType(.givenName)
                            .autocorrectionDisabled()
                    }

                    field(title: "Last name") {
                        TextField("", text: $viewModel.lastName)
                            .textContentType(.familyName)
                            .autocorrectionDisabled()
                    }

                    if let error = viewModel.errorMessage {
                        message(error, color: .red)
                    }
                    if let success = viewModel.successMessage {
                        message(success, color: .green)
                    }

                    saveButton

                    Divider()
                        .overlay(Color.white.opacity(0.1))
                        .padding(.vertical, 8)

                    logoutButton

                    if let logoutError = authViewModel.errorMessage {
                        message(logoutError, color: .red)
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    private func field<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
            content()
                .foregroundColor(.white)
                .tint(Color(hex: "4A9EFF"))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func message(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(color.opacity(0.9))
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var saveButton: some View {
        Button {
            Task { await viewModel.save() }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Save Changes")
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

    private var logoutButton: some View {
        Button(role: .destructive) {
            authViewModel.signOut()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Log Out").font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.red.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
