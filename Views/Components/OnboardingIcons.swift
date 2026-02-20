import SwiftUI

/// Slide 1 icon — pulsing cyan hexagon-grid coin with layered glow.
struct GlowingCoinIcon: View {
    @State private var glowPulse = false

    var body: some View {
        Image(systemName: "circle.hexagongrid.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .foregroundStyle(
                LinearGradient(
                    colors: [.cyan, Color(red: 0.3, green: 0.9, blue: 1.0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .cyan.opacity(glowPulse ? 0.9 : 0.4), radius: glowPulse ? 30 : 15)
            .shadow(color: .cyan.opacity(0.3), radius: 50)
            .scaleEffect(glowPulse ? 1.05 : 0.95)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    glowPulse = true
                }
            }
    }
}

/// Slide 2 icon — two ghost copies split apart (purple + cyan)
/// while the white core flickers, visualising superposition.
struct SuperpositionIcon: View {
    @State private var split = false
    @State private var flicker = false

    var body: some View {
        ZStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable().scaledToFit()
                .frame(width: 110, height: 110)
                .foregroundStyle(
                    LinearGradient(colors: [.purple, .pink],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .opacity(split ? 0.7 : 0.3)
                .offset(x: split ? -18 : 0, y: split ? -10 : 0)
                .shadow(color: .purple.opacity(0.8), radius: split ? 25 : 10)
                .blur(radius: split ? 1 : 3)

            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable().scaledToFit()
                .frame(width: 110, height: 110)
                .foregroundStyle(
                    LinearGradient(colors: [.cyan, .green],
                                   startPoint: .topTrailing, endPoint: .bottomLeading)
                )
                .opacity(split ? 0.7 : 0.3)
                .offset(x: split ? 18 : 0, y: split ? 10 : 0)
                .shadow(color: .green.opacity(0.8), radius: split ? 25 : 10)
                .blur(radius: split ? 1 : 3)

            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable().scaledToFit()
                .frame(width: 110, height: 110)
                .foregroundColor(.white)
                .opacity(flicker ? 1.0 : 0.5)
                .shadow(color: .white.opacity(0.6), radius: 15)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                split = true
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                flicker = true
            }
        }
    }
}

/// Slide 3 icon — linked-circle icon with a rotating orbital ring.
struct EntanglementIcon: View {
    @State private var rotate = false
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(colors: [.cyan, .purple, .green, .cyan], center: .center),
                    lineWidth: 2
                )
                .frame(width: 140, height: 140)
                .blur(radius: 4)
                .rotationEffect(.degrees(rotate ? 360 : 0))
                .shadow(color: .cyan.opacity(0.5), radius: 10)

            Image(systemName: "link.circle.fill")
                .resizable().scaledToFit()
                .frame(width: 110, height: 110)
                .foregroundStyle(
                    LinearGradient(colors: [.green, .cyan],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(color: .green.opacity(glowPulse ? 0.9 : 0.4), radius: glowPulse ? 30 : 15)
                .shadow(color: .cyan.opacity(0.3), radius: 40)
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotate = true
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }
}
