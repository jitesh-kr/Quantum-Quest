import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - DashboardView (Level Select Grid)
// ═══════════════════════════════════════════════════════════════════

struct DashboardView: View {
    @EnvironmentObject var viewModel: QuantumViewModel
    @Binding var selectedTab: Int
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

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            AnimatedMeshBackground()

            // Main content
            VStack(spacing: 0) {
                // Hero Section: Player Stats Card (Fixed at top)
                playerStatsCard
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 14)

                // Quest Grid (Scrollable)
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(Array(viewModel.quests.enumerated()), id: \.element.id) { idx, quest in
                            questCard(quest: quest, index: idx)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .padding(.bottom, 90) // Clear space for the floating playButton
                    .tutorialHighlight(id: "questGrid", viewModel: viewModel)
                }
                .clipped() // Clip scrolling content at the boundary
            }

            // Floating Play Button (pinned above tab bar)
            playButton
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - Sub-views
    // ═══════════════════════════════════════════════════════════════

    private var backgroundGradient: some View {
        RadialGradient(
            colors: ThemeColors.backgroundColors(for: colorScheme),
            center: .top,
            startRadius: 100,
            endRadius: 600
        )
        .ignoresSafeArea()
    }

    private var playerStatsCard: some View {
        let cleared = viewModel.quests.filter(\.isCompleted).count
        let total = viewModel.quests.count
        let progress = total > 0 ? Double(cleared) / Double(total) : 0.0

        return VStack(spacing: 20) {
            // Top Row: Title & Energy
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("QUANTUM QUEST")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(ThemeColors.heading(for: colorScheme))
                        .tracking(2)
                    
                    Text("Master the Quantum World")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(ThemeColors.dimText(for: colorScheme))
                }
                
                Spacer()
                
                // Energy/Streak Indicator
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 14))
                    Text("100%")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeColors.heading(for: colorScheme))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.yellow.opacity(0.15))
                .clipShape(Capsule())
            }

            Divider()
                .background(Color.primary.opacity(0.1))

            // Bottom Row: Progress Ring & Stats
            HStack(spacing: 24) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.06), lineWidth: 8)
                        .frame(width: 76, height: 76)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 76, height: 76)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: .cyan.opacity(0.4), radius: 8)

                    VStack(spacing: 2) {
                        Text("\(cleared)/\(total)")
                            .font(.system(size: 16, weight: .black, design: .monospaced))
                            .foregroundColor(ThemeColors.heading(for: colorScheme))
                        Text("CLEARED")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(ThemeColors.dimText(for: colorScheme))
                    }
                }

                // Stats Stack
                VStack(alignment: .leading, spacing: 12) {
                    statRow(icon: "star.fill", color: .cyan, label: "Current Level", value: "\(viewModel.currentLevel)")
                    statRow(icon: "gamecontroller.fill", color: .purple, label: "Total Score", value: "\(viewModel.score)")
                }
                
                Spacer()
            }
        }
        .padding(20)
        .liquidGlass(cornerRadius: 24, accentColor: .cyan)
        .tutorialHighlight(id: "playerStats", viewModel: viewModel)
    }

    private func statRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 20)
                
            VStack(alignment: .leading, spacing: 2) {
                Text(label.uppercased())
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundColor(ThemeColors.dimText(for: colorScheme))
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(ThemeColors.heading(for: colorScheme))
            }
        }
    }

    private func questCard(quest: QuantumQuest, index: Int) -> some View {
        let color = questColors[index % questColors.count]
        let icon = questIcons[index % questIcons.count]

        return Button {
            if quest.isUnlocked {
                viewModel.loadQuest(quest.id)
                selectedTab = 1 // Switch to game tab
            }
        } label: {
            VStack(spacing: 10) {
                // Quest icon
                ZStack {
                    Circle()
                        .fill(quest.isCompleted ? color.opacity(0.2) : Color.primary.opacity(0.04))
                        .frame(width: 50, height: 50)

                    if quest.isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 24))
                            .foregroundColor(color)
                    } else if quest.isUnlocked {
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(color)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                    }
                }

                // Quest number + title
                VStack(spacing: 3) {
                    Text("QUEST \(quest.id)")
                        .font(.system(size: 9, weight: .heavy, design: .monospaced))
                        .foregroundColor(quest.isUnlocked ? color.opacity(0.6) : .primary.opacity(0.15))
                        .tracking(1)

                    Text(quest.title)
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(quest.isUnlocked ? ThemeColors.heading(for: colorScheme) : ThemeColors.dimText(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                // Badges
                if quest.isCompleted {
                    HStack(spacing: 4) {
                        if let time = quest.formattedTime {
                            HStack(spacing: 3) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 8))
                                Text(time)
                                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                            }
                            .foregroundColor(color.opacity(0.7))
                        }
                    }
                } else if quest.id == viewModel.currentLevel {
                    Text("CURRENT")
                        .font(.system(size: 8, weight: .heavy, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(color))
                } else if !quest.isUnlocked {
                    Text("LOCKED")
                        .font(.system(size: 8, weight: .bold, design: .monospaced))
                        .foregroundColor(ThemeColors.dimText(for: colorScheme))
                }

                // Hint
                if quest.isUnlocked && !quest.hint.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 7))
                        Text(quest.hint)
                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                    }
                    .foregroundColor(color.opacity(0.5))
                    .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .liquidGlass(
                cornerRadius: 16,
                accentColor: quest.isCompleted ? color : (quest.id == viewModel.currentLevel ? color : .clear)
            )
            .opacity(quest.isUnlocked ? 1.0 : 0.35)
        }
        .disabled(!quest.isUnlocked)
    }

    private var playButton: some View {
        Button {
            selectedTab = 1
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "play.fill")
                    .font(.system(size: 16, weight: .bold))
                Text("CONTINUE QUEST \(viewModel.currentLevel)")
                    .font(.system(size: 15, weight: .heavy, design: .monospaced))
                    .tracking(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyan.opacity(0.8), .purple.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .liquidGlass(cornerRadius: 32, accentColor: .cyan)
        }
        .scaleEffect(1.02)
        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.currentLevel)
        .padding(.top, 6)
        .tutorialHighlight(id: "playButton", viewModel: viewModel)
    }
}
