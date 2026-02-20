import SwiftUI

/// A single particle used by `QuantumFieldBackground` to simulate
/// floating neon orbs drifting through a quantum nebula.
struct QuantumParticle: Identifiable {
    let id = UUID()
    let size: CGFloat
    let position: CGPoint
    let color: Color
    let speed: Double
    let blur: CGFloat
}

/// Full-screen animated background: shifting dark gradients combined
/// with ~30 blurred neon circles drifting in random paths.
struct QuantumFieldBackground: View {
    @State private var animateGradient = false
    @State private var particles: [QuantumParticle] = []
    @State private var particleOffsets: [UUID: CGSize] = [:]

    private let particleColors: [Color] = [
        Color.cyan.opacity(0.4),
        Color.purple.opacity(0.35),
        Color.green.opacity(0.3),
        Color.blue.opacity(0.3),
        Color.pink.opacity(0.25)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: animateGradient
                        ? [Color(red: 0.02, green: 0.0, blue: 0.12),
                           Color(red: 0.08, green: 0.0, blue: 0.2),
                           Color(red: 0.0, green: 0.06, blue: 0.15)]
                        : [Color(red: 0.0, green: 0.04, blue: 0.18),
                           Color(red: 0.1, green: 0.0, blue: 0.15),
                           Color(red: 0.02, green: 0.0, blue: 0.1)],
                    startPoint: animateGradient ? .topLeading : .bottomTrailing,
                    endPoint: animateGradient ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()

                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .blur(radius: particle.blur)
                        .position(particle.position)
                        .offset(particleOffsets[particle.id] ?? .zero)
                }
            }
            .onAppear {
                generateParticles(in: geo.size)
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    for particle in particles {
                        withAnimation(
                            .easeInOut(duration: particle.speed)
                            .repeatForever(autoreverses: true)
                        ) {
                            particleOffsets[particle.id] = CGSize(
                                width: CGFloat.random(in: -40...40),
                                height: CGFloat.random(in: -60...60)
                            )
                        }
                    }
                }
            }
        }
    }

    private func generateParticles(in size: CGSize) {
        var result: [QuantumParticle] = []
        var offsets: [UUID: CGSize] = [:]
        for _ in 0..<30 {
            let p = QuantumParticle(
                size: CGFloat.random(in: 4...50),
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                color: particleColors.randomElement()!,
                speed: Double.random(in: 5...12),
                blur: CGFloat.random(in: 6...25)
            )
            result.append(p)
            offsets[p.id] = .zero
        }
        particles = result
        particleOffsets = offsets
    }
}
