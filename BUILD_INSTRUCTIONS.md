# 🚀 Sit Straight - Build Instructions

## Quick Start

### Option 1: Interactive Build & Install (Recommended)
```bash
./build-and-install.sh
```
This script will:
- Build the app
- Remove security quarantine
- Give you installation options
- Handle everything automatically

### Option 2: Local Build Only
```bash
./build-local.sh
```
This builds for your Mac's architecture and creates a Distribution folder.

### Option 3: GitHub Actions (Remote Build)
1. Push to GitHub
2. Download artifact from Actions tab
3. Extract and install

## Installation Options

### After Building Locally:

1. **Install to Applications folder:**
   ```bash
   sudo cp -R dist/SitStraight.app /Applications/
   ```

2. **Install to user Applications:**
   ```bash
   cp -R dist/SitStraight.app ~/Applications/
   ```

3. **Run directly:**
   ```bash
   open dist/SitStraight.app
   ```

## Security Warnings

If you get "Apple could not verify..." warning:

1. **Right-click** the app → **Open** → **Open**
2. Or run: `xattr -d com.apple.quarantine SitStraight.app`

## What the Scripts Do

### `build-and-install.sh`
- ✅ Checks for Xcode
- ✅ Builds the app
- ✅ Removes quarantine attribute
- ✅ Provides interactive installation options
- ✅ Handles all the manual steps we did

### `build-local.sh`
- ✅ Builds for your Mac's architecture
- ✅ Creates Distribution folder
- ✅ Removes quarantine
- ✅ Shows installation instructions

### GitHub Actions
- ✅ Builds universal binary (Intel + Apple Silicon)
- ✅ Removes quarantine
- ✅ Creates downloadable artifact
- ✅ Includes installation instructions

## Troubleshooting

### "Xcode not found"
```bash
# Install Xcode from App Store, then:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### "App not supported"
- Make sure you're using the universal binary
- Check macOS version compatibility (12.0+)

### "Security warning"
- Right-click app → Open → Open
- Or remove quarantine: `xattr -d com.apple.quarantine app.app`

## Features

- 🎯 Menu bar app (no dock icon)
- ⏰ Customizable reminder intervals
- 🎨 Full-screen animated overlay
- 🔊 Audio reminders
- 🚀 Auto-start on login
- 📱 Universal binary (Intel + Apple Silicon)
- 🔒 No code signing required for local use
