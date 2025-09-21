#!/bin/bash

echo "🚀 Downloading and Installing Sit Straight..."

# Get the latest successful build
echo "📱 Getting latest build info..."
LATEST_RUN=$(curl -s https://api.github.com/repos/sagarswamirao/sit-straight/actions/runs | jq -r '.workflow_runs[] | select(.conclusion == "success") | .id' | head -1)

if [ -z "$LATEST_RUN" ]; then
    echo "❌ No successful builds found"
    exit 1
fi

echo "📱 Latest build: $LATEST_RUN"

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📦 Downloading app..."
# For now, we'll use a direct approach since GitHub requires authentication
echo "⚠️  Please download the latest SitStraight.app from:"
echo "   https://github.com/sagarswamirao/sit-straight/actions"
echo "   Then run: ./install-app.sh"
echo ""
echo "📁 Or copy the install-app.sh script to your Downloads folder and run it there"

# Clean up
cd /Users/sagarswamiraokulkarni/MS2/sit-straight
rm -rf "$TEMP_DIR"
