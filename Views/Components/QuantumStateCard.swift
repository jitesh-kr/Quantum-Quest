import SwiftUI

/// Frosted-glass card showing the current quantum state:
/// superposition probability bar, or collapsed result.
struct QuantumStateCard: View {
    let probability: Double
    let isMeasured: Bool
    let result: Bool?

    var body: some View {
        VStack(spacing: 12) {
            // Title row
            HStack {
                Image(systemName: "waveform.path")
                    .foregroundColor(.cyan)
                Text("QUANTUM STATE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyan.opacity(0.9))
                    .tracking(2)
                Spacer()

                Text(isMeasured ? "COLLAPSED" : "ACTIVE")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(isMeasured ? .orange : .green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(isMeasured
                                  ? Color.orange.opacity(0.15)
                                  : Color.green.opacity(0.15))
                    )
            }

            Divider().background(Color.white.opacity(0.1))

            if isMeasured, let result = result {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Result")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                        Text(result ? "HEADS ⬆" : "TAILS ⬇")
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .foregroundColor(result ? .green : .orange)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Probability")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                        Text(result ? "100% H" : "100% T")
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("State")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Superposition")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Probability")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                        let headsPercent = Int(probability * 100)
                        let tailsPercent = 100 - headsPercent
                        Text("\(headsPercent)% / \(tailsPercent)%")
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 6)
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.cyan, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * probability, height: 6)
                            .shadow(color: .cyan.opacity(0.5), radius: 4)
                    }
                }
                .frame(height: 6)
            }
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
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal, 20)
    }
}
