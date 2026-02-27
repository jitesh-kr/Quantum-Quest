import SwiftUI

/// Defines a single step in the interactive onboarding tour.
struct TutorialStep: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let tabIndex: Int? // Which tab this step should be on (0: Dashboard, 1: Lab)
    let highlightAnchor: String? // ID for the element to highlight
}
