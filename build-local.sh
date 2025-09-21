#!/bin/bash

# Sit Straight - Local Build Script for Apple Silicon
# This script builds specifically for your Mac's architecture

set -e

echo "🚀 Building Sit Straight for local Mac..."

# Check architecture
ARCH=$(uname -m)
echo "📱 Detected architecture: $ARCH"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild clean -project SitStraight.xcodeproj -scheme SitStraight

# Build for your specific architecture
echo "🔨 Building for $ARCH..."
xcodebuild build \
    -project SitStraight.xcodeproj \
    -scheme SitStraight \
    -configuration Release \
    -arch $ARCH \
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

    # Remove quarantine attribute to avoid security warnings
    echo "🔓 Removing quarantine attribute..."
    xattr -d com.apple.quarantine "$DIST_DIR/SitStraight.app" 2>/dev/null || true

    echo "📦 App copied to Distribution folder"
    echo "🎉 Ready to install!"
    echo ""
    echo "🎯 Installation Options:"
    echo "1. Install to Applications folder (requires password):"
    echo "   sudo cp -R $DIST_DIR/SitStraight.app /Applications/"
    echo ""
    echo "2. Install to user Applications folder:"
    echo "   cp -R $DIST_DIR/SitStraight.app ~/Applications/"
    echo ""
    echo "3. Run directly:"
    echo "   open $DIST_DIR/SitStraight.app"
    echo ""
    echo "💡 If you get a security warning, right-click the app → Open → Open"
    echo "🚀 The app will automatically register for auto-start on first launch"
    echo ""
    echo "Architecture: $ARCH"
    echo "macOS version: $(sw_vers -productVersion)"
else
    echo "❌ Build failed - app not found at $APP_PATH"
    exit 1
fi
