import CoreHaptics
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private var hapticEngine: CHHapticEngine?
    
    init() {
        prepareHaptics()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device doesn't support haptics")
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            
            // Reset engine if stopped
            hapticEngine?.resetHandler = {
                do {
                    try self.hapticEngine?.start()
                } catch {
                    print("Failed to restart engine: \(error)")
                }
            }
        } catch {
            print("Haptic engine creation failed: \(error)")
        }
    }
    
    // Breathing pulse for onboarding calibration
    func playBreathingPulse() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 0.5
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error)")
        }
    }
    
    // Cello note for tracing
    func playCelloNote() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred(intensity: 0.7)
    }
    
    // Charcoal texture - dry, gritty
    func playCharcoalTexture(velocity: CGFloat) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let sharpness = Float(min(0.8, 0.5 + velocity / 1000))
        let intensity = Float(min(1.0, 0.4 + velocity / 1000))
        
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [sharpnessParam, intensityParam],
            relativeTime: 0
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play charcoal haptic: \(error)")
        }
    }
    
    // Watercolor texture - smooth, flowing
    func playWatercolorTexture() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 0.1
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play watercolor haptic: \(error)")
        }
    }
    
    // Menu open - crisp click
    func playMenuOpen() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // Save/Release - ramp up then release
    func playSaveRelease() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let rampUp = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0.2)
        let peak = CHHapticParameterCurve.ControlPoint(relativeTime: 0.3, value: 0.9)
        let release = CHHapticParameterCurve.ControlPoint(relativeTime: 0.4, value: 0)
        
        let curve = CHHapticParameterCurve(
            parameterID: .hapticIntensityControl,
            controlPoints: [rampUp, peak, release],
            relativeTime: 0
        )
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0,
            duration: 0.5
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [curve])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play save/release haptic: \(error)")
        }
    }
}
