import SwiftUI

struct ToolMenuView: View {
    @Binding var selectedColor: Color
    @Binding var selectedBrush: ImperfectionEngine.BrushType
    var onDismiss: () -> Void
    
    @State private var showColorPicker: Bool = false
    
    let brushes: [ImperfectionEngine.BrushType] = [.charcoal, .watercolor, .pencil]
    let presetColors: [Color] = [
        TraceTheme.driedCharcoal,
        Color(hex: "#8B4513"), // Brown
        Color(hex: "#DC143C"), // Crimson
        Color(hex: "#4169E1"), // Royal Blue
        TraceTheme.moss,
        Color(hex: "#DAA520")  // Goldenrod
    ]
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onDismiss()
                }
            
            // Circular floating menu
            VStack(spacing: 40) {
                // Brush Selection
                VStack(spacing: 16) {
                    Text("Brush")
                        .font(TraceTheme.smallFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                    
                    HStack(spacing: 20) {
                        ForEach(brushes, id: \.self) { brush in
                            BrushButton(
                                brush: brush,
                                isSelected: selectedBrush == brush,
                                action: {
                                    selectedBrush = brush
                                    HapticManager.shared.playMenuOpen()
                                }
                            )
                        }
                    }
                }
                
                // Color Selection
                VStack(spacing: 16) {
                    Text("Color")
                        .font(TraceTheme.smallFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(presetColors, id: \.self) { color in
                            ColorButton(
                                color: color,
                                isSelected: selectedColor == color,
                                action: {
                                    selectedColor = color
                                    HapticManager.shared.playMenuOpen()
                                }
                            )
                        }
                        
                        // Camera color picker
                        Button(action: {
                            showColorPicker = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(TraceTheme.morningFog)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "camera.fill")
                                    .foregroundColor(TraceTheme.driedCharcoal)
                            }
                        }
                    }
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(TraceTheme.unbleachedPaper)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerView(selectedColor: $selectedColor)
        }
    }
}

struct BrushButton: View {
    let brush: ImperfectionEngine.BrushType
    let isSelected: Bool
    let action: () -> Void
    
    var brushName: String {
        switch brush {
        case .charcoal: return "Charcoal"
        case .watercolor: return "Watercolor"
        case .pencil: return "Pencil"
        }
    }
    
    var brushIcon: String {
        switch brush {
        case .charcoal: return "pencil.tip"
        case .watercolor: return "paintbrush.fill"
        case .pencil: return "pencil"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: brushIcon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.5))
                
                Text(brushName)
                    .font(TraceTheme.smallFont)
                    .foregroundColor(isSelected ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.5))
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? TraceTheme.moss.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? TraceTheme.moss : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(isSelected ? TraceTheme.moss : Color.clear, lineWidth: 3)
                )
        }
    }
}

// Simple color picker view
struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Capture a color from your world")
                .font(TraceTheme.bodyFont)
                .padding()
            
            // Placeholder for camera view
            Rectangle()
                .fill(TraceTheme.morningFog)
                .overlay(
                    Image(systemName: "camera")
                        .font(.system(size: 60))
                        .foregroundColor(TraceTheme.driedCharcoal.opacity(0.3))
                )
            
            Button("Done") {
                dismiss()
            }
            .font(TraceTheme.bodyFont)
            .padding()
        }
        .background(TraceTheme.unbleachedPaper)
    }
}
