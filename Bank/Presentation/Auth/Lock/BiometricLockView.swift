import SwiftUI

struct BiometricLockView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            VStack(spacing: 32) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 64))
                    .foregroundColor(Color(hex: "4A9EFF"))

                VStack(spacing: 8) {
                    Text("SecureBank")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Verify your identity to continue")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }

                if let error = authViewModel.biometricError {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.red.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Button {
                    Task { await authViewModel.unlockWithBiometrics() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: unlockIcon)
                            .font(.system(size: 18))
                        Text(unlockTitle)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(hex: "2D6FD4"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 32)

                Button("Sign out") {
                    authViewModel.signOut()
                }
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
            }
        }
        .task {
            await authViewModel.unlockWithBiometrics()
        }
    }

    private var unlockIcon: String {
        switch authViewModel.biometricType {
        case .faceID:  return "faceid"
        case .touchID: return "touchid"
        case .none:    return "lock.open.fill"
        }
    }

    private var unlockTitle: String {
        switch authViewModel.biometricType {
        case .faceID:  return "Unlock with Face ID"
        case .touchID: return "Unlock with Touch ID"
        case .none:    return "Unlock"
        }
    }
}
