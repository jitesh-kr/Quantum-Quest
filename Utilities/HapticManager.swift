import UIKit

// ═══════════════════════════════════════════════════════════════════
// MARK: - HapticManager (Singleton)
// ═══════════════════════════════════════════════════════════════════
//
// Centralized haptic feedback manager using UIKit generators for
// full backward compatibility (iOS 10+). No SwiftUI-only APIs.
//
// Usage from SwiftUI:
//   Button("Measure") {
//       HapticManager.shared.impact(.medium)
//       viewModel.measure(coinID: id)
//   }
//
//   Button("Quest Cleared") {
//       HapticManager.shared.notification(.success)
//   }
//
//   Button("Select Coin") {
//       HapticManager.shared.selection()
//   }
// ═══════════════════════════════════════════════════════════════════

@MainActor final class HapticManager {

    static let shared = HapticManager()
    private init() {}

    // ─── Impact Feedback ─────────────────────────────────────────
    // Use for button taps, collisions, and UI interactions.

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Light tap — subtle, like toggling a switch.
    func lightImpact() {
        impact(.light)
    }

    /// Medium tap — standard button press feel.
    func mediumImpact() {
        impact(.medium)
    }

    /// Heavy tap — bold action like measurement collapse.
    func heavyImpact() {
        impact(.heavy)
    }

    // ─── Notification Feedback ────────────────────────────────────
    // Use for outcomes: success, warning, or error.

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    /// Quest cleared, level up, correct answer.
    func success() {
        notification(.success)
    }

    /// Approaching a limit, caution state.
    func warning() {
        notification(.warning)
    }

    /// Clone failed, invalid action, entangle blocked.
    func error() {
        notification(.error)
    }

    // ─── Selection Feedback ──────────────────────────────────────
    // Use for scrolling through items, selecting a coin, etc.

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
