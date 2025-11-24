import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPaperType: PaperType = .standard
    @State private var selectedSoundscape: Soundscape = .silence
    @State private var soundVolume: Double = 0.5
    
    enum PaperType: String, CaseIterable {
        case standard = "Standard Sketchbook"
        case watercolor = "Rough Watercolor Paper"
        case washi = "Japanese Washi"
        case napkin = "Crumpled Napkin"
        case slate = "Slate Blackboard"
        
        var isPremium: Bool {
            self != .standard
        }
    }
    
    enum Soundscape: String, CaseIterable {
        case silence = "Silence"
        case rain = "Rain on Studio Roof"
        case fireplace = "Fireplace"
        case cafe = "Busy Cafe"
        case forest = "Forest Wind"
        
        var isPremium: Bool {
            self != .silence
        }
    }
    
    var body: some View {
        ZStack {
            TraceTheme.unbleachedPaper
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Header
                    Text("The Sanctuary")
                        .font(TraceTheme.headerFont)
                        .foregroundColor(TraceTheme.driedCharcoal)
                        .padding(.top, 40)
                    
                    // Paper Type Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Paper Type")
                            .font(TraceTheme.bodyFont)
                            .foregroundColor(TraceTheme.driedCharcoal)
                        
                        ForEach(PaperType.allCases, id: \.self) { paperType in
                            PaperTypeButton(
                                paperType: paperType,
                                isSelected: selectedPaperType == paperType,
                                isPremium: paperType.isPremium,
                                hasAccess: appState.isPremium || !paperType.isPremium
                            ) {
                                if appState.isPremium || !paperType.isPremium {
                                    selectedPaperType = paperType
                                    HapticManager.shared.playMenuOpen()
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .background(TraceTheme.driedCharcoal.opacity(0.2))
                    
                    // Soundscape Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ambient Soundscape")
                            .font(TraceTheme.bodyFont)
                            .foregroundColor(TraceTheme.driedCharcoal)
                        
                        ForEach(Soundscape.allCases, id: \.self) { soundscape in
                            SoundscapeButton(
                                soundscape: soundscape,
                                isSelected: selectedSoundscape == soundscape,
                                isPremium: soundscape.isPremium,
                                hasAccess: appState.isPremium || !soundscape.isPremium
                            ) {
                                if appState.isPremium || !soundscape.isPremium {
                                    selectedSoundscape = soundscape
                                    HapticManager.shared.playMenuOpen()
                                }
                            }
                        }
                        
                        if selectedSoundscape != .silence {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Volume")
                                    .font(TraceTheme.smallFont)
                                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.6))
                                
                                Slider(value: $soundVolume, in: 0...1)
                                    .accentColor(TraceTheme.moss)
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    Divider()
                        .background(TraceTheme.driedCharcoal.opacity(0.2))
                    
                    // Premium Section
                    if !appState.isPremium {
                        VStack(spacing: 20) {
                            // Golden badge
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "#DAA520"),
                                                Color(hex: "#B8860B")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Become a Patron")
                                .font(TraceTheme.headerFont)
                                .foregroundColor(TraceTheme.driedCharcoal)
                            
                            Text("Unlock premium textures, ambient soundscapes, and cloud archive.")
                                .font(TraceTheme.bodyFont)
                                .foregroundColor(TraceTheme.driedCharcoal.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                PricingCard(
                                    title: "Monthly",
                                    price: "$3.99",
                                    period: "/month"
                                )
                                
                                PricingCard(
                                    title: "Yearly",
                                    price: "$30",
                                    period: "/year",
                                    isRecommended: true
                                )
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                // Handle subscription
                                appState.isPremium = true
                                appState.saveUserPreferences()
                            }) {
                                Text("Start Free Trial")
                                    .font(TraceTheme.bodyFont)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(TraceTheme.moss)
                                    )
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(TraceTheme.morningFog.opacity(0.5))
                        )
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 50))
                                .foregroundColor(TraceTheme.moss)
                            
                            Text("Sanctuary Pass Active")
                                .font(TraceTheme.bodyFont)
                                .foregroundColor(TraceTheme.driedCharcoal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    
                    Spacer()
                        .frame(height: 60)
                }
                .padding()
            }
        }
    }
}

struct PaperTypeButton: View {
    let paperType: SettingsView.PaperType
    let isSelected: Bool
    let isPremium: Bool
    let hasAccess: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(paperType.rawValue)
                        .font(TraceTheme.bodyFont)
                        .foregroundColor(hasAccess ? TraceTheme.driedCharcoal : TraceTheme.driedCharcoal.opacity(0.4))
                    
                    if isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                            Text("Premium")
                                .font(TraceTheme.smallFont)
                        }
                        .foregroundColor(Color(hex: "#DAA520"))
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(TraceTheme.moss)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? TraceTheme.moss.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .disabled(!hasAccess)
    }
}

struct SoundscapeButton: View {
    let soundscape: SettingsView.Soundscape
    let isSelected: Bool
    let isPremium: Bool
    let hasAccess: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(soundscape.rawValue)
                        .font(TraceTheme.bodyFont)
                        .foregroundColor(hasAccess ? TraceTheme.driedCharcoal : TraceTheme.driedCharcoal.opacity(0.4))
                    
                    if isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                            Text("Premium")
                                .font(TraceTheme.smallFont)
                        }
                        .foregroundColor(Color(hex: "#DAA520"))
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(TraceTheme.moss)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? TraceTheme.moss.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .disabled(!hasAccess)
    }
}

struct PricingCard: View {
    let title: String
    let price: String
    let period: String
    var isRecommended: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            if isRecommended {
                Text("Best Value")
                    .font(TraceTheme.smallFont)
                    .foregroundColor(TraceTheme.moss)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(TraceTheme.moss.opacity(0.2))
                    )
            }
            
            Text(title)
                .font(TraceTheme.bodyFont)
                .foregroundColor(TraceTheme.driedCharcoal)
            
            HStack(alignment: .top, spacing: 2) {
                Text(price)
                    .font(TraceTheme.headerFont)
                    .foregroundColor(TraceTheme.driedCharcoal)
                
                Text(period)
                    .font(TraceTheme.smallFont)
                    .foregroundColor(TraceTheme.driedCharcoal.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isRecommended ? TraceTheme.moss : TraceTheme.driedCharcoal.opacity(0.2), lineWidth: isRecommended ? 2 : 1)
                )
        )
    }
}
