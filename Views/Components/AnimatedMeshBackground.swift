import SwiftUI

// ═══════════════════════════════════════════════════════════════════
// MARK: - AnimatedMeshBackground
// ═══════════════════════════════════════════════════════════════════
//
// A high-end "Spatial Computing" style animated mesh gradient.
// Uses smooth, slow-moving blurred circles in the accent colors
// to create a dynamic, living background that feels premium but subtle.
// ═══════════════════════════════════════════════════════════════════

struct AnimatedMeshBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Animation states for the mesh points
    @State private var point1: UnitPoint = .topLeading
    @State private var point2: UnitPoint = .bottomTrailing
    @State private var point3: UnitPoint = .center
    
    var body: some View {
        ZStack {
            // Base layer color
            Color(colorScheme == .light ? UIColor(red: 0.95, green: 0.96, blue: 0.99, alpha: 1.0) : UIColor(red: 0.02, green: 0.0, blue: 0.08, alpha: 1.0))
                .ignoresSafeArea()
            
            // Animated blobs
            GeometryReader { proxy in
                ZStack {
                    // Blob 1 - Cyan
                    Circle()
                        .fill(ThemeColors.cyan(for: colorScheme).opacity(colorScheme == .light ? 0.3 : 0.4))
                        .blur(radius: 80)
                        .frame(width: proxy.size.width * 1.5)
                        .position(x: proxy.size.width * point1.x, y: proxy.size.height * point1.y)
                    
                    // Blob 2 - Purple
                    Circle()
                        .fill(ThemeColors.purple(for: colorScheme).opacity(colorScheme == .light ? 0.2 : 0.3))
                        .blur(radius: 90)
                        .frame(width: proxy.size.width * 1.2)
                        .position(x: proxy.size.width * point2.x, y: proxy.size.height * point2.y)
                    
                    // Blob 3 - Pink (subtle)
                    Circle()
                        .fill(ThemeColors.pink(for: colorScheme).opacity(colorScheme == .light ? 0.15 : 0.2))
                        .blur(radius: 100)
                        .frame(width: proxy.size.width * 1.0)
                        .position(x: proxy.size.width * point3.x, y: proxy.size.height * point3.y)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                startAnimation()
            }
        }
    }
    
    // Slow, fluid animation for the mesh points
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            point1 = .bottomTrailing
            point2 = .topLeading
            point3 = .topTrailing
        }
    }
}
