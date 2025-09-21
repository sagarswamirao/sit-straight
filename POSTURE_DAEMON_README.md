# Posture Reminder Daemon

A simple, reliable posture reminder system similar to `~/scripts/gtrack` that uses macOS notifications.

## 🚀 Quick Start

1. **Install the daemon:**
   ```bash
   ./install-posture-daemon.sh
   ```

2. **Start the daemon:**
   ```bash
   ~/scripts/posture-reminder start
   ```

3. **Test notification:**
   ```bash
   ~/scripts/posture-reminder test
   ```

## 📋 Features

- **Reliable**: Uses Python with simple timer logic (no complex Swift timer management)
- **macOS Notifications**: Shows native macOS notifications with sounds
- **Background Daemon**: Runs in background, survives terminal closure
- **Easy Management**: Simple start/stop/status commands
- **Logging**: All activity logged to `~/.posture-reminder.log`
- **Configurable**: Adjustable reminder interval (default: 20 minutes)

## 🛠️ Commands

```bash
# Start the daemon
~/scripts/posture-reminder start

# Stop the daemon
~/scripts/posture-reminder stop

# Restart the daemon
~/scripts/posture-reminder restart

# Check status
~/scripts/posture-reminder status

# View logs
~/scripts/posture-reminder logs

# Test notification
~/scripts/posture-reminder test

# Show help
~/scripts/posture-reminder help
```

## 🔧 Configuration

The daemon reminds you every **20 minutes** by default. To change the interval, edit the Python script:

```python
# In posture-reminder.py, change this line:
reminder = PostureReminder(interval_minutes=20)  # Change 20 to your desired interval
```

## 📁 Files

- `posture-reminder.py` - Main Python daemon script
- `posture-daemon.sh` - Launcher/management script
- `install-posture-daemon.sh` - Installation script
- `~/.posture-reminder.pid` - PID file (created when running)
- `~/.posture-reminder.log` - Log file (created when running)

## 🎯 Why This Approach?

The original Swift app had complex timer management issues. This Python daemon approach:

1. **Simpler**: Uses basic Python `time.sleep()` - no complex timer invalidation
2. **Reliable**: No memory management issues or race conditions
3. **Familiar**: Similar to your existing `~/scripts/gtrack` pattern
4. **Maintainable**: Easy to modify and debug
5. **Lightweight**: Minimal resource usage

## 🔍 Troubleshooting

**Daemon won't start:**
```bash
# Check logs
~/scripts/posture-reminder logs

# Check if Python 3 is installed
python3 --version
```

**No notifications:**
```bash
# Test notification
~/scripts/posture-reminder test

# Check if terminal-notifier is installed
which terminal-notifier
```

**Daemon keeps stopping:**
```bash
# Check status
~/scripts/posture-reminder status

# Restart
~/scripts/posture-reminder restart
```

## 🚀 Auto-start (Optional)

To start the daemon automatically on login, add this to your shell profile:

```bash
# Add to ~/.zshrc or ~/.bash_profile
~/scripts/posture-reminder start
```

## 📱 Notification Preview

When a reminder triggers, you'll see:
- **Title**: "Posture Reminder"
- **Message**: "🧘 Time to sit straight!\n\nTake a moment to adjust your posture and stretch."
- **Sound**: Glass notification sound
- **Time**: Current time in subtitle

This approach is much more reliable than the complex Swift app and follows the same pattern as your existing scripts!
