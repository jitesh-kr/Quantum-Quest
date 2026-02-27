import Foundation

// ═══════════════════════════════════════════════════════════════════
// MARK: - QuantumCoin Model
// ═══════════════════════════════════════════════════════════════════
//
// A QuantumCoin models a quantum two-level system (qubit) using the
// metaphor of a coin.
//
// In classical physics a coin is always either Heads or Tails.
// In quantum mechanics a qubit can exist in a **superposition** of
// both states simultaneously, described by a probability amplitude.
//
// We simplify this to a single probability value:
//   • probability == 1.0  →  100 % chance of Heads
//   • probability == 0.0  →  100 % chance of Tails
//   • probability == 0.5  →  perfect superposition (equal chance)
//
// The coin remains in superposition until it is **measured**.
// Measurement forces the qubit to "collapse" into a single definite
// state — the famous *wave-function collapse*.
// ═══════════════════════════════════════════════════════════════════

struct QuantumCoin: Identifiable {

    let id: UUID

    /// The probability of measuring **Heads** (range 0.0 … 1.0).
    var probability: Double

    /// Whether the coin is currently in a quantum superposition.
    /// This allows the H-gate to toggle back to the original state.
    var isSuperposed: Bool = false

    /// Whether the coin has ever had an H-Gate applied to it.
    /// Used to distinguish a "returned-to-deterministic" coin (Level 4)
    /// from a freshly created one.
    var hasBeenToggled: Bool = false

    /// Whether the coin has been observed / measured.
    /// Once `true`, the coin's state is fixed and can no longer
    /// be changed by quantum gates.
    var isMeasured: Bool

    /// The definitive result after measurement.
    /// `true` = Heads, `false` = Tails, `nil` = not yet measured.
    var finalResult: Bool?

    /// The ID of the coin this one is entangled with, if any.
    /// Entanglement links two coins so that measuring one instantly
    /// determines the other's outcome.
    var entangledPartnerID: UUID?

    // ─── Convenience initialiser ───

    init(
        id: UUID = UUID(),
        probability: Double = 1.0,   // starts as deterministic Heads
        isSuperposed: Bool = false,
        hasBeenToggled: Bool = false,
        isMeasured: Bool = false,
        finalResult: Bool? = nil,
        entangledPartnerID: UUID? = nil
    ) {
        self.id = id
        self.probability = probability
        self.isSuperposed = isSuperposed
        self.hasBeenToggled = hasBeenToggled
        self.isMeasured = isMeasured
        self.finalResult = finalResult
        self.entangledPartnerID = entangledPartnerID
    }
}
