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

    echo "📦 App copied to Distribution folder"
    echo "🎉 Ready to install!"
    echo ""
    echo "To install:"
    echo "1. Drag SitStraight.app from the Distribution folder to your Applications folder"
    echo "2. If you get a security warning, right-click and select 'Open'"
    echo "3. The app will automatically register for auto-start on first launch"
    echo ""
    echo "Architecture: $ARCH"
    echo "macOS version: $(sw_vers -productVersion)"
else
    echo "❌ Build failed - app not found at $APP_PATH"
    exit 1
fi
