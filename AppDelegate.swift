import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var reminderManager: ReminderManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide the app from the dock
        NSApp.setActivationPolicy(.accessory)

        // Initialize reminder manager first
        reminderManager = ReminderManager()

        // Setup menu bar
        setupMenuBar()

        // Register for auto-start
        registerForAutoStart()
    }

    private func setupMenuBar() {
        print("🔧 Setting up menu bar...")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            print("✅ Status bar button created")
            // Try to use custom arrow image, fallback to SF Symbol
            if let customImage = NSImage(named: "menubar-arrow") {
                button.image = customImage
                print("✅ Using custom arrow image")
            } else {
                button.image = NSImage(systemSymbolName: "arrow.up.circle.fill", accessibilityDescription: "Sit Straight")
                print("✅ Using SF Symbol arrow")
            }
            button.action = #selector(togglePopover)
            print("✅ Button action set to togglePopover")
        } else {
            print("❌ Failed to create status bar button")
        }

        // Create popover
        print("🔧 Creating popover...")
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 200)
        popover?.behavior = .transient
        if let reminderManager = reminderManager {
            popover?.contentViewController = NSHostingController(rootView: SettingsView(reminderManager: reminderManager))
            print("✅ Popover content view controller set")
        } else {
            print("❌ ReminderManager is nil, popover will be empty")
        }
        print("✅ Menu bar setup complete")
    }

    @objc private func togglePopover() {
        print("🔍 togglePopover called")
        guard let popover = popover, let button = statusItem?.button else {
            print("❌ Missing popover or button")
            return
        }

        print("✅ Popover and button found")
        if popover.isShown {
            print("📤 Closing popover")
            popover.performClose(nil)
        } else {
            print("📥 Showing popover")
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
        reminderManager?.stopTimer()
    }
}
