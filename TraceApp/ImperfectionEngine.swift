import SwiftUI

struct DrawingPoint: Identifiable {
    let id = UUID()
    var location: CGPoint
    var pressure: CGFloat
    var timestamp: TimeInterval
    var velocity: CGFloat = 0
}

struct RenderPoint: Codable, Equatable {
    var location: CGPoint
    var width: CGFloat
    var opacity: Double
}

class ImperfectionEngine {
    // The Wabi-Sabi Algorithm Configuration
    let baseJitterAmount: CGFloat = 1.5
    let frictionCoefficient: CGFloat = 0.8
    
    var brushType: BrushType = .charcoal
    
    enum BrushType: String, Codable {
        case charcoal = "charcoal"
        case watercolor = "watercolor"
        case pencil = "pencil"
    }
    
    func processStroke(current: DrawingPoint, previous: DrawingPoint) -> RenderPoint {
        // 1. Calculate Velocity
        let distance = hypot(
            current.location.x - previous.location.x,
            current.location.y - previous.location.y
        )
        let timeDelta = max(0.001, current.timestamp - previous.timestamp)
        let velocity = distance / CGFloat(timeDelta)
        
        // 2. Dynamic Ink Logic (Faster = Drier, Slower = Bleeds)
        var inkOpacity = mapValue(velocity, from: 0...500, to: 1.0...0.6)
        var strokeWidth = mapValue(velocity, from: 0...500, to: 4.0...2.0)
        
        // Apply brush-specific modifications
        switch brushType {
        case .charcoal:
            // If velocity is very slow (user is hesitating), simulate ink bleeding
            if velocity < 10 {
                strokeWidth += 0.2
            }
        case .watercolor:
            strokeWidth *= 1.5
            inkOpacity *= 0.8
        case .pencil:
            strokeWidth *= 0.7
        }
        
        // 3. Micro-Jitter Injection (The core of "imperfection")
        let noiseX = CGFloat.random(in: -baseJitterAmount...baseJitterAmount)
        let noiseY = CGFloat.random(in: -baseJitterAmount...baseJitterAmount)
        
        let organicLocation = CGPoint(
            x: current.location.x + noiseX,
            y: current.location.y + noiseY
        )
        
        // 4. Trigger appropriate haptic feedback
        triggerHapticForBrush(velocity: velocity, pressure: current.pressure)
        
        return RenderPoint(
            location: organicLocation,
            width: strokeWidth,
            opacity: inkOpacity
        )
    }
    
    private func mapValue(_ value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let inputRange = from.upperBound - from.lowerBound
        let outputRange = to.upperBound - to.lowerBound
        let normalized = (value - from.lowerBound) / inputRange
        let clamped = min(max(normalized, 0), 1)
        return to.lowerBound + (clamped * outputRange)
    }
    
    private func triggerHapticForBrush(velocity: CGFloat, pressure: CGFloat) {
        switch brushType {
        case .charcoal:
            HapticManager.shared.playCharcoalTexture(velocity: velocity)
        case .watercolor:
            HapticManager.shared.playWatercolorTexture()
        case .pencil:
            HapticManager.shared.playCharcoalTexture(velocity: velocity * 0.5)
        }
    }
}

// Drawing stroke model
struct DrawingStroke: Identifiable {
    let id: UUID
    var points: [RenderPoint]
    var color: Color
    var brushType: ImperfectionEngine.BrushType
    var timestamp: Date
    
    init(id: UUID = UUID(), points: [RenderPoint], color: Color, brushType: ImperfectionEngine.BrushType, timestamp: Date) {
        self.id = id
        self.points = points
        self.color = color
        self.brushType = brushType
        self.timestamp = timestamp
    }
}
