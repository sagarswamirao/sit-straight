import SwiftUI

struct SettingsView: View {
    @ObservedObject var reminderManager: ReminderManager
    @State private var showingQuitAlert = false
    @State private var isStartButtonHovered = false
    @State private var isQuitButtonHovered = false

    var body: some View {
        VStack(spacing: 20) {
            // Header with gradient background
            VStack(spacing: 8) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Text("Sit Straight")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
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
                // Start/Stop Button
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
                .background(
                    LinearGradient(
                        colors: reminderManager.isRunning ? [.red, .orange] : [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(isStartButtonHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isStartButtonHovered)
                .onHover { hovering in
                    isStartButtonHovered = hovering
                }
                
                // Pause/Resume Button (only show when running)
                if reminderManager.isRunning {
                    Button(action: {
                        if reminderManager.isPaused {
                            reminderManager.resumeTimer()
                        } else {
                            reminderManager.pauseTimer()
                        }
                    }) {
                        HStack {
                            Image(systemName: reminderManager.isPaused ? "play.circle.fill" : "pause.circle.fill")
                            Text(reminderManager.isPaused ? "Resume" : "Pause")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .background(
                        LinearGradient(
                            colors: reminderManager.isPaused ? [.green, .mint] : [.orange, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(isStartButtonHovered ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isStartButtonHovered)
                    .onHover { hovering in
                        isStartButtonHovered = hovering
                    }
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
                .background(
                    LinearGradient(
                        colors: [.red, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
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
