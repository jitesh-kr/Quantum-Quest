import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - ContentView  (Central Wiring Point)
// ═══════════════════════════════════════════════════════════════════
//
// The single place where the QuantumViewModel is created and the
// app's navigation state (onboarding vs game) is decided.
//
// • hasCompletedOnboarding is persisted via @AppStorage so the
//   onboarding only shows once.
// • The ViewModel is attached to MainGameView via .environmentObject
//   so every child view can read/mutate game state.
// ═══════════════════════════════════════════════════════════════════

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @StateObject private var viewModel = QuantumViewModel()

    var body: some View {
        if hasCompletedOnboarding {
            MainGameView()
                .environmentObject(viewModel)
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}
