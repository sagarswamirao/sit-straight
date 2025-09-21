# Sit Straight - macOS Menu Bar App

A macOS menu bar application that reminds you to sit up straight with beautiful full-screen animations.

## Features

- **Menu Bar Integration**: Lives in the menu bar, not the dock
- **Customizable Intervals**: Set reminder intervals from 1-120 minutes
- **Full-Screen Overlay**: Beautiful animated reminder with upward arrow
- **Auto-Start**: Automatically starts when you log in
- **Clean Animation**: 5-second rise and fade animation
- **Local Distribution**: No App Store required

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later

## Building the App

1. Open `SitStraight.xcodeproj` in Xcode
2. Select the "SitStraight" target
3. Choose "Any Mac (Designed for Mac)" as the destination
4. Build and run (⌘+R) or Archive (⌘+Shift+B)

## Installation

1. Build the app in Xcode
2. The built `.app` file will be in the `DerivedData` folder or you can archive it
3. Drag the `.app` file to your Applications folder
4. The app will automatically register for auto-start on first launch

## Usage

1. Click the arrow icon in your menu bar
2. Set your desired reminder interval (1-120 minutes)
3. Click "Start Reminders" to begin
4. The app will show a full-screen animated reminder at your chosen interval

## Permissions

The app requires the following permissions:
- **Accessibility**: To show full-screen overlays
- **Login Items**: To start automatically on login

These permissions are requested automatically when needed.

## Architecture

- **SitStraightApp.swift**: Main SwiftUI app entry point
- **AppDelegate.swift**: Menu bar setup and auto-start registration
- **ReminderManager.swift**: Timer management and reminder logic
- **SettingsView.swift**: Popover interface for settings
- **ArrowOverlayWindow.swift**: Full-screen overlay window management
- **ArrowOverlayView.swift**: SwiftUI view with animation

## Customization

The app uses SF Symbols for the arrow icon. You can customize:
- Animation duration (currently 5 seconds)
- Arrow size and colors
- Background opacity
- Reminder interval range

## Troubleshooting

If the app doesn't start automatically:
1. Go to System Preferences > Users & Groups > Login Items
2. Make sure "Sit Straight" is listed and enabled

If the overlay doesn't appear:
1. Check System Preferences > Security & Privacy > Privacy > Accessibility
2. Make sure "Sit Straight" is enabled
