import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - TheorySheetView
// ═══════════════════════════════════════════════════════════════════
//
// A half/full-sheet presenting dynamic quantum theory cards based
// on the current coin states. Matches the dark neon sci-fi theme.
// ═══════════════════════════════════════════════════════════════════

struct TheorySheetView: View {
    let coins: [QuantumCoin]
    @Environment(\.dismiss) private var dismiss

    // ── Derived state ──
    private var hasUnmeasuredCoins: Bool {
        coins.contains(where: { !$0.isMeasured })
    }
    private var hasMeasuredCoins: Bool {
        coins.contains(where: { $0.isMeasured })
    }
    private var hasEntangledCoins: Bool {
        coins.contains(where: { $0.entangledPartnerID != nil })
    }

    var body: some View {
        ZStack {
            // Dark background
            LinearGradient(
                colors: [
                    Color(red: 0.02, green: 0.0, blue: 0.10),
                    Color(red: 0.04, green: 0.0, blue: 0.16),
                    .black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Header ──
                    headerView

                    // ── Theory Cards ──
                    // Always show Superposition — it's the foundation
                    theoryCard(
                        icon: "waveform.path.ecg",
                        title: "Superposition",
                        body: "Unlike normal bits (0 or 1), a Qubit exists in a blur of both Heads and Tails simultaneously until you measure it. It is pure probability.",
                        color: .cyan,
                        isActive: hasUnmeasuredCoins
                    )

                    theoryCard(
                        icon: "scope",
                        title: "Wave Function Collapse",
                        body: "The act of observing (measuring) a quantum system forces it to pick a definite state. The probability becomes reality. This is irreversible — you cannot \"un-measure\" a qubit.",
                        color: .orange,
                        isActive: hasMeasuredCoins
                    )

                    theoryCard(
                        icon: "link",
                        title: "Quantum Entanglement",
                        body: "The coins share a unified quantum state. Measuring one instantly dictates the state of the other — a phenomenon Einstein called \"spooky action at a distance.\" No information travels between them; the correlation is baked into the shared wave function.",
                        color: .pink,
                        isActive: hasEntangledCoins
                    )

                    // ── Try it hint ──
                    hintView

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - Sub-views
    // ═══════════════════════════════════════════════════════════════

    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "book.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .cyan.opacity(0.5), radius: 10)

            Text("QUANTUM THEORY")
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .tracking(3)

            Text("Tap a concept to learn more")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private func theoryCard(
        icon: String,
        title: String,
        body: String,
        color: Color,
        isActive: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isActive ? color : color.opacity(0.4))
                    .shadow(color: isActive ? color.opacity(0.6) : .clear, radius: 6)

                Text(title.uppercased())
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(isActive ? color : color.opacity(0.4))
                    .tracking(1.5)

                Spacer()

                if isActive {
                    Text("ACTIVE")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(color.opacity(0.15))
                        )
                }
            }

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(isActive ? 0.4 : 0.1), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Text(body)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(isActive ? 0.85 : 0.4))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    color.opacity(isActive ? 0.4 : 0.08),
                                    color.opacity(isActive ? 0.1 : 0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .opacity(isActive ? 1.0 : 0.6)
    }

    private var hintView: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow.opacity(0.7))
            Text(currentHint)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private var currentHint: String {
        if hasEntangledCoins && !hasMeasuredCoins {
            return "Try measuring one of the entangled coins to see spooky action!"
        }
        if hasMeasuredCoins && !hasEntangledCoins {
            return "Add a second coin and entangle them to explore quantum linking."
        }
        if !hasMeasuredCoins {
            return "Apply the H Gate to enter superposition, then MEASURE to collapse!"
        }
        return "Reset the lab and try different experiments!"
    }
}
