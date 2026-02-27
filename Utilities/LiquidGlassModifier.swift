import SwiftUI

/// A custom view modifier that applies a premium "liquid glass" frosted effect
/// with a subtle glossy gradient overlay, glowing inner rim, and smooth shadow.
struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    var accentColor: Color

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    // Inner gloss finish
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    // Edge highlight (specular reflection)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.05),
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.0 // 1px translucent border
                            )
                    )
            )
            // Softer, wider atmospheric shadow for depth
            .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 15)
            .shadow(color: accentColor.opacity(0.15), radius: 40, x: 0, y: 10)
    }
}

extension View {
    /// Applies a premium Liquid Glass aesthetic to any view.
    func liquidGlass(cornerRadius: CGFloat = 16, accentColor: Color = .cyan) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius, accentColor: accentColor))
    }
}
