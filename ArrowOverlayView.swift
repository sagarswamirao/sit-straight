import SwiftUI

struct ArrowOverlayView: View {
    @State private var scale: CGFloat = 0.3
    @State private var offsetY: CGFloat = 200
    @State private var opacity: Double = 0.0
    @State private var backgroundOpacity: Double = 0.0
    @State private var rotationAngle: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    private let audioManager = AudioManager()

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black
                .opacity(backgroundOpacity * 0.6)
                .ignoresSafeArea()

            // Arrow animation with LookAway-style effects
            VStack {
                Spacer()

                ZStack {
                    // Pulsing background circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.blue.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .scaleEffect(pulseScale)
                        .opacity(opacity * 0.6)

                    // Main arrow with enhanced styling
                    ZStack {
                        // Custom arrow image
                        if let image = NSImage(named: "arrow-up") {
                            Image(nsImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .scaleEffect(scale)
                                .rotationEffect(.degrees(rotationAngle))
                                .shadow(color: .blue.opacity(0.8), radius: 30, x: 0, y: 0)
                                .shadow(color: .cyan.opacity(0.6), radius: 15, x: 0, y: 0)
                        } else {
                            // Fallback to SF Symbol
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 120, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .cyan, .mint, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .scaleEffect(scale)
                                .rotationEffect(.degrees(rotationAngle))
                                .shadow(color: .blue.opacity(0.8), radius: 30, x: 0, y: 0)
                                .shadow(color: .cyan.opacity(0.6), radius: 15, x: 0, y: 0)
                        }
                    }
                }
                .offset(y: offsetY)
                .opacity(opacity)

                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    func startAnimation() {
        // Reset initial state
        scale = 0.1
        offsetY = 300
        opacity = 0.0
        backgroundOpacity = 0.0
        rotationAngle = -10.0
        pulseScale = 0.8

        // Play blink sound at start
        audioManager.playBlinkSound()

        // Animate background fade in with smooth transition
        withAnimation(.easeOut(duration: 0.8)) {
            backgroundOpacity = 1.0
        }

        // Animate arrow with enhanced timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Initial bounce-in effect
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.3)) {
                scale = 0.8
                offsetY = 50
                opacity = 0.8
                rotationAngle = 0.0
            }

            // Main rise animation with smooth easing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 2.5)) {
                    scale = 1.3
                    offsetY = -150
                    opacity = 1.0
                    rotationAngle = 8.0
                }
            }

            // Enhanced pulsing effect
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseScale = 1.4
            }

            // Play break reminder sound mid-animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                audioManager.playBreakReminderSound()
            }

            // Smooth fade out with upward motion
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeIn(duration: 2.0)) {
                    scale = 1.8
                    offsetY = -300
                    opacity = 0.0
                    rotationAngle = 15.0
                }
            }
        }

        // Fade out background smoothly
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeIn(duration: 1.5)) {
                backgroundOpacity = 0.0
            }
        }
    }
}
