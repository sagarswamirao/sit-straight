#!/bin/bash

# Install Posture Reminder Daemon
# Similar to ~/scripts/gtrack setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Installing Posture Reminder Daemon...${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/scripts"
DAEMON_NAME="posture-reminder"

# Create scripts directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${BLUE}📁 Creating scripts directory: $TARGET_DIR${NC}"
    mkdir -p "$TARGET_DIR"
fi

# Copy the daemon script
echo -e "${BLUE}📋 Copying daemon script...${NC}"
cp "$SCRIPT_DIR/posture-daemon.sh" "$TARGET_DIR/$DAEMON_NAME"
chmod +x "$TARGET_DIR/$DAEMON_NAME"

# Copy the Python script
echo -e "${BLUE}🐍 Copying Python script...${NC}"
cp "$SCRIPT_DIR/posture-reminder.py" "$TARGET_DIR/"

# Create a symlink for easy access
if [ ! -L "$TARGET_DIR/gtrack" ] && [ ! -f "$TARGET_DIR/gtrack" ]; then
    echo -e "${BLUE}🔗 Creating symlink for easy access...${NC}"
    ln -s "$TARGET_DIR/$DAEMON_NAME" "$TARGET_DIR/gtrack"
fi

# Check if terminal-notifier is installed
if ! command -v terminal-notifier &> /dev/null; then
    echo -e "${YELLOW}⚠️  terminal-notifier not found. Installing via Homebrew...${NC}"
    if command -v brew &> /dev/null; then
        brew install terminal-notifier
    else
        echo -e "${YELLOW}⚠️  Homebrew not found. Please install terminal-notifier manually:${NC}"
        echo -e "${YELLOW}   brew install terminal-notifier${NC}"
        echo -e "${YELLOW}   Or the daemon will use osascript as fallback${NC}"
    fi
fi

echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo -e "${BLUE}📖 Usage:${NC}"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME start${NC}     # Start the daemon"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME stop${NC}      # Stop the daemon"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME status${NC}    # Check status"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME test${NC}      # Test notification"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME logs${NC}      # View logs"
echo ""
echo -e "${BLUE}🚀 Quick start:${NC}"
echo -e "  ${YELLOW}$TARGET_DIR/$DAEMON_NAME start${NC}"
echo ""
echo -e "${BLUE}📝 The daemon will:${NC}"
echo -e "  • Remind you every 20 minutes to sit straight"
echo -e "  • Show macOS notifications"
echo -e "  • Play system sounds"
echo -e "  • Log activity to ~/.posture-reminder.log"
echo ""
echo -e "${GREEN}🎉 Ready to go!${NC}"
