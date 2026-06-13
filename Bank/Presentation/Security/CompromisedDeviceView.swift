import SwiftUI

/// Full-screen block shown when the device looks jailbroken / tampered with.
/// There is no way forward in release builds — this is a hard stop.
struct CompromisedDeviceView: View {
    /// DEBUG-only escape hatch so development can continue past the block.
    var onContinueAnyway: (() -> Void)?

    var body: some View {
        ZStack {
            Color(hex: "0A1628").ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 72))
                    .foregroundColor(.red)

                Text("Security Risk Detected")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("This device appears to be jailbroken or modified. To protect your account, SecureBank can't run on a compromised device.")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                #if DEBUG
                if let onContinueAnyway {
                    Button("Continue anyway (debug)") {
                        onContinueAnyway()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.top, 8)
                }
                #endif
            }
            .padding(32)
        }
    }
}
