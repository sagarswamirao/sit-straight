import Foundation
import SwiftUI

class ReminderManager: ObservableObject {
    @Published var isRunning = false
    @Published var intervalMinutes: Int = 20 {
        didSet {
            if isRunning {
                restartTimer()
            }
        }
    }

    private var timer: Timer?
    private var overlayWindow: ArrowOverlayWindow?
    private let audioManager = AudioManager()

    func startTimer() {
        guard !isRunning else { return }
        print("🚀 Starting timer with \(intervalMinutes) minute intervals")
        isRunning = true
        scheduleNextReminder()
    }

    func stopTimer() {
        print("🛑 Stopping timer")
        isRunning = false
        timer?.invalidate()
        timer = nil
        
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

    private func scheduleNextReminder() {
        guard isRunning else { return }

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
                self.scheduleNextReminder()
            } else {
                print("❌ Timer is not running, not scheduling next reminder")
            }
        }
    }
}
