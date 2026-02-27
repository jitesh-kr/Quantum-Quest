import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - OnboardingView
// ═══════════════════════════════════════════════════════════════════
//
// Assembles the onboarding flow from reusable components in
// Views/Components/:
//   • QuantumFieldBackground  — animated nebula backdrop
//   • FloatingModifier        — zero-gravity bobbing
//   • GlowingCoinIcon / SuperpositionIcon / EntanglementIcon
//   • OnboardingSlideView     — single slide layout
//   • PageIndicator           — custom page dots
//   • GlowingButton           — CTA on the final slide
// ═══════════════════════════════════════════════════════════════════

// MARK: - Data Model

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconName: String
    let accentColor: Color
}

// MARK: - Single Onboarding Slide

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    let slideIndex: Int

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            iconForSlide(slideIndex)
                .floating(
                    amplitude: CGFloat.random(in: 6...12),
                    period: Double.random(in: 2.8...4.0)
                )
                .padding(.bottom, 10)

            Text(slide.title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .shadow(color: slide.accentColor.opacity(0.6), radius: 10)
                .floating(amplitude: 4, period: 3.5)

            Text(slide.subtitle)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)
                .floating(amplitude: 3, period: 4.0)

            Spacer()
            Spacer()
        }
        .padding()
    }

    @ViewBuilder
    private func iconForSlide(_ index: Int) -> some View {
        switch index {
        case 0:  GlowingCoinIcon()
        case 1:  SuperpositionIcon()
        case 2:  EntanglementIcon()
        default: GlowingCoinIcon()
        }
    }
}

// MARK: - Main Onboarding View

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    private let slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Welcome to the\nQuantum Realm",
            subtitle: "Where a coin flip isn't just Heads or Tails.",
            iconName: "circle.hexagongrid.fill",
            accentColor: .cyan
        ),
        OnboardingSlide(
            title: "Embrace\nUncertainty",
            subtitle: "Objects exist in multiple states at once until measured.",
            iconName: "arrow.triangle.2.circlepath",
            accentColor: .purple
        ),
        OnboardingSlide(
            title: "Quantum\nLink Quest",
            subtitle: "Connect coins and solve probability puzzles.",
            iconName: "link.circle.fill",
            accentColor: .green
        )
    ]

    var body: some View {
        ZStack {
            // Background
            QuantumFieldBackground()
                .ignoresSafeArea()

            // Slide pager
            TabView(selection: $currentPage) {
                ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                    OnboardingSlideView(slide: slide, slideIndex: index)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.4), value: currentPage)

            // Skip button — top right
            VStack {
                HStack {
                    Spacer()
                    if currentPage < slides.count - 1 {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                hasCompletedOnboarding = true
                            }
                        } label: {
                            Text("Skip")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                )
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: currentPage)

            // Bottom controls
            VStack {
                Spacer()

                if currentPage < slides.count - 1 {
                    VStack(spacing: 24) {
                        PageIndicator(
                            totalPages: slides.count,
                            currentPage: currentPage,
                            accentColor: slides[currentPage].accentColor
                        )

                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentPage += 1
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text("Next")
                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                slides[currentPage].accentColor,
                                                slides[currentPage].accentColor.opacity(0.6)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: slides[currentPage].accentColor.opacity(0.5), radius: 12)
                            )
                        }
                    }
                    .padding(.bottom, 50)
                    .transition(.opacity.combined(with: .scale))
                } else {
                    GlowingButton(title: "Enter Simulation") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            hasCompletedOnboarding = true
                        }
                    }
                    .padding(.bottom, 50)
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut(duration: 0.4), value: currentPage)
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
    }
}
