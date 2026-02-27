import SwiftUI

/// A glowing "QUEST CLEARED" full-screen overlay that appears for 2 seconds.
/// Uses glassmorphism card with neon border to match the sci-fi theme.
struct QuestClearedOverlay: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var glow = false

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyan.opacity(glow ? 1.0 : 0.4), radius: glow ? 30 : 10)

                Text("QUEST CLEARED")
                    .font(.system(size: 28, weight: .black, design: .monospaced))
                    .foregroundColor(.primary)
                    .tracking(4)
                    .shadow(color: .cyan.opacity(0.8), radius: 12)

                Text("+ Points Awarded!")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.cyan.opacity(0.8))
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.cyan.opacity(0.6), .green.opacity(0.3), .cyan.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .cyan.opacity(0.3), radius: 20)
            )
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}
