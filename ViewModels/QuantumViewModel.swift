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

    // ─── Tutorial State ───────────────────────────────────────────

    /// Whether the user has completed the interactive tour.
    @AppStorage("hasSeenQuestTour") var hasSeenTour: Bool = false

    /// Whether the tutorial is currently active.
    @Published var isTutorialActive: Bool = false

    /// The current index of the active tutorial step.
    @Published var currentTutorialStep: Int = 0

    /// List of steps for the interactive tour.
    let tutorialSteps: [TutorialStep] = [
        TutorialStep(
            title: "Mission Control",
            message: "Welcome, Quantum Researcher! This dashboard is your starting point for all quests.",
            tabIndex: 0,
            highlightAnchor: "playerStats"
        ),
        TutorialStep(
            title: "Quest Grid",
            message: "Select a quest to dive into specific quantum concepts. Completed ones can be replayed anytime!",
            tabIndex: 0,
            highlightAnchor: "questGrid"
        ),
        TutorialStep(
            title: "Quick Start",
            message: "Tap this button to instantly jump back into your most recent experiment.",
            tabIndex: 0,
            highlightAnchor: "playButton"
        ),
        TutorialStep(
            title: "The Quantum Lab",
            message: "This is where the magic happens. Let's look at your coins.",
            tabIndex: 1,
            highlightAnchor: "coinStage"
        ),
        TutorialStep(
            title: "Hadamard Gate (H)",
            message: "Tap 'H' to put a coin into Superposition. It becomes a blur of both Heads and Tails!",
            tabIndex: 1,
            highlightAnchor: "hGate"
        ),
        TutorialStep(
            title: "Measurement",
            message: "Tap MEASURE to force the coin to pick a side. This 'collapses' the quantum state.",
            tabIndex: 1,
            highlightAnchor: "measureButton"
        ),
        TutorialStep(
            title: "Entanglement",
            message: "Select two coins and tap ENTANGLE to link them. Whatever happens to one instantly affects the other!",
            tabIndex: 1,
            highlightAnchor: "entangleButton"
        ),
        TutorialStep(
            title: "Deep Theory",
            message: "Need to understand the physics? Tap the book icon for a specialized theory breakdown.",
            tabIndex: 1,
            highlightAnchor: "theoryButton"
        )
    ]

    func startTutorial() {
        currentTutorialStep = 0
        isTutorialActive = true
    }

    func nextTutorialStep() {
        if currentTutorialStep < tutorialSteps.count - 1 {
            currentTutorialStep += 1
        } else {
            endTutorial()
        }
    }

    func endTutorial() {
        isTutorialActive = false
        hasSeenTour = true
    }

    // ─── Published State ──────────────────────────────────────────

    /// The collection of 10 quests defining the progression.
    @Published var quests: [QuantumQuest] = [
        QuantumQuest(
            id: 1,
            title: "Superposition",
            theoryText: "In the quantum world, objects don't have to be in just one state. A quantum coin can be in a 'superposition'—a complex mix of both Heads and Tails simultaneously. This isn't just lack of knowledge; it's a fundamental property of nature where all possibilities exist at once until observed.",
            objective: "Tap your coin, then tap the H GATE button to make it spin into Superposition.",
            hint: "Select a coin → tap H Gate",
            isUnlocked: true,
            startTime: Date()
        ),
        QuantumQuest(
            id: 2,
            title: "Measurement",
            theoryText: "Measurement is the act of interacting with a quantum system to extract information. When you measure a coin in superposition, the 'wavefunction' collapses, and the coin is forced to pick a single, definite state (Heads or Tails). Once measured, the quantum magic vanishes, and it becomes a classical coin.",
            objective: "Tap your spinning coin, then tap MEASURE to see if it lands on Heads or Tails.",
            hint: "H Gate first → then MEASURE"
        ),
        QuantumQuest(
            id: 3,
            title: "Entanglement",
            theoryText: "Entanglement is a phenomenon where two or more particles become linked such that the state of one instantly influences the state of the other, regardless of distance. Albert Einstein called this 'spooky action at a distance.' If you measure one entangled coin as Heads, the other will also show Heads immediately.",
            objective: "Add a second coin. Tap both to select them, tap ENTANGLE, then MEASURE one.",
            hint: "Add coin → ENTANGLE → MEASURE one"
        ),
        QuantumQuest(
            id: 4,
            title: "Interference",
            theoryText: "Quantum particles behave like waves. When these waves overlap, they can interfere constructively (making a result more likely) or destructively (canceling it out). By applying carefully timed gates, you can use interference to 'erase' the randomness and force the coin back to a certain state.",
            objective: "Use multiple H-Gates on the same coin to 'cancel' the superposition and return it to a fixed state.",
            hint: "Tap H Gate twice on the same coin"
        ),
        QuantumQuest(
            id: 5,
            title: "Decoherence",
            theoryText: "Decoherence is the process by which a quantum system loses its 'quantumness' through interaction with its environment. Fragile states like superposition are easily disturbed by 'noise' (heat, light, air). This is why large objects in our daily lives don't usually behave like quantum particles.",
            objective: "Put a coin in superposition, then MEASURE it to see it lose its quantum state.",
            hint: "H Gate → then MEASURE to collapse"
        ),
        QuantumQuest(
            id: 6,
            title: "No-Cloning",
            theoryText: "The No-Cloning Theorem states that it is impossible to create an identical copy of an arbitrary, unknown quantum state. If you try to 'read' the details of a spinning coin to copy it, you inevitably disturb it, preventing a perfect duplication. This property is used to create unhackable quantum communications.",
            objective: "Add two coins and try to measure both to get matching results — you'll see it's impossible to clone!",
            hint: "Add 2 coins → MEASURE both separately"
        ),
        QuantumQuest(
            id: 7,
            title: "Tunneling",
            theoryText: "Quantum tunneling allows particles to pass through energy barriers that would be impossible to cross in classical physics. Imagine a ball passing through a brick wall! Particles have a small probability of 'teleporting' from one side of a barrier to the other, a principle used in modern flash memory and scanning tunneling microscopes.",
            objective: "Put a coin into superposition and MEASURE — there's a chance it 'tunnels' to Heads!",
            hint: "H Gate → MEASURE (luck determines tunneling)"
        ),
        QuantumQuest(
            id: 8,
            title: "Zeno Effect",
            theoryText: "The Quantum Zeno Effect (also known as the Turing Paradox) is a feature of quantum systems where a particle's evolution can be slowed down or even stopped by measuring it frequently enough. 'A watched pot never boils'—if you look at a quantum system often enough, you freeze it in its current state.",
            objective: "Add two coins, put both into superposition, and MEASURE both to 'freeze' them.",
            hint: "Add 2 coins → H Gate each → MEASURE both"
        ),
        QuantumQuest(
            id: 9,
            title: "Teleportation",
            theoryText: "Quantum Teleportation is the process of moving an atom's information (its state) from one location to another using entanglement. You don't move the actual coin; you move its 'secrets.' Importantly, the original information set is destroyed during the process, so it's a transfer, not a copy.",
            objective: "Entangle two coins, then MEASURE both to 'teleport' the state from one to the other.",
            hint: "Add coin → ENTANGLE → MEASURE both"
        ),
        QuantumQuest(
            id: 10,
            title: "Cryptography",
            theoryText: "Quantum Cryptography uses the laws of physics to secure data. By using entangled pairs, any attempt by an eavesdropper to intercept the key will disturb the quantum state, alerting the users immediately. It's the ultimate 'tamper-evident' seal for digital secrets.",
            objective: "Entangle two 'key' coins and MEASURE both. If they match, the channel is secure!",
            hint: "Add coin → ENTANGLE → MEASURE both"
        )
    ]

    /// The collection of quantum coins in the current level.
    @Published var coins: [QuantumCoin] = []

    /// The player's current level (1-indexed).
    @Published var currentLevel: Int = 1

    /// Cumulative score across all levels.
    @Published var score: Int = 0

    // ─── Quest Popup State ────────────────────────────────────────

    /// When `true`, the UI shows a sci-fi level-up popup.
    @Published var showLevelUpPopup: Bool = false

    /// Title displayed in the popup.
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
    // MARK: - Core Operations
    // ═════════════════════════════════════════════════════════════

    func applyHadamardGate(to coinID: UUID) {
        guard let idx = index(of: coinID) else { return }
        
        if coins[idx].isMeasured {
            statusMessage = "Cannot apply H-Gate: State already collapsed!"
            dismissStatusMessage()
            return
        }

        // Start timing if this is the first action
        if quests[currentLevel - 1].startTime == nil {
            quests[currentLevel - 1].startTime = Date()
        }

        // Mark that this coin has been interacted with
        coins[idx].hasBeenToggled = true
        
        // Toggling logic: H-gate applied twice returns state to normal
        if coins[idx].isSuperposed {
            coins[idx].probability = 1.0 // Return to Heads
            coins[idx].isSuperposed = false
        } else {
            coins[idx].probability = 0.5 // Enter Superposition
            coins[idx].isSuperposed = true
        }
        
        // Check if this action completes the current level (e.g., L1 superposition, L4 interference)
        checkLevelProgress()
    }

    func measure(coinID: UUID) {
        guard let idx = index(of: coinID) else { return }
        guard !coins[idx].isMeasured else { return }

        let randomValue = Double.random(in: 0...1)
        let result = randomValue < coins[idx].probability
        coins[idx].finalResult = result
        coins[idx].isMeasured = true

        if let partnerID = coins[idx].entangledPartnerID,
           let partnerIdx = index(of: partnerID),
           !coins[partnerIdx].isMeasured {
            coins[partnerIdx].finalResult = result
            coins[partnerIdx].isMeasured = true
        }

        checkLevelProgress()
    }

    func entangle(coin1ID: UUID, coin2ID: UUID) {
        guard let idx1 = index(of: coin1ID), let idx2 = index(of: coin2ID) else { return }
        guard !coins[idx1].isMeasured, !coins[idx2].isMeasured else {
            statusMessage = "Cannot entangle: Wave function already collapsed!"
            dismissStatusMessage()
            return
        }

        coins[idx1].entangledPartnerID = coin2ID
        coins[idx2].entangledPartnerID = coin1ID
        coins[idx1].probability = 0.5
        coins[idx2].probability = 0.5
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Quest Management
    // ═════════════════════════════════════════════════════════════

    func loadQuest(_ id: Int) {
        guard id >= 1 && id <= quests.count else { return }
        currentLevel = id
        resetCoins()
        
        // Mark start time if not already set
        if quests[id - 1].startTime == nil {
            quests[id - 1].startTime = Date()
        }
    }

    private func checkLevelProgress() {
        guard currentLevel >= 1 && currentLevel <= quests.count else { return }
        
        var isCleared = false
        
        switch currentLevel {
        case 1:
            // Superposition: Any coin put into superposition (H-gate applied)
            isCleared = coins.contains(where: { $0.isSuperposed })
        case 2:
            // Measurement: All coins measured
            isCleared = coins.count >= 1 && coins.allSatisfy({ $0.isMeasured })
        case 3:
            // Entanglement: Two entangled coins, at least one measured
            let entangledMeasured = coins.filter { $0.entangledPartnerID != nil && $0.isMeasured }
            isCleared = entangledMeasured.count >= 2
        case 4:
            // Interference: A coin was superposed then returned to deterministic via double H-gate
            // hasBeenToggled ensures we don't false-positive on a freshly-added coin
            isCleared = coins.contains(where: { $0.hasBeenToggled && !$0.isSuperposed && !$0.isMeasured && $0.probability == 1.0 })
        case 5:
            // Decoherence: Coin was in superposition and then measured (collapsed)
            isCleared = coins.contains(where: { $0.isMeasured })
        case 6:
            // No-Cloning: Two coins exist and both have been measured (showing they can't match)
            isCleared = coins.count >= 2 && coins.allSatisfy({ $0.isMeasured })
        case 7:
            // Tunneling: At least one coin measured (probabilistic result = tunneling)
            isCleared = coins.contains(where: { $0.isMeasured })
        case 8:
            // Zeno Effect: Two coins both measured (observing freezes them)
            isCleared = coins.count >= 2 && coins.allSatisfy({ $0.isMeasured })
        case 9:
            // Teleportation: Two entangled coins, both measured with matching results
            let entangled = coins.filter { $0.entangledPartnerID != nil && $0.isMeasured }
            isCleared = entangled.count >= 2
        case 10:
            // Cryptography: Two entangled coins, both measured with matching results
            let entangled = coins.filter { $0.entangledPartnerID != nil && $0.isMeasured }
            isCleared = entangled.count >= 2
        default:
            isCleared = coins.contains(where: { $0.isMeasured })
        }

        if isCleared {
            completeCurrentQuest()
        }
    }

    func completeCurrentQuest() {
        let questIdx = currentLevel - 1
        guard !quests[questIdx].isCompleted else { return }

        quests[questIdx].isCompleted = true
        
        // Record completion time
        if let start = quests[questIdx].startTime {
            quests[questIdx].completionTime = Date().timeIntervalSince(start)
        }

        score += 100 + (currentLevel * 25)
        
        popupTitle = "Quest \(currentLevel) Cleared!"
        popupMessage = quests[questIdx].theoryText
        showLevelUpPopup = true

        // Unlock next
        if currentLevel < quests.count {
            quests[currentLevel].isUnlocked = true
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Helpers
    // ═════════════════════════════════════════════════════════════

    @discardableResult
    func addCoin(probability: Double = 1.0) -> UUID {
        let coin = QuantumCoin(probability: probability)
        coins.append(coin)
        
        // Start timing on first coin add if not already set
        if quests[currentLevel - 1].startTime == nil {
            quests[currentLevel - 1].startTime = Date()
        }
        
        return coin.id
    }

    func resetCoins() {
        coins.removeAll()
        statusMessage = ""
    }

    private func dismissStatusMessage() {
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation(.easeOut(duration: 0.3)) {
                self.statusMessage = ""
            }
        }
    }
}
