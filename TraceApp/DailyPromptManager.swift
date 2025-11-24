import Foundation
import SwiftUI

class DailyPromptManager {
    static let shared = DailyPromptManager()
    
    private let prompts: [String] = [
        "Draw the shape of your breath right now.",
        "Close your eyes. Draw the loudest sound you hear.",
        "If 'calm' was a texture, what would it feel like?",
        "Your favorite object from childhood. Simplified into three lines.",
        "Draw a circle with your non-dominant hand.",
        "Open the camera. Capture the loneliest color in the room.",
        "Fill the screen until the paper disappears."
    ]
    
    func getPrompt(for day: Int) -> String {
        let index = (day - 1) % prompts.count
        return prompts[index]
    }
    
    func getTodayPrompt() -> String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return getPrompt(for: dayOfYear % 7 + 1)
    }
}

// Drawing data model
struct Drawing: Identifiable, Codable {
    let id: UUID
    let strokes: [DrawingStroke]
    let date: Date
    let prompt: String
}

// Make DrawingStroke Codable
extension DrawingStroke: Codable {
    enum CodingKeys: String, CodingKey {
        case id, points, color, brushType, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        points = try container.decode([RenderPoint].self, forKey: .points)
        
        let colorHex = try container.decode(String.self, forKey: .color)
        color = Color(hex: colorHex)
        
        let brushString = try container.decode(String.self, forKey: .brushType)
        brushType = ImperfectionEngine.BrushType(rawValue: brushString) ?? .charcoal
        
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(points, forKey: .points)
        try container.encode("#2C2C2C", forKey: .color) // Simplified
        try container.encode(brushType.rawValue, forKey: .brushType)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

extension ImperfectionEngine.BrushType: Codable {
    var rawValue: String {
        switch self {
        case .charcoal: return "charcoal"
        case .watercolor: return "watercolor"
        case .pencil: return "pencil"
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case "charcoal": self = .charcoal
        case "watercolor": self = .watercolor
        case "pencil": self = .pencil
        default: return nil
        }
    }
}

extension RenderPoint: Codable {}

// Drawing Manager for persistence
class DrawingManager {
    static let shared = DrawingManager()
    
    private let userDefaults = UserDefaults.standard
    private let drawingsKey = "saved_drawings"
    
    func saveDrawing(_ drawing: Drawing) {
        var drawings = getAllDrawings()
        drawings.append(drawing)
        
        if let encoded = try? JSONEncoder().encode(drawings) {
            userDefaults.set(encoded, forKey: drawingsKey)
        }
    }
    
    func getAllDrawings() -> [Drawing] {
        guard let data = userDefaults.data(forKey: drawingsKey),
              let drawings = try? JSONDecoder().decode([Drawing].self, from: data) else {
            return []
        }
        return drawings
    }
    
    func getDrawingsForLast30Days() -> [Drawing] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return getAllDrawings().filter { $0.date >= thirtyDaysAgo }
    }
}
