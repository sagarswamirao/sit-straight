#!/bin/bash

echo "🚀 Building and Installing Sit Straight..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    echo "   After installation, run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf DerivedData
rm -rf build
rm -rf dist

# Build the app
echo "🔨 Building SitStraight.app..."
xcodebuild -project SitStraight.xcodeproj \
    -scheme SitStraight \
    -configuration Release \
    -destination "platform=macOS,arch=arm64" \
    build \
    -derivedDataPath ./DerivedData

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"

# Create proper app bundle structure
echo "📱 Creating app bundle..."
APP_PATH="./dist/SitStraight.app"
mkdir -p "$APP_PATH"

# Copy the built app
cp -R DerivedData/Build/Products/Release/SitStraight.app/* "$APP_PATH/"

# Verify the app structure
echo "🔍 Verifying app structure..."
if [ ! -f "$APP_PATH/Contents/MacOS/SitStraight" ]; then
    echo "❌ App executable not found!"
    exit 1
fi

# Check binary architecture
echo "📱 Binary info:"
file "$APP_PATH/Contents/MacOS/SitStraight"

# Remove quarantine attribute to avoid security warnings
echo "🔓 Removing quarantine attribute..."
xattr -d com.apple.quarantine "$APP_PATH" 2>/dev/null || true

# Create installation options
echo ""
echo "🎯 Installation Options:"
echo "1. Install to Applications folder (requires password):"
echo "   sudo cp -R $APP_PATH /Applications/"
echo ""
echo "2. Install to user Applications folder:"
echo "   cp -R $APP_PATH ~/Applications/"
echo ""
echo "3. Run directly from current location:"
echo "   open $APP_PATH"
echo ""

# Ask user what they want to do
read -p "🤔 What would you like to do? (1/2/3): " choice

case $choice in
    1)
        echo "📱 Installing to /Applications/..."
        sudo cp -R "$APP_PATH" /Applications/
        if [ $? -eq 0 ]; then
            echo "✅ Installed successfully!"
            echo "🚀 You can now find 'SitStraight' in your Applications folder"
            echo "💡 If you get a security warning, right-click the app → Open → Open"
        else
            echo "❌ Installation failed!"
        fi
        ;;
    2)
        echo "📱 Installing to ~/Applications/..."
        mkdir -p ~/Applications
        cp -R "$APP_PATH" ~/Applications/
        if [ $? -eq 0 ]; then
            echo "✅ Installed successfully!"
            echo "🚀 You can now find 'SitStraight' in your user Applications folder"
        else
            echo "❌ Installation failed!"
        fi
        ;;
    3)
        echo "🚀 Running app directly..."
        open "$APP_PATH"
        echo "✅ App launched! Look for the arrow icon in your menu bar"
        ;;
    *)
        echo "❌ Invalid choice. App is available at: $APP_PATH"
        ;;
esac

echo ""
echo "🎉 Sit Straight is ready to use!"
echo "📱 Look for the arrow icon in your menu bar"
echo "⚙️  Click it to set your reminder interval and start the timer"
