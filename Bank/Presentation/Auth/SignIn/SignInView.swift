import SwiftUI

struct SignInView: View {
    private enum Field {
        case email, password
    }

    @Environment(DiContainer.self) private var container
    @State private var showPassword = false
    @State private var showSignUp = false
    @FocusState private var focusedField: Field?

    @Bindable var viewModel: SignInViewModel

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

                    // Logo
                    VStack(spacing: 16) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 52))
                            .foregroundColor(Color(hex: "4A9EFF"))

                        Text("SecureBank")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Sign in to your account")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer().frame(height: 48)

                    // Fields
                    VStack(spacing: 28) {
                        // Email
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .textContentType(.emailAddress)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .email)
                                .onSubmit { focusedField = .password }
                                .foregroundColor(.white)
                                .tint(Color(hex: "4A9EFF"))
                                .privacySensitive()
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Password
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            Group {
                                if showPassword {
                                    TextField("Password", text: $viewModel.password)
                                        .privacySensitive()
                                } else {
                                    SecureField("Password", text: $viewModel.password)
                                        .privacySensitive()
                                }
                            }
                            .textContentType(.password)
                            .submitLabel(.go)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                focusedField = nil
                                Task { await viewModel.signIn() }
                            }
                            .foregroundColor(.white)
                            .tint(Color(hex: "4A9EFF"))

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.35))
                                    .frame(width: 20)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Remember me
                        HStack {
                            Toggle(isOn: $viewModel.rememberMe) {
                                Text("Remember me")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .toggleStyle(CheckboxToggleStyle())

                            Spacer()

                            Button("Create Account") {
                                showSignUp = true
                            }
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "4A9EFF"))
                        }
                        .padding(.horizontal, 4)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 13))
                                .foregroundColor(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("")
                                .font(.system(size: 13))
                                .foregroundColor(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    Spacer().frame(height: 28)

                    // Sign in button
                    Button {
                        Task { await viewModel.signIn() }
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign In")
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

                    Spacer().frame(height: 40)
                }
                .padding(.horizontal, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationDestination(isPresented: $showSignUp) {
            SignUpView(viewModel: container.makeSignUpViewModel())
        }
    }
}
