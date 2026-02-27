import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - SettingsView (Theme + Info)
// ═══════════════════════════════════════════════════════════════════

struct SettingsView: View {
    @EnvironmentObject var viewModel: QuantumViewModel
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    settingsHeader


                    // Appearance & Tour
                    settingsCard(title: "APPEARANCE", icon: "paintbrush.fill", color: .purple) {
                        appearanceSection
                    }

                    // About section
                    settingsCard(title: "ABOUT", icon: "atom", color: .cyan) {
                        aboutSection
                    }

                    // Credits
                    settingsCard(title: "CREDITS", icon: "heart.fill", color: .pink) {
                        creditsSection
                    }

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
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

    private var settingsHeader: some View {
        VStack(spacing: 6) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 36))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .cyan.opacity(0.5), radius: 10)

            Text("SETTINGS")
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(ThemeColors.heading(for: colorScheme))
                .tracking(3)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private func settingsCard<Content: View>(
        title: String,
        icon: String,
        color: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                    .foregroundColor(color)
                    .tracking(2)
            }

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.3), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The interface is locked to a premium Dark Sci-Fi theme for the best experience.")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(ThemeColors.subtext(for: colorScheme))

            Button {
                viewModel.startTutorial()
            } label: {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("RESTART QUICK TOUR")
                }
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.cyan))
            }
        }
    }


    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            infoRow(label: "App", value: "Quantum Flip Quest")
            infoRow(label: "Version", value: "1.0")
            infoRow(label: "Framework", value: "SwiftUI")
            infoRow(label: "Platform", value: "Swift Playgrounds")
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(ThemeColors.dimText(for: colorScheme))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(ThemeColors.subtext(for: colorScheme))
        }
    }

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Built with \u{2764}\u{FE0F} for the WWDC Swift Student Challenge")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(ThemeColors.subtext(for: colorScheme))

            Text("Quantum mechanics concepts simplified for everyone to explore and enjoy.")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(ThemeColors.dimText(for: colorScheme))
                .lineSpacing(3)
        }
    }

    // ═══════════════════════════════════════════════════════════════
    // MARK: - About Helper
    // ═══════════════════════════════════════════════════════════════
}
