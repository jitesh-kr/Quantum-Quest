import SwiftUI

/// A pulsing, glowing link icon displayed between two entangled coins.
struct EntanglementLinkView: View {
    @State private var pulse = false
    @State private var rotate = false

    var body: some View {
        ZStack {
            // Glow halo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.pink.opacity(pulse ? 0.4 : 0.15),
                            .clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)

            // Link icon
            Image(systemName: "link")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.pink, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .pink.opacity(pulse ? 0.9 : 0.4), radius: pulse ? 15 : 6)
                .rotationEffect(.degrees(rotate ? 10 : -10))
                .scaleEffect(pulse ? 1.15 : 0.9)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                rotate = true
            }
        }
    }
}
