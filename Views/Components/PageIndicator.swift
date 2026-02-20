import SwiftUI

/// Custom capsule-style page dots with glow on the active page.
struct PageIndicator: View {
    let totalPages: Int
    let currentPage: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage
                          ? accentColor
                          : Color.white.opacity(0.3))
                    .frame(
                        width: index == currentPage ? 28 : 8,
                        height: 8
                    )
                    .shadow(
                        color: index == currentPage
                            ? accentColor.opacity(0.7) : .clear,
                        radius: 6
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}

/// Pulsing cyan→green gradient CTA capsule button.
struct GlowingButton: View {
    let title: String
    let action: () -> Void

    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .green],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .cyan.opacity(pulse ? 0.9 : 0.4), radius: pulse ? 25 : 12)
                        .shadow(color: .green.opacity(pulse ? 0.7 : 0.3), radius: pulse ? 30 : 15)
                )
        }
        .scaleEffect(pulse ? 1.05 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
