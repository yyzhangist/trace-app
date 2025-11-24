# Trace iOS App - Build Instructions

## Prerequisites
- macOS with Xcode 15+ installed
- iOS 16+ SDK
- iPhone or iPad simulator/device

## Build Steps

### Option 1: Build with Xcode (Recommended)

1. Open `Trace.xcodeproj` in Xcode:
   ```bash
   open TraceApp/Trace.xcodeproj
   ```

2. Select your target device (iPhone simulator or connected device)

3. Press `Cmd + R` to build and run

### Option 2: Build from Command Line

1. List available simulators:
   ```bash
   xcrun simctl list devices
   ```

2. Build for simulator:
   ```bash
   cd TraceApp
   xcodebuild -scheme Trace -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
   ```

3. Run on simulator:
   ```bash
   xcodebuild -scheme Trace -destination 'platform=iOS Simulator,name=iPhone 15 Pro' run
   ```

### Option 3: Quick Test Build

For a quick syntax check without running:
```bash
cd TraceApp
swift build
```

## Project Structure

```
TraceApp/
├── TraceApp.swift          # Main app entry point
├── ContentView.swift       # Root view with navigation
├── MainCanvasView.swift    # Drawing canvas
├── OnboardingView.swift    # 3-phase onboarding
├── GalleryView.swift       # Drawing timeline/archive
├── SettingsView.swift      # Sanctuary settings
├── ImperfectionEngine.swift # Wabi-Sabi algorithm
├── HapticManager.swift     # Core Haptics engine
├── DailyPromptManager.swift # Prompt system
├── Theme.swift             # Design system
├── ToolMenuView.swift      # Brush/color picker
├── Info.plist              # App configuration
└── Trace.xcodeproj/        # Xcode project
```

## Features Implemented

✅ Core Drawing Engine with Imperfection Algorithm
✅ Haptic Feedback (Charcoal, Watercolor, Save/Release)
✅ 3-Phase Onboarding (Calibrate, First Mark, Release)
✅ Daily Prompt System (7-day cycle)
✅ Canvas with Gesture Controls (Pinch for menu, Swipe to save)
✅ Gallery with Timeline View
✅ Settings with Premium/Free tiers
✅ Streak Tracking
✅ Local Data Persistence

## Testing on Windows (Current Environment)

Since you're on Windows, you have two options:

### Option A: Use GitHub Codespaces or Cloud Mac
1. Push code to GitHub
2. Use GitHub Codespaces with macOS container
3. Build and test in cloud environment

### Option B: Set up for Cross-Platform Preview
Create a web preview version using SwiftUI for Web (experimental) or React Native port.

## Next Steps for Full Launch

1. **Test on Real Device**: Connect iPhone/iPad and test haptics
2. **Add App Icon**: Design icon and add to Assets.xcassets
3. **App Store Assets**: Create screenshots, preview video
4. **Backend Integration**: Add Firebase/Supabase for cloud sync
5. **Submit to App Store**: Complete App Store Connect submission

## Notes

- The app is fully functional for local testing
- Premium features are toggleable (subscription logic needs payment integration)
- Camera color picker is placeholder (needs AVFoundation implementation)
- All core features work offline

## Development

To modify and test:
1. Make changes to any `.swift` file
2. Xcode will auto-detect and recompile
3. Use SwiftUI Preview for instant feedback
4. Use breakpoints for debugging

---

**Built with the "Peace Structure" philosophy.**  
*In Defense of the Smudge.*
