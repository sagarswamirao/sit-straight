#!/bin/bash

echo "🔍 Debug Test for Sit Straight"
echo "================================"

# Kill any existing instances
echo "🔄 Killing existing instances..."
killall SitStraight 2>/dev/null || true
sleep 1

echo "🚀 Starting app in foreground to see debug output..."
echo "📱 Look for the arrow in your menu bar"
echo "🖱️  Click the arrow - you should see an alert dialog"
echo ""
echo "Press Ctrl+C to stop the app when done testing"
echo ""

# Run the app in foreground
/Applications/SitStraight.app/Contents/MacOS/SitStraight
