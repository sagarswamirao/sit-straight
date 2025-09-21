#!/bin/bash

# Sit Straight - Build Script
# This script builds the app for local distribution

set -e

echo "🚀 Building Sit Straight..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null || ! xcodebuild -version &> /dev/null; then
    echo "❌ Xcode is not installed or not properly configured."
    echo ""
    echo "Please install Xcode from the Mac App Store, then run:"
    echo "sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo ""
    echo "Alternatively, you can build the app manually:"
    echo "1. Open SitStraight.xcodeproj in Xcode"
    echo "2. Select 'Any Mac (Designed for Mac)' as destination"
    echo "3. Press ⌘+R to build and run"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild clean -project SitStraight.xcodeproj -scheme SitStraight

# Build for release
echo "🔨 Building for release..."
xcodebuild build \
    -project SitStraight.xcodeproj \
    -scheme SitStraight \
    -configuration Release \
    -derivedDataPath ./DerivedData

# Find the built app
APP_PATH="./DerivedData/Build/Products/Release/SitStraight.app"

if [ -d "$APP_PATH" ]; then
    echo "✅ Build successful!"
    echo "📱 App location: $APP_PATH"

    # Create a distribution folder
    DIST_DIR="./Distribution"
    mkdir -p "$DIST_DIR"

    # Copy the app
    cp -R "$APP_PATH" "$DIST_DIR/"

    echo "📦 App copied to Distribution folder"
    echo "🎉 Ready for distribution!"
    echo ""
    echo "To install:"
    echo "1. Drag SitStraight.app from the Distribution folder to your Applications folder"
    echo "2. The app will automatically register for auto-start on first launch"
    echo ""
    echo "Note: You may need to grant accessibility permissions in System Preferences"
else
    echo "❌ Build failed - app not found at $APP_PATH"
    exit 1
fi
