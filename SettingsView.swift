import SwiftUI

struct SettingsView: View {
    @ObservedObject var reminderManager: ReminderManager
    @State private var showingQuitAlert = false
    @State private var isStartButtonHovered = false
    @State private var isQuitButtonHovered = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)

                Text("Sit Straight")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.top, 16)

            // Interval Settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Reminder Interval")
                    .font(.headline)

                HStack {
                    Stepper(value: $reminderManager.intervalMinutes, in: 1...120, step: 1) {
                        Text("\(reminderManager.intervalMinutes) minutes")
                            .font(.body)
                    }
                    .frame(width: 200)
                }
            }

            // Control Buttons
            VStack(spacing: 12) {
                Button(action: {
                    if reminderManager.isRunning {
                        reminderManager.stopTimer()
                    } else {
                        reminderManager.startTimer()
                    }
                }) {
                    HStack {
                        Image(systemName: reminderManager.isRunning ? "stop.circle.fill" : "play.circle.fill")
                        Text(reminderManager.isRunning ? "Stop Reminders" : "Start Reminders")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .scaleEffect(isStartButtonHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isStartButtonHovered)
                .onHover { hovering in
                    isStartButtonHovered = hovering
                }

                Button(action: {
                    showingQuitAlert = true
                }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit App")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .scaleEffect(isQuitButtonHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isQuitButtonHovered)
                .onHover { hovering in
                    isQuitButtonHovered = hovering
                }
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 350, height: 250)
        .alert("Quit Sit Straight?", isPresented: $showingQuitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        } message: {
            Text("Are you sure you want to quit the app?")
        }
    }
}
