#!/bin/bash

echo "🧪 Testing Sit Straight app..."

# Kill any existing instances
echo "🔄 Killing existing instances..."
killall SitStraight 2>/dev/null || true

# Wait a moment
sleep 1

# Run the app in the background and capture output
echo "🚀 Starting app..."
/Applications/SitStraight.app/Contents/MacOS/SitStraight &
APP_PID=$!

echo "📱 App started with PID: $APP_PID"
echo "🔍 Check the menu bar for the arrow icon"
echo "🖱️  Click the arrow to test the popover"
echo ""
echo "📋 To check logs, run:"
echo "   log show --predicate 'process == \"SitStraight\"' --last 1m"
echo ""
echo "🛑 To stop the app, run:"
echo "   kill $APP_PID"
echo "   or killall SitStraight"
