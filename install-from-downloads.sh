#!/bin/bash

echo "🚀 Installing Sit Straight from Downloads..."

# Go to Downloads folder
cd ~/Downloads

# Check if SitStraight.app exists
if [ ! -f "SitStraight.app" ]; then
    echo "❌ SitStraight.app not found in Downloads"
    echo "📁 Please download the app from GitHub Actions first"
    exit 1
fi

# Check if it's a zip file that needs extraction
if [ -f "SitStraight.app" ] && [ ! -d "SitStraight.app" ]; then
    echo "📦 Extracting app from zip file..."
    unzip -o SitStraight.app
    echo "✅ Extraction complete"
fi

# Check if Contents directory exists (from extraction)
if [ -d "Contents" ]; then
    echo "🔧 Creating proper app bundle structure..."
    # Remove any existing SitStraight.app (file or directory)
    rm -rf SitStraight.app
    mkdir -p SitStraight.app
    mv Contents SitStraight.app/
    echo "✅ App bundle structure created"
fi

# Verify the app structure
if [ ! -f "SitStraight.app/Contents/MacOS/SitStraight" ]; then
    echo "❌ App structure is invalid. Expected: SitStraight.app/Contents/MacOS/SitStraight"
    echo "📁 Current structure:"
    find SitStraight.app -type f | head -10
    exit 1
fi

echo "✅ App structure verified"

# Remove quarantine attribute
echo "🔓 Removing quarantine attribute..."
xattr -d com.apple.quarantine SitStraight.app 2>/dev/null || true

# Install to user Applications folder
echo "📱 Installing to Applications folder..."
mkdir -p ~/Applications
rm -rf ~/Applications/SitStraight.app
cp -R SitStraight.app ~/Applications/

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    echo ""
    echo "🚀 Starting app..."
    open ~/Applications/SitStraight.app
    echo ""
    echo "🎯 Look for the arrow icon in your menu bar!"
else
    echo "❌ Installation failed!"
    exit 1
fi
