#!/bin/bash

# Sit Straight - Universal Binary Build Script
# This script builds a universal binary that works on both Intel and Apple Silicon Macs

set -e

echo "🚀 Building Sit Straight Universal Binary..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild clean -project SitStraight.xcodeproj -scheme SitStraight

# Build for Apple Silicon (arm64)
echo "🔨 Building for Apple Silicon (arm64)..."
xcodebuild build \
    -project SitStraight.xcodeproj \
    -scheme SitStraight \
    -configuration Release \
    -arch arm64 \
    -derivedDataPath ./DerivedData-arm64

# Build for Intel (x86_64)
echo "🔨 Building for Intel (x86_64)..."
xcodebuild build \
    -project SitStraight.xcodeproj \
    -scheme SitStraight \
    -configuration Release \
    -arch x86_64 \
    -derivedDataPath ./DerivedData-x86_64

# Create universal binary
echo "🔗 Creating universal binary..."
APP_ARM64="./DerivedData-arm64/Build/Products/Release/SitStraight.app"
APP_X86_64="./DerivedData-x86_64/Build/Products/Release/SitStraight.app"
UNIVERSAL_APP="./SitStraight-Universal.app"

# Copy arm64 app as base
cp -R "$APP_ARM64" "$UNIVERSAL_APP"

# Create universal binary for the main executable
lipo -create \
    "$APP_ARM64/Contents/MacOS/SitStraight" \
    "$APP_X86_64/Contents/MacOS/SitStraight" \
    -output "$UNIVERSAL_APP/Contents/MacOS/SitStraight"

# Verify the universal binary
echo "✅ Verifying universal binary..."
file "$UNIVERSAL_APP/Contents/MacOS/SitStraight"
lipo -info "$UNIVERSAL_APP/Contents/MacOS/SitStraight"

# Create distribution folder
DIST_DIR="./Distribution"
mkdir -p "$DIST_DIR"

# Copy the universal app
cp -R "$UNIVERSAL_APP" "$DIST_DIR/"

echo "✅ Universal binary build successful!"
echo "📱 App location: $DIST_DIR/SitStraight-Universal.app"
echo ""
echo "To install:"
echo "1. Drag SitStraight-Universal.app to your Applications folder"
echo "2. The app will work on both Intel and Apple Silicon Macs"
echo ""
echo "Note: You may need to grant accessibility permissions in System Preferences"
