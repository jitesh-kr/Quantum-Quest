import SwiftUI

/// A full-screen sci-fi popup overlay for quest level-ups.
/// Uses glassmorphism background, neon border, and a glowing CTA.
struct QuestPopupView: View {
    let title: String
    let message: String
    let onDismiss: () -> Void

    @State private var glowPulse = false
    @State private var iconSpin = false

    var body: some View {
        ZStack {
            // Dim background
            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Animated top icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.cyan.opacity(glowPulse ? 0.3 : 0.1), .clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)

                    Image(systemName: "atom")
                        .font(.system(size: 50, weight: .light))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .cyan.opacity(glowPulse ? 0.9 : 0.3), radius: glowPulse ? 20 : 8)
                        .rotationEffect(.degrees(iconSpin ? 360 : 0))
                }

                // Title
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan)
                    .multilineTextAlignment(.center)
                    .shadow(color: .cyan.opacity(0.6), radius: 8)

                // Divider
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .cyan.opacity(0.4), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                    .padding(.horizontal, 20)

                // Message
                Text(message)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 16)

                // Score badge
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("+\(title.contains("Spooky") ? "250" : "100") pts")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.yellow.opacity(0.1))
                        .overlay(
                            Capsule()
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )

                // CTA Button
                Button(action: onDismiss) {
                    Text("CONTINUE QUEST")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                        .tracking(2)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.cyan, .green],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .cyan.opacity(glowPulse ? 0.9 : 0.4), radius: glowPulse ? 20 : 8)
                                .shadow(color: .green.opacity(glowPulse ? 0.7 : 0.3), radius: glowPulse ? 25 : 10)
                        )
                }
                .scaleEffect(glowPulse ? 1.04 : 1.0)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [.cyan.opacity(0.8), .purple.opacity(0.4), .cyan.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .cyan.opacity(0.2), radius: 30)
            )
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                iconSpin = true
            }
        }
    }
}
