#!/usr/bin/env python3

import time
import subprocess
import shutil
import os
import argparse
import signal
import sys
from datetime import datetime

class PostureReminder:
    def __init__(self, interval_minutes=20):
        self.interval_minutes = interval_minutes
        self.running = False
        self.paused = False
        
    def displayNotification(self, message, title=None, subtitle=None, soundname="Glass"):
        """
        Display a macOS notification:
        - Uses terminal-notifier if installed (preferred),
        - Falls back to osascript dialog if terminal-notifier is missing,
        - Plays sound where supported.
        """
        notifier_path = shutil.which("terminal-notifier")

        if notifier_path:
            # Prepare terminal-notifier command
            cmd = [notifier_path, "-message", message]
            if title:
                cmd.extend(["-title", title])
            if subtitle:
                cmd.extend(["-subtitle", subtitle])
            if soundname:
                cmd.extend(["-sound", soundname])

            try:
                subprocess.run(cmd, check=True)
                return
            except subprocess.CalledProcessError:
                # Fall through to dialog if terminal-notifier fails
                pass

        # Fallback to osascript dialog
        # Escape quotes in message/title for AppleScript
        safe_message = message.replace('"', '\\"')
        safe_title = (title or "Posture Reminder").replace('"', '\\"')

        dialog_script = f'display dialog "{safe_message}" with title "{safe_title}" buttons {{"OK"}} default button "OK"'

        try:
            os.system(f"osascript -e '{dialog_script}'")
        except Exception as e:
            print(f"Failed to show fallback dialog notification: {e}")

    def playSound(self, sound_name="Glass"):
        """Play a system sound"""
        try:
            os.system(f"afplay /System/Library/Sounds/{sound_name}.aiff")
        except Exception as e:
            print(f"Failed to play sound: {e}")

    def showPostureReminder(self):
        """Show the posture reminder notification and play sound"""
        current_time = datetime.now().strftime("%H:%M")
        
        # Show notification
        self.displayNotification(
            message="🧘 Time to sit straight!\n\nTake a moment to adjust your posture and stretch.",
            title="Posture Reminder",
            subtitle=f"Reminder at {current_time}",
            soundname="Glass"
        )
        
        # Play additional sound
        self.playSound("Glass")
        
        print(f"[{current_time}] Posture reminder sent")

    def start(self):
        """Start the posture reminder daemon"""
        self.running = True
        print(f"🚀 Starting posture reminder daemon (interval: {self.interval_minutes} minutes)")
        print("Press Ctrl+C to stop")
        
        # Show initial notification
        self.displayNotification(
            message=f"Posture reminders started!\n\nI'll remind you every {self.interval_minutes} minutes to sit straight.",
            title="Posture Reminder",
            subtitle="Daemon started"
        )
        
        try:
            while self.running:
                if not self.paused:
                    # Wait for the interval
                    print(f"⏰ Waiting {self.interval_minutes} minutes until next reminder...")
                    time.sleep(self.interval_minutes * 60)
                    
                    if self.running and not self.paused:
                        self.showPostureReminder()
                else:
                    # If paused, check every 10 seconds
                    time.sleep(10)
                    
        except KeyboardInterrupt:
            print("\n🛑 Stopping posture reminder daemon...")
            self.stop()

    def stop(self):
        """Stop the daemon"""
        self.running = False
        self.displayNotification(
            message="Posture reminder daemon stopped.",
            title="Posture Reminder",
            subtitle="Daemon stopped"
        )
        print("✅ Posture reminder daemon stopped")

    def pause(self):
        """Pause the daemon"""
        self.paused = True
        print("⏸️ Posture reminder daemon paused")

    def resume(self):
        """Resume the daemon"""
        self.paused = False
        print("▶️ Posture reminder daemon resumed")

def signal_handler(sig, frame):
    """Handle Ctrl+C gracefully"""
    print("\n🛑 Received interrupt signal, stopping...")
    sys.exit(0)

def main():
    parser = argparse.ArgumentParser(description="Posture Reminder Daemon")
    parser.add_argument("--interval", type=int, default=20, 
                       help="Reminder interval in minutes (default: 20)")
    parser.add_argument("--test", action="store_true", 
                       help="Send a test notification and exit")
    args = parser.parse_args()
    
    # Set up signal handler for graceful shutdown
    signal.signal(signal.SIGINT, signal_handler)
    
    reminder = PostureReminder(interval_minutes=args.interval)
    
    if args.test:
        print("🧪 Sending test notification...")
        reminder.showPostureReminder()
        return
    
    # Start the daemon
    reminder.start()

if __name__ == "__main__":
    main()
