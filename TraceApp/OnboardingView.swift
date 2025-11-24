import SwiftUI
import CoreHaptics

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var onboardingPhase: Int = 1
    @State private var brightness: Double = 0.0
    @State private var tracedLineProgress: CGFloat = 0.0
    @State private var hapticEngine: CHHapticEngine?
    @State private var connectedUsers: Int = Int.random(in: 3000...5000)
    
    var body: some View {
        ZStack {
            // Phase 1: The Calibrate (0-10 seconds)
            if onboardingPhase == 1 {
                CalibrateView(brightness: $brightness, onComplete: {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        onboardingPhase = 2
                    }
                })
            }
            
            // Phase 2: The First Mark (10-30 seconds)
            else if onboardingPhase == 2 {
                FirstMarkView(progress: $tracedLineProgress, onComplete: {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        onboardingPhase = 3
                    }
                })
            }
            
            // Phase 3: The Release (30-60 seconds)
            else if onboardingPhase == 3 {
                ReleaseView(connectedUsers: connectedUsers, onComplete: {
                    appState.hasCompletedOnboarding = true
                    appState.saveUserPreferences()
                })
            }
        }
        .onAppear {
            prepareHaptics()
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic engine failed to start: \(error)")
        }
    }
}

// Phase 1: Calibrate - Place thumb to ground yourself
struct CalibrateView: View {
    @Binding var brightness: Double
    @State private var isPressed: Bool = false
    @State private var breathingTimer: Timer?
    @State private var breathingPhase: Double = 0.0
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // The blooming light around finger
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(brightness),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 300
                    )
                )
                .scaleEffect(isPressed ? 1.5 : 1.0)
                .animation(.easeInOut(duration: 4.0), value: isPressed)
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("Place your thumb on the screen to ground yourself.")
                    .font(TraceTheme.bodyFont)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        startBreathingCycle()
                    }
                }
                .onEnded { _ in
                    // Keep the effect going
                }
        )
    }
    
    func startBreathingCycle() {
        // Create breathing rhythm (4 seconds in, 4 seconds out)
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            breathingPhase += 0.1
            
            // Breathing cycle: 4 seconds in, 4 seconds out
            let cycle = breathingPhase.truncatingRemainder(dividingBy: 8.0)
            if cycle < 4.0 {
                // Inhale
                brightness = cycle / 4.0
            } else {
                // Exhale
                brightness = (8.0 - cycle) / 4.0
            }
            
            // Trigger haptic at peak and valley
            if abs(cycle - 4.0) < 0.1 || cycle < 0.1 {
                HapticManager.shared.playBreathingPulse()
            }
            
            // Complete after 10 seconds
            if breathingPhase >= 10.0 {
                breathingTimer?.invalidate()
                onComplete()
            }
        }
    }
}

// Phase 2: First Mark - Trace the line
struct FirstMarkView: View {
    @Binding var progress: CGFloat
    @State private var currentPoint: CGPoint = .zero
    var onComplete: () -> Void
    
    let guidePath = Path { path in
        path.move(to: CGPoint(x: 50, y: 300))
        path.addCurve(
            to: CGPoint(x: 350, y: 300),
            control1: CGPoint(x: 150, y: 200),
            control2: CGPoint(x: 250, y: 400)
        )
    }
    
    var body: some View {
        ZStack {
            TraceTheme.unbleachedPaper
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Trace the line.")
                    .font(TraceTheme.bodyFont)
                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.6))
                    .padding(.bottom, 100)
                
                ZStack {
                    // Guide path (faint)
                    guidePath
                        .stroke(TraceTheme.driedCharcoal.opacity(0.2), lineWidth: 3)
                    
                    // User's traced path
                    guidePath
                        .trim(from: 0, to: progress)
                        .stroke(TraceTheme.driedCharcoal, lineWidth: 4)
                }
                .frame(width: 400, height: 600)
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Simplified progress calculation
                    progress = min(1.0, progress + 0.01)
                    HapticManager.shared.playCelloNote()
                    
                    if progress >= 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onComplete()
                        }
                    }
                }
        )
    }
}

// Phase 3: The Release - Connection with others
struct ReleaseView: View {
    let connectedUsers: Int
    var onComplete: () -> Void
    @State private var lineOffset: CGFloat = 0
    @State private var showText: Bool = false
    
    var body: some View {
        ZStack {
            TraceTheme.unbleachedPaper
                .edgesIgnoringSafeArea(.all)
            
            // Stream of lines from other users
            VStack(spacing: 20) {
                ForEach(0..<10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(TraceTheme.driedCharcoal.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 50...300), height: 3)
                        .offset(x: lineOffset)
                }
            }
            .offset(y: lineOffset)
            .onAppear {
                withAnimation(.linear(duration: 3.0)) {
                    lineOffset = -500
                }
            }
            
            if showText {
                VStack {
                    Spacer()
                    
                    Text("You are in sync with \(connectedUsers) people right now.")
                        .font(TraceTheme.bodyFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .transition(.opacity)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                onComplete()
            }
        }
    }
}
