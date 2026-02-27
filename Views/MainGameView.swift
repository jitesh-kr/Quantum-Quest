import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - MainGameView  (Quantum Lab Home Tab)
// ═══════════════════════════════════════════════════════════════════
//
// Assembles the game screen from reusable components in
// Views/Components/:
//   • QuantumCoinView         — animated energy coin (scalable)
//   • EntanglementLinkView    — glowing link between entangled coins
//   • QuantumStateCard        — glassmorphism education panel
//   • NeonButton              — MEASURE / ENTANGLE controls
// ═══════════════════════════════════════════════════════════════════

struct MainGameView: View {
    @EnvironmentObject var viewModel: QuantumViewModel

    /// Selected coin for MEASURE / H-Gate actions
    @State private var selectedCoinID: UUID?

    /// Controls the educational theory sheet
    @State private var showTheory = false

    // ── Convenience ──
    private var coinCount: Int { viewModel.coins.count }
    private var canAddCoin: Bool { coinCount < 2 }
    private var hasTwoCoins: Bool { coinCount >= 2 }

    private var areEntangled: Bool {
        guard hasTwoCoins else { return false }
        return viewModel.coins[0].entangledPartnerID != nil
    }

    private var anyMeasured: Bool {
        viewModel.coins.contains(where: { $0.isMeasured })
    }

    private var canEntangle: Bool {
        hasTwoCoins && !anyMeasured && !areEntangled
    }

    private var selectedCoin: QuantumCoin? {
        guard let id = selectedCoinID else { return viewModel.coins.first }
        return viewModel.coins.first(where: { $0.id == id })
    }

    /// The coin size adapts: larger when alone, smaller when paired.
    private var coinDisplaySize: CGFloat {
        hasTwoCoins ? 80 : 120
    }

    var body: some View {
        ZStack {
            // ── Deep-space background ──
            RadialGradient(
                colors: [
                    Color(red: 0.06, green: 0.0, blue: 0.14),
                    Color(red: 0.02, green: 0.0, blue: 0.08),
                    .black
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // ═══════════════════════════════
                // MARK: Header
                // ═══════════════════════════════
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                Spacer()

                // ═══════════════════════════════
                // MARK: Coin Arena  (1 or 2 coins)
                // ═══════════════════════════════
                coinArenaView
                    .padding(.bottom, 16)

                // ═══════════════════════════════
                // MARK: Education Panel
                // ═══════════════════════════════
                QuantumStateCard(
                    probability: selectedCoin?.probability ?? 0.5,
                    isMeasured: selectedCoin?.isMeasured ?? false,
                    result: selectedCoin?.finalResult
                )
                .padding(.bottom, 8)

                Spacer()

                // ═══════════════════════════════
                // MARK: Controls
                // ═══════════════════════════════
                controlsView
                    .padding(.horizontal, 20)
                    .padding(.bottom, viewModel.statusMessage.isEmpty ? 28 : 8)

                // ── Inline Status Message ──
                if !viewModel.statusMessage.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 13))
                        Text(viewModel.statusMessage)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.orange.opacity(0.9))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .overlay {
            if viewModel.showLevelUpPopup {
                QuestPopupView(
                    title: viewModel.popupTitle,
                    message: viewModel.popupMessage
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.showLevelUpPopup = false
                        
                        // Auto-advance logic
                        if viewModel.currentLevel < viewModel.quests.count {
                            viewModel.loadQuest(viewModel.currentLevel + 1)
                        }
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(100)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.showLevelUpPopup)
        .sheet(isPresented: $showTheory) {
            TheorySheetView(coins: viewModel.coins)
        }
        .onAppear {
            if viewModel.coins.isEmpty {
                viewModel.addCoin(probability: 1.0) // Start deterministic — user must apply H Gate
            }
            selectedCoinID = viewModel.coins.first?.id
        }
    }

    // ── Header ──
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("QUANTUM LAB")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(3)
                Text("Level \(viewModel.currentLevel)")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundColor(.cyan.opacity(0.7))
            }
            Spacer()

            // Glowing info button
            Button {
                showTheory = true
            } label: {
                Image(systemName: "book.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .cyan.opacity(0.5), radius: 6)
            }
            .padding(.trailing, 8)
            .tutorialHighlight(id: "theoryButton", viewModel: viewModel)

            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.yellow)
                Text("\(viewModel.score)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
        }
    }

    // ── Coin Arena ──
    private var coinArenaView: some View {
        HStack(spacing: 0) {
            // Coin 1 (always present)
            if let coin1 = viewModel.coins.first {
                coinButton(for: coin1)
            }

            // Entanglement link or spacer
            if hasTwoCoins {
                if areEntangled {
                    EntanglementLinkView()
                        .frame(width: 60)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    // Subtle dashed connector when 2 coins but not yet entangled
                    VStack(spacing: 4) {
                        Image(systemName: "link.badge.plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .frame(width: 60)
                }
            }

            // Coin 2 or Add Coin ghost button
            if coinCount >= 2, let coin2 = viewModel.coins.dropFirst().first {
                coinButton(for: coin2)
            } else if canAddCoin {
                addCoinButton
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: coinCount)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: areEntangled)
        .tutorialHighlight(id: "coinStage", viewModel: viewModel)
    }

    // ── Single tappable coin ──
    private func coinButton(for coin: QuantumCoin) -> some View {
        QuantumCoinView(
            isMeasured: coin.isMeasured,
            result: coin.finalResult,
            isEntangled: coin.entangledPartnerID != nil,
            isSuperposed: coin.isSuperposed,
            coinSize: coinDisplaySize
        )
        .overlay(
            // Selection ring
            Circle()
                .stroke(Color.white.opacity(selectedCoinID == coin.id ? 0.4 : 0.0), lineWidth: 2)
                .frame(
                    width: coinDisplaySize * 1.8,
                    height: coinDisplaySize * 1.8
                )
                .animation(.easeInOut(duration: 0.2), value: selectedCoinID)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedCoinID = coin.id
            }
        }
    }

    // ── Add Coin ghost button ──
    private var addCoinButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                let newID = viewModel.addCoin(probability: 0.5)
                selectedCoinID = newID
            }
        } label: {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.12), style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                    .frame(width: coinDisplaySize * 1.2, height: coinDisplaySize * 1.2)

                VStack(spacing: 6) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(.white.opacity(0.25))
                    Text("Add Coin")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.25))
                }
            }
        }
    }

    // ── Controls ──
    private var controlsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // MEASURE — collapses selected coin (+ entangled partner)
                NeonButton(
                    title: "MEASURE",
                    subtitle: "Collapse",
                    icon: "scope",
                    color: .cyan
                ) {
                    guard let id = selectedCoin?.id else { return }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        viewModel.measure(coinID: id)
                    }
                }
                .tutorialHighlight(id: "measureButton", viewModel: viewModel)

                // ENTANGLE — active only when exactly 2 unmeasured coins
                NeonButton(
                    title: "ENTANGLE",
                    subtitle: entangleSubtitle,
                    icon: "link",
                    color: canEntangle
                        ? Color(red: 0.9, green: 0.1, blue: 0.6)
                        : Color.gray
                ) {
                    guard hasTwoCoins else { return }
                    let c = viewModel.coins
                    guard !c[0].isMeasured, !c[1].isMeasured else {
                        viewModel.statusMessage = "Cannot entangle: Wave function already collapsed! Use H-Gate to reset to Superposition."
                        return
                    }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        viewModel.entangle(coin1ID: c[0].id, coin2ID: c[1].id)
                    }
                }
                .tutorialHighlight(id: "entangleButton", viewModel: viewModel)
                .opacity(canEntangle || !hasTwoCoins ? 1.0 : 0.5)
                .allowsHitTesting(canEntangle || !hasTwoCoins)
            }

            HStack(spacing: 12) {
                // Hadamard gate on selected coin
                Button {
                    guard let id = selectedCoin?.id else { return }
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.applyHadamardGate(to: id)
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("H")
                            .font(.system(size: 18, weight: .heavy, design: .monospaced))
                        Text("Gate")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                    .tutorialHighlight(id: "hGate", viewModel: viewModel)
                }

                // Reset
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.resetCoins()
                        // Re-add one coin (deterministic start)
                        let newID = viewModel.addCoin(probability: 1.0)
                        selectedCoinID = newID
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .bold))
                        Text("Reset")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }

    private var entangleSubtitle: String {
        if areEntangled { return "Linked ✓" }
        if hasTwoCoins && anyMeasured { return "Collapsed ✕" }
        if hasTwoCoins { return "Link Coins" }
        return "Need 2 Coins"
    }
}

// MARK: - Preview

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
            .environmentObject(QuantumViewModel())
    }
}
