import SwiftUI

/// Zero-gravity bobbing modifier. Applies a gentle vertical float
/// and slight rotation, making elements appear weightless.
struct FloatingModifier: ViewModifier {
    let amplitude: CGFloat
    let period: Double

    @State private var isFloating = false

    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -amplitude : amplitude)
            .rotationEffect(.degrees(isFloating ? 1.2 : -1.2))
            .onAppear {
                withAnimation(
                    .easeInOut(duration: period)
                    .repeatForever(autoreverses: true)
                ) {
                    isFloating = true
                }
            }
    }
}

extension View {
    func floating(amplitude: CGFloat = 8, period: Double = 3.0) -> some View {
        modifier(FloatingModifier(amplitude: amplitude, period: period))
    }
}
