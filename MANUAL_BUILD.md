# Manual Build Instructions

Since you don't have Xcode installed, here are the steps to build the Sit Straight app:

## Option 1: Install Xcode (Recommended)

1. **Download Xcode** from the Mac App Store (free)
2. **Open Xcode** and accept the license agreement
3. **Set Xcode as developer directory:**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```
4. **Build the app:**
   ```bash
   ./build.sh
   ```

## Option 2: Build in Xcode GUI

1. **Install Xcode** from the Mac App Store
2. **Open** `SitStraight.xcodeproj` in Xcode
3. **Select target:** "SitStraight" and destination "Any Mac (Designed for Mac)"
4. **Build:** Press ⌘+R to build and run, or ⌘+Shift+B to build only
5. **Find built app:** Look in the DerivedData folder or use Product > Archive

## Option 3: Alternative Build Methods

### Using GitHub Actions (if you push to GitHub)
Create `.github/workflows/build.yml`:
```yaml
name: Build Sit Straight
on: [push]
jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    - name: Build
      run: |
        xcodebuild -project SitStraight.xcodeproj -scheme SitStraight -configuration Release build
    - name: Upload Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: SitStraight.app
        path: DerivedData/Build/Products/Release/SitStraight.app
```

### Using Xcode Cloud
1. Push code to GitHub
2. Connect repository to Xcode Cloud
3. Build will run automatically

## What You Get

After building, you'll have:
- `SitStraight.app` - Ready to drag to Applications folder
- Auto-start registration on first launch
- Full menu bar functionality
- Beautiful reminder animations

## Troubleshooting

**If you get permission errors:**
```bash
sudo xcode-select --reset
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**If the app doesn't start automatically:**
- Check System Preferences > Users & Groups > Login Items
- Make sure "Sit Straight" is listed and enabled

**If overlay doesn't appear:**
- Check System Preferences > Security & Privacy > Privacy > Accessibility
- Make sure "Sit Straight" is enabled
