import SwiftUI

/// A glassmorphism card at the top of the game screen displaying
/// the current quest title and objective with a neon border.
struct QuestTrackerCard: View {
    let quest: QuantumQuest
    let level: Int
    @State private var borderPulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Quest header
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "target")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.cyan)
                    Text("QUEST \(level)")
                        .font(.system(size: 11, weight: .heavy, design: .monospaced))
                        .foregroundColor(.cyan)
                        .tracking(2)
                }

                Spacer()

                if quest.isCompleted {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11))
                        Text("CLEARED")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(.green)
                } else {
                    Text("IN PROGRESS")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                        .opacity(borderPulse ? 1.0 : 0.5)
                }
            }

            // Title
            Text(quest.title)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
                .shadow(color: .cyan.opacity(0.3), radius: 4)

            // Divider
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.cyan.opacity(0.4), .purple.opacity(0.2), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            // Objective
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.cyan.opacity(0.6))
                    .padding(.top, 1)

                Text(quest.objective)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(borderPulse ? 0.6 : 0.2),
                                    .purple.opacity(borderPulse ? 0.4 : 0.1),
                                    .cyan.opacity(borderPulse ? 0.6 : 0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                borderPulse = true
            }
        }
    }
}
