import SwiftUI

/// A glowing virtual coin with breathing scale + rotating energy
/// ring. When measured, the breathing stops and the coin "locks in"
/// with a brief flash. Supports configurable size for multi-coin layouts.
struct QuantumCoinView: View {
    @State private var breathe = false
    @State private var rotate = false
    @State private var measuredFlash = false

    let isMeasured: Bool
    let result: Bool?
    let isEntangled: Bool
    var coinSize: CGFloat = 120

    /// Derived sizes relative to coinSize
    private var ringSize: CGFloat { coinSize * 1.67 }
    private var haloSize: CGFloat { coinSize * 2.17 }
    private var flashSize: CGFloat { coinSize * 2.33 }

    var body: some View {
        ZStack {
            // ── Collapse flash ring ──
            Circle()
                .fill(flashColor.opacity(measuredFlash ? 0.5 : 0.0))
                .frame(width: flashSize, height: flashSize)
                .blur(radius: 30)

            // ── Outer energy ring ──
            Circle()
                .stroke(
                    AngularGradient(
                        colors: ringColors,
                        center: .center
                    ),
                    lineWidth: coinSize > 80 ? 2.5 : 1.5
                )
                .frame(width: ringSize, height: ringSize)
                .blur(radius: 6)
                .rotationEffect(.degrees(rotate ? 360 : 0))
                .opacity(isMeasured ? 0.5 : 0.8)

            // ── Inner glow halo ──
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            (isMeasured ? resultGlowColor : glowColor)
                                .opacity(breathe && !isMeasured ? 0.25 : 0.08),
                            .clear
                        ],
                        center: .center,
                        startRadius: coinSize * 0.33,
                        endRadius: coinSize * 1.08
                    )
                )
                .frame(width: haloSize, height: haloSize)

            // ── The coin ──
            Image(systemName: coinSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: coinSize, height: coinSize)
                .foregroundStyle(coinGradient)
                .shadow(
                    color: (isMeasured ? resultGlowColor : glowColor)
                        .opacity(breathe && !isMeasured ? 0.9 : 0.4),
                    radius: breathe && !isMeasured ? coinSize * 0.25 : coinSize * 0.12
                )
                .shadow(color: .purple.opacity(isMeasured ? 0.1 : 0.3), radius: coinSize * 0.33)
                .scaleEffect(isMeasured ? 1.0 : (breathe ? 1.08 : 0.94))
                .rotationEffect(.degrees(isMeasured ? 0 : (breathe ? 2 : -2)))

            // ── Entangled indicator ring ──
            if isEntangled && !isMeasured {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.pink, .purple, .pink],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: ringSize + 16, height: ringSize + 16)
                    .opacity(breathe ? 0.8 : 0.3)
                    .blur(radius: 2)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                breathe = true
            }
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotate = true
            }
        }
        .onChange(of: isMeasured) { measured in
            if measured {
                withAnimation(.easeOut(duration: 0.15)) {
                    measuredFlash = true
                }
                withAnimation(.easeIn(duration: 0.6).delay(0.15)) {
                    measuredFlash = false
                }
            }
        }
    }

    // MARK: - Computed Helpers

    private var coinSymbol: String {
        if isMeasured {
            return result == true ? "h.circle.fill" : "t.circle.fill"
        }
        return "circle.hexagongrid.fill"
    }

    private var coinGradient: LinearGradient {
        if isMeasured {
            return LinearGradient(
                colors: result == true ? [.green, .mint] : [.orange, .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        if isEntangled {
            return LinearGradient(
                colors: [.purple, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        return LinearGradient(
            colors: [.cyan, Color(red: 0.4, green: 0.7, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var glowColor: Color {
        isEntangled ? .purple : .cyan
    }

    private var ringColors: [Color] {
        if isMeasured {
            return [resultRingColor, resultRingColor.opacity(0.3), resultRingColor]
        }
        if isEntangled {
            return [.pink, .purple, .cyan, .pink]
        }
        return [.cyan, .purple, .mint, .cyan]
    }

    private var resultGlowColor: Color {
        result == true ? .green : .orange
    }

    private var resultRingColor: Color {
        result == true ? .green : .orange
    }

    private var flashColor: Color {
        result == true ? .green : .orange
    }
}
