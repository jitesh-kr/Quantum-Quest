import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - QuantumViewModel
// ═══════════════════════════════════════════════════════════════════
//
// The view-model owns the array of coins and exposes three core
// quantum operations that drive the game:
//
//   1. Hadamard Gate   – puts a coin into superposition
//   2. Measurement     – collapses the wave function
//   3. Entanglement    – links two coins together
//
// All mutations are performed on the @Published `coins` array so
// SwiftUI views update automatically.
// ═══════════════════════════════════════════════════════════════════

@MainActor class QuantumViewModel: ObservableObject {

    // ─── Published State ──────────────────────────────────────────

    /// The collection of quantum coins in the current level.
    @Published var coins: [QuantumCoin] = []

    /// The player's current level (1-indexed).
    @Published var currentLevel: Int = 1

    /// Cumulative score across all levels.
    @Published var score: Int = 0

    // ─── Quest Popup State ────────────────────────────────────────

    /// When `true`, the UI shows a sci-fi level-up popup.
    @Published var showLevelUpPopup: Bool = false

    /// Title displayed in the popup (e.g. "Wave Function Collapsed!").
    @Published var popupTitle: String = ""

    /// Educational message body for the popup.
    @Published var popupMessage: String = ""

    // ─── Status Message (inline feedback) ─────────────────────────

    /// Short inline message shown below the controls (auto-clears).
    @Published var statusMessage: String = ""

    // ─── Helpers ──────────────────────────────────────────────────

    /// Safely finds the index of a coin by its UUID.
    private func index(of coinID: UUID) -> Int? {
        coins.firstIndex(where: { $0.id == coinID })
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: 1 ▸ Hadamard Gate
    // ═════════════════════════════════════════════════════════════
    //
    // In real quantum computing the **Hadamard gate (H)** is one of
    // the most fundamental single-qubit gates. It transforms a
    // basis state into an equal superposition:
    //
    //   H|0⟩ = (|0⟩ + |1⟩) / √2   →  50 % chance of either outcome
    //   H|1⟩ = (|0⟩ − |1⟩) / √2   →  also 50 %, but with a phase flip
    //
    // For our educational coin model we simplify this: applying H
    // sets the probability to exactly 0.5 (perfect superposition),
    // meaning Heads and Tails are equally likely on measurement.
    //
    // The gate can only be applied to coins that have **not yet
    // been measured** — once observed, the state is classical.
    // ═════════════════════════════════════════════════════════════

    func applyHadamardGate(to coinID: UUID) {
        guard let idx = index(of: coinID) else { return }

        // Quantum gates cannot act on already-measured (classical) coins.
        guard !coins[idx].isMeasured else {
            print("⚠️ Cannot apply H gate — coin already measured.")
            return
        }

        // Place the coin into perfect superposition (50/50).
        coins[idx].probability = 0.5

        print("🔀 Hadamard gate applied → coin \(coinID.uuidString.prefix(8)) is now in superposition (p = 0.5).")
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: 2 ▸ Measurement (Wave-Function Collapse)
    // ═════════════════════════════════════════════════════════════
    //
    // **Measurement** is the act of observing a quantum system.
    // Before measurement, the coin exists in superposition — it is
    // simultaneously Heads AND Tails with some probability.
    //
    // The moment we measure:
    //   • We generate a random number r ∈ [0, 1].
    //   • If r < probability  →  result is **Heads** (true).
    //   • Otherwise           →  result is **Tails** (false).
    //
    // This is irreversible — the superposition is destroyed and
    // the coin is now in a definite classical state. This mirrors
    // the real "collapse of the wave function" postulate.
    //
    // If the coin is **entangled** with a partner, measuring this
    // coin also instantly collapses the partner to the same result
    // (see §3 Entanglement below).
    // ═════════════════════════════════════════════════════════════

    func measure(coinID: UUID) {
        guard let idx = index(of: coinID) else { return }

        // Already measured — nothing to collapse.
        guard !coins[idx].isMeasured else {
            print("ℹ️ Coin already measured: \(coins[idx].finalResult == true ? "Heads" : "Tails").")
            return
        }

        // ── Collapse the wave function ──
        let randomValue = Double.random(in: 0...1)
        let result = randomValue < coins[idx].probability   // true = Heads

        coins[idx].finalResult = result
        coins[idx].isMeasured = true

        print("📏 Measured coin \(coinID.uuidString.prefix(8)) → \(result ? "Heads ⬆" : "Tails ⬇") (rolled \(String(format: "%.3f", randomValue)) vs p = \(coins[idx].probability)).")

        // ── Entanglement propagation ──
        // If this coin is entangled with another, the partner
        // collapses to the exact same result — instantly.
        if let partnerID = coins[idx].entangledPartnerID,
           let partnerIdx = index(of: partnerID),
           !coins[partnerIdx].isMeasured {

            coins[partnerIdx].finalResult = result
            coins[partnerIdx].isMeasured = true

            print("🔗 Entangled partner \(partnerID.uuidString.prefix(8)) collapsed → \(result ? "Heads ⬆" : "Tails ⬇") (spooky action!).")
        }

        // Check quest progression after measurement
        checkLevelProgress()
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: 3 ▸ Entanglement
    // ═════════════════════════════════════════════════════════════
    //
    // **Quantum entanglement** is a phenomenon where two particles
    // become correlated in such a way that the quantum state of
    // each particle cannot be described independently.
    //
    // Einstein famously called it "spooky action at a distance"
    // because measuring one particle instantaneously determines
    // the state of the other — regardless of the physical distance
    // between them.
    //
    // In our model, entangling two coins means:
    //   • Both coins are placed into identical superposition.
    //   • They store each other's ID as their `entangledPartnerID`.
    //   • When *either* coin is measured, the *other* coin is
    //     immediately forced into the same result (see §2 above).
    //
    // Constraints:
    //   • Neither coin may already be measured.
    //   • A coin can only be entangled with one partner at a time.
    // ═════════════════════════════════════════════════════════════

    func entangle(coin1ID: UUID, coin2ID: UUID) {
        guard let idx1 = index(of: coin1ID),
              let idx2 = index(of: coin2ID) else {
            print("⚠️ One or both coin IDs not found.")
            return
        }

        // Cannot entangle coins that have already been observed.
        guard !coins[idx1].isMeasured, !coins[idx2].isMeasured else {
            statusMessage = "Cannot entangle: Wave function already collapsed! Use H-Gate to reset to Superposition."
            dismissStatusMessage()
            print("⚠️ Cannot entangle — one or both coins are already measured.")
            return
        }

        // Cannot entangle a coin with itself.
        guard coin1ID != coin2ID else {
            print("⚠️ Cannot entangle a coin with itself.")
            return
        }

        // Link partners to each other.
        coins[idx1].entangledPartnerID = coin2ID
        coins[idx2].entangledPartnerID = coin1ID

        // Synchronise their probabilities into matching superposition.
        let sharedProbability = 0.5
        coins[idx1].probability = sharedProbability
        coins[idx2].probability = sharedProbability

        print("🔗 Coins \(coin1ID.uuidString.prefix(8)) ↔ \(coin2ID.uuidString.prefix(8)) are now entangled (p = 0.5).")
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: 4 ▸ Quest Progression
    // ═════════════════════════════════════════════════════════════
    //
    // Checks whether the player has completed the current level's
    // objective and triggers a sci-fi educational popup.
    //
    //   Level 1 → 2:  Measure any coin for the first time.
    //   Level 2 → 3:  Entangle two coins AND measure the pair.
    // ═════════════════════════════════════════════════════════════

    private func checkLevelProgress() {
        switch currentLevel {

        case 1:
            // Complete when any coin has been measured
            let hasMeasured = coins.contains(where: { $0.isMeasured })
            if hasMeasured {
                score += 100
                currentLevel = 2
                popupTitle = "Wave Function Collapsed!"
                popupMessage = "You just forced a quantum superposition into a definite state (Heads or Tails) by measuring it! In quantum mechanics, the act of observation itself changes the system."
                showLevelUpPopup = true
                print("🎉 Level 1 → 2 complete!")
            }

        case 2:
            // Complete when 2 entangled coins are both measured
            let entangledAndMeasured = coins.filter { $0.entangledPartnerID != nil && $0.isMeasured }
            if entangledAndMeasured.count >= 2 {
                score += 250
                currentLevel = 3
                popupTitle = "Spooky Action!"
                popupMessage = "Albert Einstein called it \"spooky action at a distance\"! Measuring one entangled coin instantly determined the state of the other, no matter the distance between them."
                showLevelUpPopup = true
                print("🎉 Level 2 → 3 complete!")
            }

        default:
            break
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: – Convenience / Game Helpers
    // ═════════════════════════════════════════════════════════════

    /// Adds a fresh, unmeasured coin (defaults to deterministic Heads).
    @discardableResult
    func addCoin(probability: Double = 1.0) -> UUID {
        let coin = QuantumCoin(probability: probability)
        coins.append(coin)
        return coin.id
    }

    /// Resets all coins for a new round while keeping level & score.
    func resetCoins() {
        coins.removeAll()
        statusMessage = ""
    }

    /// Auto-clears the status message after 3 seconds.
    private func dismissStatusMessage() {
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation(.easeOut(duration: 0.3)) {
                self.statusMessage = ""
            }
        }
    }

    /// Advances to the next level and clears the board.
    func advanceLevel() {
        currentLevel += 1
        resetCoins()
    }
}
