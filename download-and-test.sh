#!/bin/bash

echo "🚀 Downloading and testing Sit Straight app..."

# Get the latest successful build
LATEST_RUN=$(curl -s https://api.github.com/repos/sagarswamirao/sit-straight/actions/runs | jq -r '.workflow_runs[] | select(.conclusion == "success") | .id' | head -1)

if [ -z "$LATEST_RUN" ]; then
    echo "❌ No successful builds found"
    exit 1
fi

echo "📱 Latest successful build: $LATEST_RUN"

# Get artifact download URL
ARTIFACT_URL=$(curl -s "https://api.github.com/repos/sagarswamirao/sit-straight/actions/runs/$LATEST_RUN/artifacts" | jq -r '.artifacts[0].archive_download_url')

if [ -z "$ARTIFACT_URL" ] || [ "$ARTIFACT_URL" = "null" ]; then
    echo "❌ No artifacts found for build $LATEST_RUN"
    exit 1
fi

echo "📦 Downloading artifact..."

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download artifact (requires GitHub token for private repos, but this is public)
curl -L -H "Accept: application/vnd.github+json" -o artifact.zip "$ARTIFACT_URL"

if [ ! -f "artifact.zip" ]; then
    echo "❌ Failed to download artifact"
    exit 1
fi

echo "📱 Extracting app..."
unzip -q artifact.zip

if [ ! -d "SitStraight.app" ]; then
    echo "❌ App not found in artifact"
    ls -la
    exit 1
fi

echo "✅ App downloaded successfully!"
echo "📱 App info:"
file SitStraight.app/Contents/MacOS/SitStraight
ls -la SitStraight.app/Contents/MacOS/

echo ""
echo "🚀 To install the app:"
echo "   sudo cp -R SitStraight.app /Applications/"
echo ""
echo "🧪 To test the app:"
echo "   open SitStraight.app"
echo ""
echo "📁 App is located at: $TEMP_DIR/SitStraight.app"
