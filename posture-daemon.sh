#!/bin/bash

# Posture Reminder Daemon Launcher
# Similar to ~/scripts/gtrack but for posture reminders

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/posture-reminder.py"
PID_FILE="$HOME/.posture-reminder.pid"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if daemon is running
is_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        else
            # PID file exists but process is dead, clean up
            rm -f "$PID_FILE"
            return 1
        fi
    fi
    return 1
}

# Function to start the daemon
start_daemon() {
    if is_running; then
        echo -e "${YELLOW}⚠️  Posture reminder daemon is already running${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🚀 Starting posture reminder daemon...${NC}"
    
    # Start the Python script in background
    nohup python3 "$PYTHON_SCRIPT" --interval 20 > "$HOME/.posture-reminder.log" 2>&1 &
    local pid=$!
    
    # Save PID
    echo "$pid" > "$PID_FILE"
    
    # Wait a moment to check if it started successfully
    sleep 2
    if is_running; then
        echo -e "${GREEN}✅ Posture reminder daemon started (PID: $pid)${NC}"
        echo -e "${BLUE}📝 Logs: $HOME/.posture-reminder.log${NC}"
        echo -e "${BLUE}🛑 To stop: $0 stop${NC}"
    else
        echo -e "${RED}❌ Failed to start posture reminder daemon${NC}"
        rm -f "$PID_FILE"
        return 1
    fi
}

# Function to stop the daemon
stop_daemon() {
    if ! is_running; then
        echo -e "${YELLOW}⚠️  Posture reminder daemon is not running${NC}"
        return 1
    fi
    
    local pid=$(cat "$PID_FILE")
    echo -e "${BLUE}🛑 Stopping posture reminder daemon (PID: $pid)...${NC}"
    
    # Send SIGTERM first
    kill "$pid" 2>/dev/null
    
    # Wait for graceful shutdown
    local count=0
    while [ $count -lt 10 ] && ps -p "$pid" > /dev/null 2>&1; do
        sleep 1
        count=$((count + 1))
    done
    
    # Force kill if still running
    if ps -p "$pid" > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Force killing daemon...${NC}"
        kill -9 "$pid" 2>/dev/null
    fi
    
    rm -f "$PID_FILE"
    echo -e "${GREEN}✅ Posture reminder daemon stopped${NC}"
}

# Function to show status
show_status() {
    if is_running; then
        local pid=$(cat "$PID_FILE")
        echo -e "${GREEN}✅ Posture reminder daemon is running (PID: $pid)${NC}"
        echo -e "${BLUE}📝 Logs: $HOME/.posture-reminder.log${NC}"
    else
        echo -e "${RED}❌ Posture reminder daemon is not running${NC}"
    fi
}

# Function to show logs
show_logs() {
    if [ -f "$HOME/.posture-reminder.log" ]; then
        echo -e "${BLUE}📝 Recent logs:${NC}"
        tail -20 "$HOME/.posture-reminder.log"
    else
        echo -e "${YELLOW}⚠️  No log file found${NC}"
    fi
}

# Function to test notification
test_notification() {
    echo -e "${BLUE}🧪 Testing notification...${NC}"
    python3 "$PYTHON_SCRIPT" --test
}

# Function to show help
show_help() {
    echo -e "${BLUE}Posture Reminder Daemon${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start the posture reminder daemon"
    echo "  stop      Stop the posture reminder daemon"
    echo "  restart   Restart the posture reminder daemon"
    echo "  status    Show daemon status"
    echo "  logs      Show recent logs"
    echo "  test      Send a test notification"
    echo "  help      Show this help message"
    echo ""
    echo "The daemon will remind you every 20 minutes to sit straight."
    echo "Notifications will appear in the macOS notification center."
}

# Main script logic
case "${1:-help}" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    restart)
        stop_daemon
        sleep 1
        start_daemon
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    test)
        test_notification
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ Unknown command: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
