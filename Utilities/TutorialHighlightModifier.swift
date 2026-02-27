import SwiftUI

struct TutorialHighlightModifier: ViewModifier {
    @ObservedObject var viewModel: QuantumViewModel
    let anchorID: String
    
    private var isHighlighted: Bool {
        viewModel.isTutorialActive && viewModel.tutorialSteps[viewModel.currentTutorialStep].highlightAnchor == anchorID
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isHighlighted ? Color.cyan : Color.clear, lineWidth: 3)
                    .shadow(color: isHighlighted ? .cyan : .clear, radius: 10)
                    .scaleEffect(isHighlighted ? 1.05 : 1.0)
                    .animation(isHighlighted ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: isHighlighted)
            )
            .zIndex(isHighlighted ? 2000 : 0)
    }
}

extension View {
    func tutorialHighlight(id: String, viewModel: QuantumViewModel) -> some View {
        self.modifier(TutorialHighlightModifier(viewModel: viewModel, anchorID: id))
    }
}
