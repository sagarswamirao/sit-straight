import Cocoa
import SwiftUI

class ArrowOverlayWindow: NSWindow {
    private var overlayView: ArrowOverlayView?

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        setupWindow()
    }

    convenience init() {
        // Get the main screen bounds
        guard let screen = NSScreen.main else {
            fatalError("No main screen available")
        }

        self.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
    }

    private func setupWindow() {
        // Make it a full-screen overlay that appears on top of everything
        level = .screenSaver  // Highest level for fullscreen support
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        
        // Ensure it appears on all spaces and fullscreen apps
        if #available(macOS 10.11, *) {
            collectionBehavior.insert(.fullScreenAuxiliary)
        }

        // Create the overlay view
        overlayView = ArrowOverlayView()
        contentView = NSHostingView(rootView: overlayView)

        // Center the window
        center()
    }

    func showOverlay() {
        print("🎬 Showing overlay window...")

        // Ensure we're on the main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.showOverlay()
            }
            return
        }

        // Show the window
        makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        // Start the animation
        overlayView?.startAnimation()
        print("✅ Animation started")

        // Auto-hide after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            print("🔄 Auto-hiding overlay window")
            self?.hideOverlay()
        }
    }

    func hideOverlay() {
        // Ensure we're on the main thread
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.hideOverlay()
            }
            return
        }
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            self.animator().alphaValue = 0.0
        } completionHandler: { [weak self] in
            self?.close()
        }
    }

    deinit {
        print("🗑️ ArrowOverlayWindow deallocated")
        close()
    }
}
