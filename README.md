# Trace 🎨

> A mindfulness drawing app that embraces imperfection

[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Build Status](https://github.com/yyzhangist/trace-app/actions/workflows/ios-build.yml/badge.svg)](https://github.com/yyzhangist/trace-app/actions)

## What is Trace?

Trace is a daily creative mindfulness app that transforms your phone into a digital sanctuary. Instead of doom-scrolling, spend 3 minutes creating something uniquely yours—no artistic skills required.

**The Philosophy:** In a world of AI-generated perfection, the most valuable thing is human imperfection. Trace celebrates the shake, the hesitation, and the mistake.

## Features ✨

- **Imperfection Engine**: Custom rendering algorithm that makes every stroke feel organic and intentional
- **Haptic Feedback**: Feel the texture of charcoal, watercolor, and ink through sophisticated haptic patterns
- **Daily Prompts**: Gentle creative nudges like "Draw the shape of your breath" or "Draw the noise of the train"
- **No Social Pressure**: No likes, no followers—just you and your creativity
- **Multiple Brush Types**: Charcoal, watercolor, ink, and more with realistic physics
- **Gallery Timeline**: Visual diary of your creative journey with streak tracking
- **Dark Mode**: Seamless light and dark theme support

## Screenshots

<!-- Add screenshots here when available -->

## Why Trace?

### The Problem
You're stressed at work or bored on the bus. You scroll social media and feel worse.

### The Solution
Open Trace. Draw a single line. Capture a color from the sky. Feel better.

Trace is not about making "good" art—it's about the act of making. It's a 3-minute micro-flow state for your daily routine.

## Technical Highlights 🛠️

- **SwiftUI**: Modern declarative UI framework
- **Metal Shaders**: Custom GPU-accelerated rendering for realistic brush physics
- **Core Haptics**: Sophisticated haptic feedback system that simulates physical textures
- **Wabi-Sabi Algorithm**: Velocity-based stroke dynamics with micro-jitter injection
- **Persistent Storage**: Local drawing archive with JSON serialization

## Architecture

```
Trace/
├── TraceApp.swift          # App entry point
├── Models/
│   ├── ImperfectionEngine.swift    # Core rendering algorithm
│   ├── DailyPromptManager.swift    # Prompt rotation system
│   └── Theme.swift                  # Color and styling
├── Views/
│   ├── MainCanvasView.swift        # Primary drawing canvas
│   ├── OnboardingView.swift        # First-time user experience
│   ├── GalleryView.swift           # Drawing archive
│   ├── SettingsView.swift          # App configuration
│   └── ToolMenuView.swift          # Brush/color selection
└── Utilities/
    └── HapticManager.swift         # Haptic feedback engine
```

## Getting Started 🚀

### Prerequisites

- Xcode 15.2+
- iOS 16.0+
- Swift 5.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/yyzhangist/trace-app.git

# Open in Xcode
cd trace-app
open Trace.xcodeproj

# Build and run
# Select your target device/simulator and press Cmd+R
```

### Running Tests

```bash
# Run tests via Xcode
# Press Cmd+U

# Or via command line
xcodebuild test -scheme Trace -destination 'platform=iOS Simulator,name=iPhone 15'
```

## The Imperfection Engine 🎨

The heart of Trace is our custom rendering algorithm that makes digital drawing feel physical:

```swift
// Velocity-based dynamics
let velocity = distance / timeDelta
var inkOpacity = map(velocity, 0...500 → 1.0...0.6)
var strokeWidth = map(velocity, 0...500 → 4.0...2.0)

// Micro-jitter injection (0.5% variance)
let noiseX = Random.float(-baseJitter...baseJitter)
let organicLocation = CGPoint(x: x + noiseX, y: y + noiseY)

// Haptic feedback matching brush texture
triggerHaptic(sharpness: velocityMap, intensity: pressure)
```

This creates strokes that look intentionally organic, never machine-perfect.

## Design Philosophy 🌿

**Digital Wabi-Sabi**

- Unbleached paper background (`#F2F0E9`)
- Dried charcoal ink (`#2C2C2C`)
- 3% grain overlay for matte texture
- Disappearing UI—interface is invisible until needed
- No toolbars, no clutter—just canvas

## Roadmap 🗺️

- [ ] **v1.0** - Core drawing experience (✅ Completed)
- [ ] **v1.1** - Cloud sync and cross-device support
- [ ] **v1.2** - Export to high-res images/videos
- [ ] **v1.3** - Premium textures (washi paper, slate, napkin)
- [ ] **v2.0** - AR location-based sketch sharing
- [ ] **v2.1** - Ambient generative music based on drawing speed

## Contributing 🤝

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting PRs.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 🙏

- Inspired by Japanese Wabi-Sabi philosophy
- Built with love for people who think they "can't draw"
- Special thanks to the SwiftUI and Core Haptics communities

## Contact 📧

Project Link: [https://github.com/yyzhangist/trace-app](https://github.com/yyzhangist/trace-app)

---

**"In Defense of the Smudge"**

*The world is becoming perfect. Cars drive themselves. AI writes our emails. Everything is optimized. Everything is sleek. Everything is correct.*

*Trace is here to be incorrect.*

*We believe the most valuable thing left in the digital age is the Human Hand. The shake. The hesitation. The pressure. The mistake.*

*No likes. No filters. No perfection.*

*Just you, the glass, and the grain.*

**Trace.**
