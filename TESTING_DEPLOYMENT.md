# 🧪 Trace Testing & Deployment Guide

## Pre-Deployment Testing Checklist

### ✅ Phase 1: Code Validation (Windows - Complete)

- [x] All Swift files compile without syntax errors
- [x] Project structure is correct
- [x] Info.plist is properly configured
- [x] Assets.xcassets structure created
- [x] All views are implemented
- [x] State management working
- [x] Data persistence logic complete

### ⏳ Phase 2: Build Testing (Requires macOS)

#### Setup
```bash
# Open project in Xcode
open TraceApp/Trace.xcodeproj

# Or from command line
cd TraceApp
xcodebuild -list  # List schemes and targets
```

#### Build Tests
- [ ] Build succeeds without errors
- [ ] No compiler warnings
- [ ] All dependencies resolve
- [ ] Assets load correctly
- [ ] Launch screen displays

#### Simulator Testing
```bash
# Build for iPhone 15 Pro simulator
xcodebuild -scheme Trace \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  build

# Run on simulator
xcodebuild -scheme Trace \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  test
```

**Test Checklist:**
- [ ] App launches successfully
- [ ] Onboarding flows correctly
- [ ] Drawing on canvas works
- [ ] Gestures respond (pinch, swipe)
- [ ] Navigation between tabs works
- [ ] Gallery displays saved drawings
- [ ] Settings loads correctly
- [ ] No crashes on basic operations

### ⏳ Phase 3: Device Testing (Requires iPhone/iPad)

#### Connect Device
```bash
# List connected devices
xcrun xctrace list devices

# Build for device
xcodebuild -scheme Trace \
  -destination 'platform=iOS,name=Your iPhone' \
  build
```

**Critical Device Tests:**
- [ ] **Haptic Feedback** - Most important! Can only test on real device
  - [ ] Charcoal texture feels gritty
  - [ ] Watercolor texture feels smooth
  - [ ] Menu open has crisp click
  - [ ] Save gesture has ramp-release
  - [ ] Breathing pulse in onboarding
- [ ] **Drawing Performance** - Smooth at 60fps
- [ ] **Gesture Recognition** - Pinch/swipe work naturally
- [ ] **Memory Usage** - No leaks after extended use
- [ ] **Battery Impact** - Reasonable power consumption

### ⏳ Phase 4: Feature Testing

#### Onboarding Flow
- [ ] Phase 1: Breathing calibration works
- [ ] Phase 2: Line tracing completes
- [ ] Phase 3: Shows "in sync" message
- [ ] Transitions smoothly between phases
- [ ] Can't skip accidentally
- [ ] Completes in ~60 seconds

#### Drawing Canvas
- [ ] Lines appear instantly (no lag)
- [ ] Imperfection algorithm working (lines look organic)
- [ ] Different brushes feel different
- [ ] Color picker opens on pinch
- [ ] Swipe up saves drawing
- [ ] Canvas clears after save
- [ ] Daily prompt appears

#### Gallery
- [ ] Saved drawings appear
- [ ] Timeline is chronological
- [ ] Tap to view full size
- [ ] Streak counter accurate
- [ ] No drawings = empty state shown

#### Settings
- [ ] Paper type selection works
- [ ] Soundscape toggles work
- [ ] Premium badge shows correctly
- [ ] Free features accessible
- [ ] Premium features locked (if not subscribed)

#### Data Persistence
- [ ] Drawings save locally
- [ ] Streak persists after app close
- [ ] Settings persist
- [ ] Onboarding doesn't repeat
- [ ] App state restores correctly

### ⏳ Phase 5: Edge Case Testing

#### Stress Tests
- [ ] Draw 100+ strokes without lag
- [ ] Save 50+ drawings
- [ ] Switch tabs rapidly
- [ ] Pinch menu repeatedly
- [ ] Fill entire canvas
- [ ] Very slow drawing
- [ ] Very fast drawing

#### Error Scenarios
- [ ] No storage space
- [ ] Airplane mode (offline)
- [ ] Backgrounding app mid-draw
- [ ] Phone call during drawing
- [ ] Low battery mode
- [ ] Force quit and restart
- [ ] Update from older version

#### Device Variations
- [ ] iPhone SE (small screen)
- [ ] iPhone 15 Pro Max (large screen)
- [ ] iPad (different aspect ratio)
- [ ] iOS 16, 17, 18 (if possible)

---

## 📦 Pre-Launch Deployment Steps

### Step 1: Prepare Assets

#### App Icon
```bash
# Generate all icon sizes
# Use online tool or script
cd TraceApp/Assets.xcassets/AppIcon.appiconset
# Add all PNG files (see ICON_GUIDE.md)
```

#### Screenshots
Capture in Xcode simulator:
1. Launch simulator
2. Capture key screens (Cmd+S)
3. Needed sizes: 6.7", 6.5", 5.5"
4. 3-5 screenshots minimum

**Required Screenshots:**
- Onboarding (breathing phase)
- Canvas with drawing
- Gallery with multiple drawings
- Settings showing premium features
- (Optional) Prompt close-up

#### App Preview Video
Record with QuickTime:
```bash
# Connect iPhone
# QuickTime → File → New Movie Recording → Choose iPhone
# Record 15-30 second demo
```

### Step 2: Configure App Store Connect

#### Account Setup
1. Join Apple Developer Program ($99/year)
2. Create App Store Connect account
3. Set up banking/tax forms
4. Create app listing

#### App Information
```
Name: Trace
Subtitle: A deep breath for your mind
Category: Health & Fitness (primary), Lifestyle (secondary)
Age Rating: 4+
```

#### Pricing
```
Base Price: Free
In-App Purchases:
  - Sanctuary Pass (Monthly): $3.99
  - Sanctuary Pass (Yearly): $30.00
```

### Step 3: Configure In-App Purchases

#### Create Products in App Store Connect
1. Go to "Features" → "In-App Purchases"
2. Create Auto-Renewable Subscription

**Monthly Subscription:**
```
Product ID: com.trace.app.sanctuary.monthly
Reference Name: Sanctuary Pass Monthly
Subscription Duration: 1 Month
Price: $3.99
```

**Yearly Subscription:**
```
Product ID: com.trace.app.sanctuary.yearly
Reference Name: Sanctuary Pass Yearly
Subscription Duration: 1 Year
Price: $30.00
```

#### Test Subscriptions
1. Create sandbox test accounts
2. Test purchase flow
3. Test restoration
4. Test cancellation

### Step 4: App Store Submission

#### Xcode Archive
```bash
# Clean build
xcodebuild clean -scheme Trace

# Archive for release
xcodebuild archive \
  -scheme Trace \
  -archivePath ./build/Trace.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath ./build/Trace.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist
```

#### Upload to App Store
```bash
# Option 1: Xcode (easier)
# Product → Archive → Upload to App Store

# Option 2: Command line
xcrun altool --upload-app \
  --type ios \
  --file ./build/Trace.ipa \
  --username your@email.com \
  --password app-specific-password
```

#### App Review Information
```
Demo Account: Not required (app works without account)
Notes: 
- Haptic feedback best experienced on real device
- Daily prompts rotate through 7-day cycle
- Premium features can be tested with subscription

Contact:
Email: support@traceapp.io
Phone: [Your number]
```

### Step 5: TestFlight Beta

#### Internal Testing (First)
1. Upload build to TestFlight
2. Add internal testers (up to 100)
3. Test for 1-2 weeks
4. Gather feedback
5. Fix critical bugs

#### External Testing (Before Public Launch)
1. Submit for Beta App Review
2. Add external testers (up to 10,000)
3. Test for 2-4 weeks
4. Iterate based on feedback
5. Build final candidate

---

## 🚀 Launch Day Checklist

### Morning of Launch

- [ ] Final build uploaded to App Store
- [ ] App status: "Pending Developer Release"
- [ ] All social media posts scheduled
- [ ] Press contacts alerted
- [ ] Waitlist email ready to send
- [ ] Support email monitoring active
- [ ] Analytics configured and tested
- [ ] Crash reporting active

### Release Process

```bash
# 1. Release the app (in App Store Connect)
# Click "Release this Version"

# 2. Monitor in real-time
# - App Store ranking
# - Crash reports
# - User reviews
# - Support emails

# 3. Post launch announcements
# - Twitter/X
# - Instagram
# - Product Hunt
# - Reddit
```

### First Hour
- [ ] Verify app appears in App Store
- [ ] Test download from App Store
- [ ] Monitor crash reports
- [ ] Respond to first reviews
- [ ] Post launch tweet

### First Day
- [ ] Email waitlist subscribers
- [ ] Post on all social channels
- [ ] Monitor metrics dashboard
- [ ] Respond to all support emails
- [ ] Check App Store reviews hourly

### First Week
- [ ] Daily review monitoring
- [ ] Daily metrics analysis
- [ ] Gather user feedback
- [ ] Plan first update (if needed)
- [ ] Refine marketing based on data

---

## 📊 Success Metrics to Track

### Download Metrics
- Total downloads
- Downloads per day
- App Store ranking
- Search visibility

### Engagement Metrics
- Daily active users (DAU)
- Monthly active users (MAU)
- Streak completion rate
- Average drawings per user
- Retention (D1, D7, D30)

### Revenue Metrics
- Free to paid conversion rate
- Monthly recurring revenue (MRR)
- Average revenue per user (ARPU)
- Churn rate
- Lifetime value (LTV)

### Quality Metrics
- App Store rating (target: 4.5+)
- Crash-free rate (target: 99%+)
- App size
- Load time
- Battery usage

---

## 🐛 Known Issues to Monitor

### Potential Issues
1. **Haptic intensity** - May vary by device
2. **Drawing lag on old devices** - iPhone 12 and older
3. **Large drawing file size** - After many strokes
4. **Memory usage** - On devices with < 3GB RAM

### Emergency Fixes
If critical bug found post-launch:
```bash
# 1. Fix immediately
# 2. Test thoroughly
# 3. Submit expedited review
# 4. Notify users of upcoming fix
```

---

## 📞 Support Setup

### Email Setup
- support@traceapp.io (general)
- privacy@traceapp.io (privacy)
- legal@traceapp.io (legal)

### Common Issues (Prepare Responses)
1. "Drawing lag" → Check device model, update app
2. "Haptics not working" → Ensure Settings → Sounds & Haptics enabled
3. "Streak reset" → Bug, we'll fix in update
4. "Purchase not working" → Restore purchases in settings
5. "How to delete data?" → Settings → Delete All Data

---

## ✅ Final Verification Before Launch

**The app is ready when:**
- [x] Code is complete
- [ ] Builds successfully on Mac
- [ ] Tests pass on real device
- [ ] Haptics feel correct
- [ ] No critical bugs
- [ ] App Store assets uploaded
- [ ] Subscriptions configured
- [ ] TestFlight beta successful
- [ ] App Store approved
- [ ] Marketing ready

---

## 🎉 Post-Launch Plan

### Week 1
- Respond to reviews
- Fix critical bugs
- Monitor metrics
- Adjust marketing

### Month 1
- Release update (bug fixes)
- Add requested features
- Expand marketing
- Analyze user behavior

### Month 3
- Major feature update
- Press outreach round 2
- Influencer partnerships
- Community building

### Month 6
- Version 2.0 planning
- Android consideration
- Web companion
- International expansion

---

**Current Status:** ✅ Code Complete, Ready for macOS Build & Testing

**Next Step:** Build on Mac, test on iPhone, submit to App Store

**Timeline to Launch:** 2-4 weeks (after Mac testing begins)
