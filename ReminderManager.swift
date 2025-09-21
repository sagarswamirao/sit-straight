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
        guard !isRunning else { return }
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
        guard isRunning && !isPaused else { return }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(intervalMinutes * 60), repeats: false) { [weak self] _ in
            self?.showReminder()
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
            guard let self = self else { return }

            // Close any existing overlay first
            self.overlayWindow?.close()
            self.overlayWindow = nil

            // Play reminder sound
            self.audioManager.playReminderSound()

            // Create and show the overlay window
            self.overlayWindow = ArrowOverlayWindow()
            self.overlayWindow?.showOverlay()
            print("✅ Overlay window shown")

            // Schedule next reminder if still running
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
