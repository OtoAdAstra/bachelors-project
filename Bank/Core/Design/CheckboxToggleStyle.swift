import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(configuration.isOn
                          ? Color(hex: "2D6FD4")
                          : Color.white.opacity(0.08))
                    .frame(width: 20, height: 20)

                if configuration.isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .onTapGesture { configuration.isOn.toggle() }

            configuration.label
        }
    }
}
