import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo
                VStack(spacing: 12) {
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
                VStack(spacing: 18) {
                    // Email
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.white.opacity(0.35))
                            .frame(width: 20)

                        TextField("Email", text: $email)
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

                    // Password
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.35))
                            .frame(width: 20)

                        Group {
                            if showPassword {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                        }
                        .textContentType(.password)
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
                        Toggle(isOn: $rememberMe) {
                            Text("Remember me")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .toggleStyle(CheckboxToggleStyle())

                        Spacer()

                        Button("Create Account") {
                            
                        }
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "4A9EFF"))
                    }
                    .padding(.horizontal, 4)
                }

                Spacer().frame(height: 28)

                // Sign in button
                Button {
                    // sign in action
                } label: {
                    Text("Sign In")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(hex: "2D6FD4"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    SignInView()
}
