import SwiftUI

struct MainCanvasView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var canvasViewModel = CanvasViewModel()
    @State private var showToolMenu: Bool = false
    @State private var showPrompt: Bool = true
    
    var body: some View {
        ZStack {
            // Canvas Background with grain texture
            TraceTheme.unbleachedPaper
                .overlay(
                    // Grain overlay (3% noise)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .opacity(0.03)
                        .blendMode(.multiply)
                )
                .edgesIgnoringSafeArea(.all)
            
            // Drawing Canvas
            CanvasDrawingView(viewModel: canvasViewModel)
            
            // Daily Prompt (top center, fades out when drawing starts)
            if showPrompt && canvasViewModel.strokes.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showPrompt = false
                            }
                        }) {
                            VStack(spacing: 8) {
                                // Breathing light dot
                                Circle()
                                    .fill(TraceTheme.moss.opacity(0.6))
                                    .frame(width: 12, height: 12)
                                    .scaleEffect(showPrompt ? 1.2 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 2.0)
                                            .repeatForever(autoreverses: true),
                                        value: showPrompt
                                    )
                                
                                Text(DailyPromptManager.shared.getPrompt(for: appState.currentDay))
                                    .font(TraceTheme.smallFont)
                                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: 200)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(TraceTheme.morningFog.opacity(0.5))
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                }
                .transition(.opacity)
            }
            
            // Tool Menu (appears on pinch gesture)
            if showToolMenu {
                ToolMenuView(
                    selectedColor: $canvasViewModel.currentColor,
                    selectedBrush: $canvasViewModel.currentBrush,
                    onDismiss: {
                        withAnimation {
                            showToolMenu = false
                        }
                        HapticManager.shared.playMenuOpen()
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .gesture(
            MagnificationGesture()
                .onEnded { _ in
                    withAnimation(.spring()) {
                        showToolMenu.toggle()
                    }
                    HapticManager.shared.playMenuOpen()
                }
        )
        .gesture(
            DragGesture(minimumDistance: 100, coordinateSpace: .global)
                .onEnded { value in
                    // Swipe up to save
                    if value.translation.height < -100 {
                        saveDrawing()
                    }
                }
        )
    }
    
    func saveDrawing() {
        guard !canvasViewModel.strokes.isEmpty else { return }
        
        HapticManager.shared.playSaveRelease()
        
        // Save drawing
        let drawing = Drawing(
            id: UUID(),
            strokes: canvasViewModel.strokes,
            date: Date(),
            prompt: DailyPromptManager.shared.getPrompt(for: appState.currentDay)
        )
        
        DrawingManager.shared.saveDrawing(drawing)
        
        // Update streak
        appState.streak += 1
        appState.currentDay = (appState.currentDay % 7) + 1
        appState.saveUserPreferences()
        
        // Clear canvas with animation
        withAnimation(.easeOut(duration: 0.5)) {
            canvasViewModel.strokes.removeAll()
            showPrompt = true
        }
    }
}

// Canvas Drawing View with gesture handling
struct CanvasDrawingView: View {
    @ObservedObject var viewModel: CanvasViewModel
    
    var body: some View {
        Canvas { context, size in
            for stroke in viewModel.strokes {
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
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    viewModel.addPoint(
                        location: value.location,
                        pressure: 1.0,
                        timestamp: Date().timeIntervalSince1970
                    )
                }
                .onEnded { _ in
                    viewModel.finishStroke()
                }
        )
    }
}

// Canvas View Model
class CanvasViewModel: ObservableObject {
    @Published var strokes: [DrawingStroke] = []
    @Published var currentColor: Color = TraceTheme.driedCharcoal
    @Published var currentBrush: ImperfectionEngine.BrushType = .charcoal
    
    private var currentStrokePoints: [DrawingPoint] = []
    private var renderedPoints: [RenderPoint] = []
    private let engine = ImperfectionEngine()
    
    func addPoint(location: CGPoint, pressure: CGFloat, timestamp: TimeInterval) {
        let point = DrawingPoint(
            location: location,
            pressure: pressure,
            timestamp: timestamp
        )
        
        currentStrokePoints.append(point)
        
        // Process through imperfection engine
        if currentStrokePoints.count > 1 {
            let previous = currentStrokePoints[currentStrokePoints.count - 2]
            engine.brushType = currentBrush
            let renderPoint = engine.processStroke(current: point, previous: previous)
            renderedPoints.append(renderPoint)
            
            // Update current stroke
            if !strokes.isEmpty {
                strokes[strokes.count - 1].points = renderedPoints
            } else {
                let newStroke = DrawingStroke(
                    points: renderedPoints,
                    color: currentColor,
                    brushType: currentBrush,
                    timestamp: Date()
                )
                strokes.append(newStroke)
            }
            }
        } else {
            // First point
            let renderPoint = RenderPoint(
                location: location,
                width: 3.0,
                opacity: 1.0
            )
            renderedPoints.append(renderPoint)
            
            let newStroke = DrawingStroke(
                points: renderedPoints,
                color: currentColor,
                brushType: currentBrush,
                timestamp: Date()
            )
            strokes.append(newStroke)
        }
    }
    
    func finishStroke() {
        currentStrokePoints.removeAll()
        renderedPoints.removeAll()
    }
}
