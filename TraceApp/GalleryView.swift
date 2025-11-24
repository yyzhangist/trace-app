import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var appState: AppState
    @State private var drawings: [Drawing] = []
    @State private var selectedDrawing: Drawing?
    
    var body: some View {
        ZStack {
            TraceTheme.unbleachedPaper
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Your Journey")
                        .font(TraceTheme.headerFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Day \(appState.streak)")
                            .font(TraceTheme.bodyFont)
                            .foregroundColor(TraceTheme.moss)
                        
                        Text("of Mindfulness")
                            .font(TraceTheme.smallFont)
                            .foregroundColor(TraceTheme.driedCharcoal.opacity(0.6))
                    }
                }
                .padding()
                
                // Timeline of drawings
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        ForEach(drawings) { drawing in
                            DrawingCard(drawing: drawing)
                                .onTapGesture {
                                    selectedDrawing = drawing
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            loadDrawings()
        }
        .sheet(item: $selectedDrawing) { drawing in
            DrawingDetailView(drawing: drawing)
        }
    }
    
    func loadDrawings() {
        drawings = DrawingManager.shared.getDrawingsForLast30Days()
    }
}

struct DrawingCard: View {
    let drawing: Drawing
    
    var body: some View {
        HStack(spacing: 16) {
            // Timeline marker
            VStack {
                Circle()
                    .fill(TraceTheme.moss)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(TraceTheme.moss.opacity(0.3))
                    .frame(width: 2, height: 100)
            }
            
            // Drawing preview
            VStack(alignment: .leading, spacing: 8) {
                Text(drawing.prompt)
                    .font(TraceTheme.smallFont)
                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.6))
                    .lineLimit(2)
                
                // Simplified drawing preview
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 120)
                    .overlay(
                        Canvas { context, size in
                            for stroke in drawing.strokes {
                                var path = Path()
                                
                                if let firstPoint = stroke.points.first {
                                    path.move(to: firstPoint.location)
                                    
                                    for point in stroke.points.dropFirst() {
                                        path.addLine(to: point.location)
                                    }
                                }
                                
                                context.stroke(
                                    path,
                                    with: .color(stroke.color),
                                    lineWidth: 2.0
                                )
                            }
                        }
                        .scaleEffect(0.3)
                    )
                
                Text(formatDate(drawing.date))
                    .font(TraceTheme.smallFont)
                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.4))
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(TraceTheme.morningFog.opacity(0.3))
        )
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct DrawingDetailView: View {
    let drawing: Drawing
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            TraceTheme.unbleachedPaper
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(TraceTheme.driedCharcoal.opacity(0.5))
                    }
                }
                .padding()
                
                // Full size drawing
                Canvas { context, size in
                    for stroke in drawing.strokes {
                        var path = Path()
                        
                        if let firstPoint = stroke.points.first {
                            path.move(to: firstPoint.location)
                            
                            for point in stroke.points.dropFirst() {
                                path.addLine(to: point.location)
                            }
                        }
                        
                        context.stroke(
                            path,
                            with: .color(stroke.color),
                            lineWidth: stroke.points.first?.width ?? 3.0
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding()
                
                // Prompt and date
                VStack(spacing: 12) {
                    Text(drawing.prompt)
                        .font(TraceTheme.bodyFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Text(drawing.date, style: .date)
                        .font(TraceTheme.smallFont)
                        .foregroundColor(TraceTheme.driedCharcoal.opacity(0.5))
                }
                .padding()
                
                Spacer()
            }
        }
    }
}
