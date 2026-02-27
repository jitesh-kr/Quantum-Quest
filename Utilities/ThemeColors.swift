import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - ThemeColors (Adaptive Color Palette)
// ═══════════════════════════════════════════════════════════════════
//
// Provides adaptive colors that switch between dark sci-fi neon
// and light modern pastel palettes based on the current colorScheme.
//
// Usage:
//   @Environment(\.colorScheme) var colorScheme
//   ThemeColors.background(for: colorScheme)
// ═══════════════════════════════════════════════════════════════════

struct ThemeColors {

    // ─── Backgrounds ──────────────────────────────────────────────

    /// Main radial background gradient colors
    static func backgroundColors(for scheme: ColorScheme) -> [Color] {
        return [
            Color(red: 0.06, green: 0.0, blue: 0.14),
            Color(red: 0.02, green: 0.0, blue: 0.08),
            .black
        ]
    }

    /// Sheet / overlay background gradient
    static func sheetBackgroundColors(for scheme: ColorScheme) -> [Color] {
        return [
            Color(red: 0.02, green: 0.0, blue: 0.10),
            Color(red: 0.04, green: 0.0, blue: 0.16),
            .black
        ]
    }

    // ─── Text Colors ──────────────────────────────────────────────

    /// Primary heading text
    static func heading(for scheme: ColorScheme) -> Color {
        return .white
    }

    /// Secondary / subtitle text
    static func subtext(for scheme: ColorScheme) -> Color {
        return .white.opacity(0.7)
    }

    /// Dimmed / hint text
    static func dimText(for scheme: ColorScheme) -> Color {
        return .white.opacity(0.4)
    }

    // ─── Accent Colors ──────────────────────────────────────────────

    static func cyan(for scheme: ColorScheme) -> Color { .cyan }
    static func pink(for scheme: ColorScheme) -> Color { .pink }
    static func orange(for scheme: ColorScheme) -> Color { .orange }
    static func purple(for scheme: ColorScheme) -> Color { .purple }

    // ─── Card & Surface ──────────────────────────────────────────

    /// Card border opacity
    static func cardBorder(for scheme: ColorScheme) -> Double { 0.15 }

    /// Card stroke color
    static func cardStroke(for scheme: ColorScheme, accent: Color) -> Color {
        accent.opacity(0.15)
    }

    // ─── Glow & Shadows ──────────────────────────────────────────

    static func glowRadius(for scheme: ColorScheme) -> CGFloat { 10 }
    static func glowOpacity(for scheme: ColorScheme) -> Double { 0.5 }

    /// Shadow for cards (disabled in dark mode in favor of neon glow)
    static func cardShadow(for scheme: ColorScheme) -> (color: Color, radius: CGFloat) {
        return (.clear, 0)
    }

    /// Locked-card icon/text color
    static func lockedContent(for scheme: ColorScheme) -> Color {
        return .white.opacity(0.25)
    }

    /// Locked-card sublabel color
    static func lockedLabel(for scheme: ColorScheme) -> Color {
        return .white.opacity(0.20)
    }

    // ─── Tab Bar ──────────────────────────────────────────────────

    static func tabBarBackground(for scheme: ColorScheme) -> UIColor {
        return UIColor(red: 0.04, green: 0.0, blue: 0.10, alpha: 0.95)
    }

    static func tabBarNormal(for scheme: ColorScheme) -> UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
}
