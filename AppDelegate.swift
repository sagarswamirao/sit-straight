import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var reminderManager: ReminderManager?

        func applicationDidFinishLaunching(_ notification: Notification) {
            Logger.shared.log("🚀 AppDelegate: applicationDidFinishLaunching called", level: .info)
            
            // Hide the app from the dock
            NSApp.setActivationPolicy(.accessory)

            // Initialize reminder manager first
            reminderManager = ReminderManager()

            // Setup menu bar
            setupMenuBar()

            // Auto-start the timer
            reminderManager?.startTimer()

            // Register for auto-start
            registerForAutoStart()
            
            Logger.shared.log("✅ AppDelegate: initialization complete", level: .info)
            Logger.shared.log("📁 Log file location: \(Logger.shared.getLogFilePath() ?? "Unknown")", level: .info)
        }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // Set up button with countdown timer
            updateMenuBarButton()
            button.action = #selector(togglePopover)

            // Start timer to update menu bar every second
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateMenuBarButton()
            }
        }

        // Create popover
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 350, height: 320)
        popover?.behavior = .transient
        if let reminderManager = reminderManager {
            popover?.contentViewController = NSHostingController(rootView: SettingsView(reminderManager: reminderManager))
        }
    }

    private func updateMenuBarButton() {
        guard let button = statusItem?.button else { return }

        let timeRemaining = reminderManager?.timeRemaining ?? 0
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60

        if let reminderManager = reminderManager, reminderManager.isRunning {
            if reminderManager.isPaused {
                button.title = "⏸️ \(minutes):\(String(format: "%02d", seconds))"
            } else {
                button.title = "🧘 \(minutes):\(String(format: "%02d", seconds))"
            }
        } else {
            button.title = "🧘"
        }
    }

    @objc private func togglePopover() {
        guard let popover = popover, let button = statusItem?.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    private func registerForAutoStart() {
        if #available(macOS 13.0, *) {
            let service = SMAppService.mainApp
            do {
                try service.register()
                print("Successfully registered for auto-start")
            } catch {
                print("Failed to register for auto-start: \(error)")
                // Show user-friendly error if needed
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let alert = NSAlert()
                    alert.messageText = "Auto-Start Registration Failed"
                    alert.informativeText = "The app couldn't register for automatic startup. You can manually add it in System Preferences > Users & Groups > Login Items."
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        } else {
            print("Auto-start registration not available on this macOS version (requires 13.0+)")
            // For older macOS versions, show instructions
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let alert = NSAlert()
                alert.messageText = "Manual Auto-Start Setup Required"
                alert.informativeText = "To enable auto-start, manually add this app in System Preferences > Users & Groups > Login Items."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        Logger.shared.log("🚨 AppDelegate: applicationWillTerminate called", level: .critical)
        reminderManager?.stopTimer()
    }
}
