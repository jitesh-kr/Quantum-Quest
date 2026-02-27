import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - HomeTabView (Root Tab Navigation)
// ═══════════════════════════════════════════════════════════════════
//
// Main TabView with three tabs: Dashboard (home), Quantum Lab (game),
// and Settings. Uses a custom floating tab bar with glassmorphism.
// ═══════════════════════════════════════════════════════════════════

struct HomeTabView: View {
    @EnvironmentObject var viewModel: QuantumViewModel
    @State private var selectedTab: Int = 0
    @State private var breathe: Bool = false
    @Namespace private var tabAnimation
    @Environment(\.colorScheme) private var colorScheme

    // Gradient colors per tab for ambient glow
    private let tabGradients: [[Color]] = [
        [.cyan, .blue],       // Dashboard
        [.purple, .pink],     // Lab
        [.orange, .yellow]    // Settings
    ]

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
                    .safeAreaInset(edge: .bottom) { floatingTabBar }
                    .toolbar(.hidden, for: .tabBar)
                    .tag(0)

                MainGameView()
                    .environmentObject(viewModel)
                    .safeAreaInset(edge: .bottom) { floatingTabBar }
                    .toolbar(.hidden, for: .tabBar)
                    .tag(1)

                SettingsView()
                    .safeAreaInset(edge: .bottom) { floatingTabBar }
                    .toolbar(.hidden, for: .tabBar)
                    .tag(2)
            }
            .tint(.cyan)

            // Tutorial Overlay
            if viewModel.isTutorialActive {
                TutorialOverlayView(viewModel: viewModel, step: viewModel.tutorialSteps[viewModel.currentTutorialStep])
                    .zIndex(1000)
            }
        }
        .onChange(of: viewModel.currentTutorialStep) { stepIdx in
            if viewModel.isTutorialActive {
                if let requiredTab = viewModel.tutorialSteps[stepIdx].tabIndex {
                    withAnimation {
                        selectedTab = requiredTab
                    }
                }
            }
        }
        .onAppear {
            if !viewModel.hasSeenTour {
                viewModel.startTutorial()
            }
            // Start breathing animation
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                breathe = true
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - Premium Floating Glass Tab Bar
    // ═══════════════════════════════════════════════════════════════

    private var activeGlow: [Color] {
        tabGradients[selectedTab]
    }

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            glassTabItem(icon: "house.fill", label: "Dashboard", index: 0)
            glassTabItem(icon: "atom", label: "Lab", index: 1)
            glassTabItem(icon: "gearshape.fill", label: "Settings", index: 2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
        .background(
            // Capsule glass container
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    // 0.5px glass‐edge stroke
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.45),
                                    Color.white.opacity(0.08),
                                    Color.clear,
                                    Color.white.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        )
        // Ambient glow shadow that matches the active tab
        .shadow(color: activeGlow[0].opacity(0.2), radius: 20, y: 6)
        .shadow(color: activeGlow[1].opacity(0.1), radius: 30, y: 10)
        .shadow(color: .black.opacity(0.25), radius: 16, y: 8)
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedTab)
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - Individual Tab Item
    // ═══════════════════════════════════════════════════════════════

    private func glassTabItem(icon: String, label: String, index: Int) -> some View {
        let isSelected = selectedTab == index
        let colors = tabGradients[index]

        return Button {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()

            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 6) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(
                        isSelected
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                              )
                            : AnyShapeStyle(Color.white.opacity(0.35))
                    )
                    .scaleEffect(isSelected ? 1.18 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)

                // Label
                Text(label)
                    .font(.system(size: 9, weight: isSelected ? .heavy : .medium, design: .monospaced))
                    .tracking(0.3)
                    .foregroundStyle(
                        isSelected
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: colors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                              )
                            : AnyShapeStyle(Color.white.opacity(0.3))
                    )

                // Breathing indicator dot
                Circle()
                    .fill(
                        isSelected
                            ? LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [.clear, .clear], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 4, height: 4)
                    .scaleEffect(isSelected && breathe ? 1.6 : 1.0)
                    .opacity(isSelected ? (breathe ? 1.0 : 0.5) : 0)
                    .shadow(color: isSelected ? colors[0].opacity(0.7) : .clear, radius: 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                // Sliding highlight pill via matchedGeometryEffect
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(colors[0].opacity(0.08))
                            .overlay(
                                Capsule()
                                    .fill(.ultraThinMaterial.opacity(0.3))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(colors[0].opacity(0.12), lineWidth: 0.5)
                            )
                            .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                    }
                }
            )
        }
    }
}
