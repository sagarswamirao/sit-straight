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

    func startTimer() {
        guard !isRunning else { return }

        isRunning = true
        scheduleNextReminder()
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
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
        // Create and show the overlay window
        overlayWindow = ArrowOverlayWindow()
        overlayWindow?.showOverlay()

        // Schedule next reminder if still running
        if isRunning {
            scheduleNextReminder()
        }
    }
}
