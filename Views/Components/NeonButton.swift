import SwiftUI

/// A neon-glow capsule action button with icon, title, and subtitle.
struct NeonButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .opacity(0.7)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: color.opacity(pulse ? 0.7 : 0.3), radius: pulse ? 18 : 8)
            )
        }
        .scaleEffect(pulse ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
