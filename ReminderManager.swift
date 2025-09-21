import Foundation
import SwiftUI

class ReminderManager: ObservableObject {
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var timeRemaining: Int = 0 // Time remaining in seconds
    @Published var intervalMinutes: Int = 20 {
        didSet {
            if isRunning {
                restartTimer()
            }
        }
    }

    private var timer: Timer?
    private var countdownTimer: Timer?
    private var overlayWindow: ArrowOverlayWindow?
    private let audioManager = AudioManager()
    private var startTime: Date?

    func startTimer() {
        guard !isRunning else { 
            print("⚠️ Timer already running, ignoring start request")
            return 
        }
        print("🚀 Starting timer with \(intervalMinutes) minute intervals")
        isRunning = true
        isPaused = false
        startTime = Date()
        timeRemaining = intervalMinutes * 60
        startCountdownTimer()
        scheduleNextReminder()
    }

    func pauseTimer() {
        guard isRunning && !isPaused else { return }
        print("⏸️ Pausing timer")
        isPaused = true
        timer?.invalidate()
        countdownTimer?.invalidate()
    }

    func resumeTimer() {
        guard isRunning && isPaused else { return }
        print("▶️ Resuming timer")
        isPaused = false
        startCountdownTimer()
        scheduleNextReminder()
    }

    func stopTimer() {
        print("🛑 Stopping timer")
        isRunning = false
        isPaused = false
        timer?.invalidate()
        countdownTimer?.invalidate()
        timer = nil
        countdownTimer = nil
        timeRemaining = 0

        // Clean up overlay window
        DispatchQueue.main.async { [weak self] in
            self?.overlayWindow?.close()
            self?.overlayWindow = nil
        }
        print("✅ Timer stopped and cleaned up")
    }

    deinit {
        print("🗑️ ReminderManager deallocated")
        stopTimer()
    }

    private func startCountdownTimer() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, self.isRunning && !self.isPaused else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.countdownTimer?.invalidate()
            }
        }
    }

    private func scheduleNextReminder() {
        guard isRunning && !isPaused else { 
            print("❌ Not scheduling next reminder - isRunning: \(isRunning), isPaused: \(isPaused)")
            return 
        }

        // Invalidate existing timer
        if timer != nil {
            print("🔄 Invalidating existing timer")
            timer?.invalidate()
        }
        timer = nil
        
        // Create new timer
        let interval = TimeInterval(intervalMinutes * 60)
        print("⏰ Creating new timer with interval: \(interval) seconds (\(intervalMinutes) minutes)")
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            print("⏰ Timer fired - showing reminder")
            self?.showReminder()
        }
        
        // Verify timer was created successfully
        if timer != nil {
            print("✅ Next reminder scheduled in \(intervalMinutes) minutes")
        } else {
            print("❌ Failed to create timer!")
        }
    }

    private func restartTimer() {
        if isRunning {
            stopTimer()
            startTimer()
        }
    }

    private func showReminder() {
        print("🔔 Showing reminder...")

        // Ensure all UI operations happen on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { 
                print("❌ Self is nil in showReminder callback")
                return 
            }

            print("🧹 Cleaning up existing overlay window")
            // Close any existing overlay first
            self.overlayWindow?.close()
            self.overlayWindow = nil

            print("🔊 Playing reminder sound")
            // Play reminder sound
            self.audioManager.playReminderSound()

            // Create and show the overlay window with delay to ensure cleanup
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { 
                    print("❌ Self is nil in overlay creation callback")
                    return 
                }
                
                print("🎬 Creating new overlay window")
                self.overlayWindow = ArrowOverlayWindow()
                self.overlayWindow?.showOverlay()
                print("✅ Overlay window shown")
            }

            // Schedule next reminder if still running
            print("🔄 Checking if timer should continue - isRunning: \(self.isRunning)")
            if self.isRunning {
                print("⏰ Scheduling next reminder in \(self.intervalMinutes) minutes")
                self.timeRemaining = self.intervalMinutes * 60
                self.startCountdownTimer()
                self.scheduleNextReminder()
            } else {
                print("❌ Timer is not running, not scheduling next reminder")
            }
        }
    }
}
