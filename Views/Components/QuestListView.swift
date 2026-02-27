import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - QuestListView (Quest Select Half-Sheet)
// ═══════════════════════════════════════════════════════════════════
//
// A scrollable list of all 10 quests. Completed quests are tappable
// for replay. Locked quests appear dimmed. Matches the dark neon
// sci-fi glassmorphism aesthetic.
// ═══════════════════════════════════════════════════════════════════

struct QuestListView: View {
    @EnvironmentObject var viewModel: QuantumViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    private let questIcons: [String] = [
        "waveform.path.ecg", "scope", "link",
        "arrow.triangle.2.circlepath", "wind", "doc.on.doc",
        "arrow.right.to.line", "eye.fill", "paperplane.fill",
        "lock.shield.fill"
    ]

    private let questColors: [Color] = [
        .cyan, .orange, .pink, .purple, .yellow,
        .red, .green, .blue, .mint, .indigo
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: ThemeColors.sheetBackgroundColors(for: colorScheme),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {

                    // Header
                    headerView

                    // Progress bar
                    progressBar

                    // Quest cards
                    ForEach(Array(viewModel.quests.enumerated()), id: \.element.id) { idx, quest in
                        let color = questColors[idx % questColors.count]
                        let icon = questIcons[idx % questIcons.count]

                        questCard(
                            quest: quest,
                            index: idx,
                            color: color,
                            icon: icon
                        )
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - Sub-views
    // ═══════════════════════════════════════════════════════════════

    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "map.fill")
                .font(.system(size: 36))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .cyan.opacity(0.5), radius: 10)

            Text("QUEST SELECT")
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(ThemeColors.heading(for: colorScheme))
                .tracking(3)

            Text("\(viewModel.quests.filter(\.isCompleted).count) of \(viewModel.quests.count) cleared")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(ThemeColors.cyan(for: colorScheme).opacity(0.6))
        }
        .padding(.bottom, 4)
    }

    private var progressBar: some View {
        let completed = Double(viewModel.quests.filter(\.isCompleted).count)
        let total = Double(viewModel.quests.count)
        let progress = total > 0 ? completed / total : 0.0

        return VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.06))
                        .frame(height: 6)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress, height: 6)
                        .shadow(color: .cyan.opacity(0.5), radius: 4)
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 4)
    }

    private func questCard(
        quest: QuantumQuest,
        index: Int,
        color: Color,
        icon: String
    ) -> some View {
        let isCurrent = quest.id == viewModel.currentLevel
        let canTap = quest.isUnlocked

        return Button {
            if canTap {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.loadQuest(quest.id)
                }
                dismiss()
            }
        } label: {
            HStack(spacing: 14) {
                // Quest number badge
                ZStack {
                    Circle()
                        .fill(quest.isCompleted
                              ? color
                              : (quest.isUnlocked ? color.opacity(0.2) : Color.primary.opacity(0.04))
                        )
                        .frame(width: 40, height: 40)

                    if quest.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    } else if quest.isUnlocked {
                        Text("\(quest.id)")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(color)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }

                // Quest info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: icon)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(quest.isUnlocked ? color : color.opacity(0.2))

                        Text(quest.title)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(quest.isUnlocked ? ThemeColors.heading(for: colorScheme) : ThemeColors.dimText(for: colorScheme))
                    }

                    if quest.isUnlocked {
                        Text(quest.objective)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }

                Spacer()

                // Status indicator
                if isCurrent && !quest.isCompleted {
                    Text("NOW")
                        .font(.system(size: 9, weight: .heavy, design: .monospaced))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(color)
                                .shadow(color: color.opacity(0.5), radius: 4)
                        )
                } else if quest.isCompleted {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(color.opacity(0.6))
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isCurrent
                          ? .ultraThinMaterial
                          : .regularMaterial
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isCurrent
                                    ? color.opacity(0.4)
                                    : Color.primary.opacity(quest.isUnlocked ? 0.06 : 0.02),
                                lineWidth: isCurrent ? 1.5 : 1
                            )
                    )
            )
            .opacity(quest.isUnlocked ? 1.0 : 0.4)
        }
        .disabled(!canTap)
    }
}
