# GitHub Actions CI/CD

This directory contains automated workflows for building and testing the Trace iOS app.

## Workflows

### `ios-build.yml`
Automatically builds the iOS app on every push to verify:
- ✅ Code compiles without errors
- ✅ No syntax issues
- ✅ Dependencies resolve correctly
- ✅ Project configuration is valid

**Runs on:** macOS runner with Xcode 15.2
**Triggers:** Push to main/develop, pull requests, manual dispatch

## How to Use

1. **Push your code to GitHub:**
   ```powershell
   git init
   git add .
   git commit -m "Initial Trace app commit"
   git remote add origin https://github.com/YOUR_USERNAME/trace-app.git
   git push -u origin main
   ```

2. **Watch the build:**
   - Go to your GitHub repository
   - Click "Actions" tab
   - See build progress in real-time
   - Get notified if build fails

3. **Manual trigger:**
   - Go to Actions tab
   - Select "iOS Build & Test" workflow
   - Click "Run workflow"

## Benefits

- ✅ **Free macOS testing** (2,000 minutes/month on GitHub Free)
- ✅ **Automatic validation** on every code change
- ✅ **No Mac required** to verify code compiles
- ✅ **Build logs** show exact errors to fix
- ✅ **CI/CD ready** for future automation

## What It Tests

- Code compilation (all Swift files)
- Xcode project configuration
- Missing imports/dependencies
- Syntax errors across all files
- iOS SDK compatibility

## What It Doesn't Test

- ❌ Haptic feedback (needs real device)
- ❌ Drawing performance (needs simulator/device)
- ❌ User interaction (needs manual testing)
- ❌ App Store submission (needs paid Apple Developer account)

These require physical testing on Mac/iPhone.
