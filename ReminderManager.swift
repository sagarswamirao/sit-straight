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
            Logger.shared.log("⚠️ Timer already running, ignoring start request", level: .warning)
            return 
        }
        Logger.shared.log("🚀 Starting timer with \(intervalMinutes) minute intervals", level: .info)
        isRunning = true
        isPaused = false
        startTime = Date()
        timeRemaining = intervalMinutes * 60
        startCountdownTimer()
        scheduleNextReminder()
    }

    func pauseTimer() {
        guard isRunning && !isPaused else { return }
        Logger.shared.log("⏸️ Pausing timer", level: .info)
        isPaused = true
        timer?.invalidate()
        countdownTimer?.invalidate()
    }

    func resumeTimer() {
        guard isRunning && isPaused else { return }
        Logger.shared.log("▶️ Resuming timer", level: .info)
        isPaused = false
        startCountdownTimer()
        scheduleNextReminder()
    }

    func stopTimer() {
        Logger.shared.log("🛑 Stopping timer", level: .info)
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
        Logger.shared.log("✅ Timer stopped and cleaned up", level: .info)
    }

    deinit {
        Logger.shared.log("🗑️ ReminderManager deallocated", level: .debug)
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
            Logger.shared.log("❌ Not scheduling next reminder - isRunning: \(isRunning), isPaused: \(isPaused)", level: .warning)
            return 
        }

        // Invalidate existing timer
        if timer != nil {
            Logger.shared.log("🔄 Invalidating existing timer", level: .debug)
            timer?.invalidate()
        }
        timer = nil
        
        // Create new timer
        let interval = TimeInterval(intervalMinutes * 60)
        Logger.shared.log("⏰ Creating new timer with interval: \(interval) seconds (\(intervalMinutes) minutes)", level: .debug)
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Logger.shared.log("⏰ Timer fired - showing reminder", level: .info)
            self?.showReminder()
        }
        
        // Verify timer was created successfully
        if timer != nil {
            Logger.shared.log("✅ Next reminder scheduled in \(intervalMinutes) minutes", level: .info)
        } else {
            Logger.shared.log("❌ Failed to create timer!", level: .error)
        }
    }

    private func restartTimer() {
        if isRunning {
            stopTimer()
            startTimer()
        }
    }

    private func showReminder() {
        Logger.shared.log("🔔 Showing reminder...", level: .info)

        // Ensure all UI operations happen on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { 
                Logger.shared.log("❌ Self is nil in showReminder callback", level: .error)
                return 
            }

            Logger.shared.log("🧹 Cleaning up existing overlay window", level: .debug)
            // Close any existing overlay first
            self.overlayWindow?.close()
            self.overlayWindow = nil

            Logger.shared.log("🔊 Playing reminder sound", level: .debug)
            // Play reminder sound
            self.audioManager.playReminderSound()

            // Create and show the overlay window with delay to ensure cleanup
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { 
                    Logger.shared.log("❌ Self is nil in overlay creation callback", level: .error)
                    return 
                }
                
                Logger.shared.log("🎬 Creating new overlay window", level: .debug)
                self.overlayWindow = ArrowOverlayWindow()
                self.overlayWindow?.showOverlay()
                Logger.shared.log("✅ Overlay window shown", level: .info)
            }

            // Schedule next reminder if still running
            Logger.shared.log("🔄 Checking if timer should continue - isRunning: \(self.isRunning)", level: .debug)
            if self.isRunning {
                Logger.shared.log("⏰ Scheduling next reminder in \(self.intervalMinutes) minutes", level: .info)
                self.timeRemaining = self.intervalMinutes * 60
                self.startCountdownTimer()
                self.scheduleNextReminder()
            } else {
                Logger.shared.log("❌ Timer is not running, not scheduling next reminder", level: .warning)
            }
        }
    }
}
