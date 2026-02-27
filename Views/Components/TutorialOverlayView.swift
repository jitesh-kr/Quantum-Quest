import SwiftUI

/// A premium, sci-fi overlay that displays tutorial tooltips and highlights UI elements.
struct TutorialOverlayView: View {
    @ObservedObject var viewModel: QuantumViewModel
    let step: TutorialStep
    
    var body: some View {
        ZStack {
            // Semi-transparent dimming background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.nextTutorialStep()
                }
            
            VStack(spacing: 24) {
                Spacer()
                
                // Tooltip Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(step.title.uppercased())
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.cyan)
                            .tracking(2)
                        
                        Spacer()
                        
                        Text("\(viewModel.currentTutorialStep + 1)/\(viewModel.tutorialSteps.count)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Text(step.message)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                    
                    HStack {
                        Button {
                            viewModel.endTutorial()
                        } label: {
                            Text("SKIP")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.nextTutorialStep()
                        } label: {
                            HStack(spacing: 8) {
                                Text(viewModel.currentTutorialStep == viewModel.tutorialSteps.count - 1 ? "FINISH" : "NEXT")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 14, weight: .heavy, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(Color.cyan))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(colors: [.cyan.opacity(0.6), .purple.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 2
                                )
                        )
                )
                .shadow(color: .cyan.opacity(0.3), radius: 20)
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // Keep it above the tab bar/floating buttons
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}
