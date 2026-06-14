import SwiftUI

struct SignUpView: View {
    @State private var showPassword = false
    @State private var showRepeatPassword = false

    @Bindable var viewModel: SignUpViewModel

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 24)

                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 52))
                            .foregroundColor(Color(hex: "4A9EFF"))

                        Text("SecureBank")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Create your account")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer().frame(height: 36)

                    VStack(spacing: 20) {
                        Menu {
                            ForEach(SignUpViewModel.titles, id: \.self) { title in
                                Button(title) { viewModel.title = title }
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.text.rectangle.fill")
                                    .foregroundColor(.white.opacity(0.35))
                                    .frame(width: 20)

                                Text(viewModel.title.isEmpty ? "Title" : viewModel.title)
                                    .foregroundColor(viewModel.title.isEmpty ? .white.opacity(0.35) : .white)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            TextField("First name", text: $viewModel.firstName)
                                .textContentType(.givenName)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                                .tint(Color(hex: "4A9EFF"))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            TextField("Last name", text: $viewModel.lastName)
                                .textContentType(.familyName)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                                .tint(Color(hex: "4A9EFF"))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .textContentType(.emailAddress)
                                .foregroundColor(.white)
                                .tint(Color(hex: "4A9EFF"))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            Group {
                                if showPassword {
                                    TextField("Password", text: $viewModel.password)
                                } else {
                                    SecureField("Password", text: $viewModel.password)
                                }
                            }
                            .textContentType(.newPassword)
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

                        HStack(spacing: 12) {
                            Image(systemName: "lock.rotation")
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 20)

                            Group {
                                if showRepeatPassword {
                                    TextField("Repeat password", text: $viewModel.repeatPassword)
                                } else {
                                    SecureField("Repeat password", text: $viewModel.repeatPassword)
                                }
                            }
                            .textContentType(.newPassword)
                            .foregroundColor(.white)
                            .tint(Color(hex: "4A9EFF"))

                            Button {
                                showRepeatPassword.toggle()
                            } label: {
                                Image(systemName: showRepeatPassword ? "eye.slash" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.35))
                                    .frame(width: 20)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

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

                    Spacer().frame(height: 24)

                    Button {
                        Task { await viewModel.signUp() }
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Create Account")
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

                    Spacer().frame(height: 24)
                }
                .padding(.horizontal, 24)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}
