import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .canvas
    
    enum Tab {
        case gallery
        case canvas
        case settings
    }
    
    var body: some View {
        ZStack {
            if appState.hasCompletedOnboarding {
                // Main app with tab navigation
                ZStack {
                    // Content based on selected tab
                    switch selectedTab {
                    case .gallery:
                        GalleryView()
                    case .canvas:
                        MainCanvasView()
                    case .settings:
                        SettingsView()
                    }
                    
                    // Bottom navigation (minimal)
                    VStack {
                        Spacer()
                        
                        HStack(spacing: 60) {
                            TabButton(icon: "square.grid.2x2", isSelected: selectedTab == .gallery) {
                                withAnimation {
                                    selectedTab = .gallery
                                }
                            }
                            
                            TabButton(icon: "pencil.tip", isSelected: selectedTab == .canvas) {
                                withAnimation {
                                    selectedTab = .canvas
                                }
                            }
                            
                            TabButton(icon: "gearshape", isSelected: selectedTab == .settings) {
                                withAnimation {
                                    selectedTab = .settings
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(TraceTheme.unbleachedPaper.opacity(0.95))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                        )
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    }
                }
                .transition(.opacity)
            } else {
                OnboardingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: appState.hasCompletedOnboarding)
    }
}

struct TabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            HapticManager.shared.playMenuOpen()
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.4))
                .frame(width: 44, height: 44)
        }
    }
}
