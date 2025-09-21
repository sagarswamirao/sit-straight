import SwiftUI

struct ArrowOverlayView: View {
    @State private var scale: CGFloat = 0.3
    @State private var offsetY: CGFloat = 200
    @State private var opacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black
                .opacity(backgroundOpacity * 0.6)
                .ignoresSafeArea()

            // Arrow animation
            VStack {
                Spacer()

                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 120, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(scale)
                    .offset(y: offsetY)
                    .opacity(opacity)
                    .shadow(color: .blue.opacity(0.6), radius: 20, x: 0, y: 0)

                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    func startAnimation() {
        // Reset initial state
        scale = 0.3
        offsetY = 200
        opacity = 0.0
        backgroundOpacity = 0.0

        // Animate background fade in
        withAnimation(.easeOut(duration: 0.5)) {
            backgroundOpacity = 1.0
        }

        // Animate arrow with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 4.0)) {
                scale = 1.2
                offsetY = -100
                opacity = 1.0
            }

            // Fade out in the last second
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeIn(duration: 1.0)) {
                    scale = 1.5
                    offsetY = -200
                    opacity = 0.0
                }
            }
        }

        // Fade out background at the end
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeIn(duration: 1.0)) {
                backgroundOpacity = 0.0
            }
        }
    }
}
