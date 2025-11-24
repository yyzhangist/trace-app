import SwiftUI

// The "Digital Wabi-Sabi" Design System
struct TraceTheme {
    // Color Palette
    static let unbleachedPaper = Color(hex: "#F2F0E9")
    static let morningFog = Color(hex: "#D8DCD6")
    static let driedCharcoal = Color(hex: "#2C2C2C")
    static let moss = Color(hex: "#7A8B72")
    
    // Typography
    static let headerFont = Font.custom("Caslon", size: 28).weight(.regular)
    static let bodyFont = Font.custom("Inter", size: 16).weight(.light)
    static let smallFont = Font.custom("Inter", size: 12).weight(.light)
}

// Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
