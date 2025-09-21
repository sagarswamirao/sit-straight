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
        scale = 0.3
        offsetY = 200
        opacity = 0.0
        backgroundOpacity = 0.0
        rotationAngle = 0.0
        pulseScale = 1.0
        
        // Play blink sound at start
        audioManager.playBlinkSound()
        
        // Animate background fade in
        withAnimation(.easeOut(duration: 0.5)) {
            backgroundOpacity = 1.0
        }
        
        // Animate arrow with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Main rise animation
            withAnimation(.easeOut(duration: 3.0)) {
                scale = 1.2
                offsetY = -100
                opacity = 1.0
                rotationAngle = 5.0
            }
            
            // Pulsing effect during animation
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulseScale = 1.3
            }
            
            // Play break reminder sound mid-animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                audioManager.playBreakReminderSound()
            }
            
            // Fade out in the last second
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeIn(duration: 1.5)) {
                    scale = 1.5
                    offsetY = -200
                    opacity = 0.0
                    rotationAngle = 10.0
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
