import Foundation

// ═══════════════════════════════════════════════════════════════════
// MARK: - QuantumQuest Model
// ═══════════════════════════════════════════════════════════════════

struct QuantumQuest: Identifiable {
    let id: Int
    let title: String
    let theoryText: String
    let objective: String
    let hint: String
    var isCompleted: Bool
    var isUnlocked: Bool

    /// Time taken to complete this quest (in seconds). Nil if not yet completed.
    var completionTime: TimeInterval?

    /// Timestamp when the quest was started (for tracking elapsed time).
    var startTime: Date?

    init(
        id: Int,
        title: String,
        theoryText: String,
        objective: String,
        hint: String = "",
        isCompleted: Bool = false,
        isUnlocked: Bool = false,
        completionTime: TimeInterval? = nil,
        startTime: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.theoryText = theoryText
        self.objective = objective
        self.hint = hint
        self.isCompleted = isCompleted
        self.isUnlocked = isUnlocked
        self.completionTime = completionTime
        self.startTime = startTime
    }

    /// Formatted completion time string (e.g. "1m 23s")
    var formattedTime: String? {
        guard let time = completionTime else { return nil }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        }
        return "\(seconds)s"
    }
}
