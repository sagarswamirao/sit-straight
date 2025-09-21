import SwiftUI

struct SettingsView: View {
    @ObservedObject var reminderManager: ReminderManager
    @State private var showingQuitAlert = false
    @State private var isStartButtonHovered = false
    @State private var isPauseButtonHovered = false
    @State private var isQuitButtonHovered = false
    @State private var showingTimePicker = false

    var body: some View {
        VStack(spacing: 20) {
            // Header with gradient background
            VStack(spacing: 8) {
                Image(systemName: "figure.seated.side")
                    .font(.system(size: 32))
                    .foregroundColor(.primary)

                Text("Sit Straight")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.top, 16)

            // Interval Settings - Same line layout
            HStack(spacing: 16) {
                Text("Reminder Interval")
                    .font(.headline)
                    .frame(width: 120, alignment: .leading)

                Button(action: {
                    showingTimePicker = true
                }) {
                    HStack {
                        Text("\(reminderManager.intervalMinutes) min")
                            .font(.body)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.controlBackgroundColor))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
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
                .tint(reminderManager.isRunning ? .red : .green)
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
                    .tint(reminderManager.isPaused ? .green : .orange)
                    .scaleEffect(isPauseButtonHovered ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPauseButtonHovered)
                    .onHover { hovering in
                        isPauseButtonHovered = hovering
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
                .tint(.red)
                .scaleEffect(isQuitButtonHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isQuitButtonHovered)
                .onHover { hovering in
                    isQuitButtonHovered = hovering
                }
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 350, height: 320)
        .alert("Quit Sit Straight?", isPresented: $showingQuitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Quit", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        } message: {
            Text("Are you sure you want to quit the app?")
        }
        .sheet(isPresented: $showingTimePicker) {
            VStack(spacing: 20) {
                Text("Select Reminder Interval")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)

                Picker("Minutes", selection: $reminderManager.intervalMinutes) {
                    ForEach(1...60, id: \.self) { minute in
                        Text("\(minute) min")
                            .tag(minute)
                    }
                }
                .pickerStyle(.menu)
                .frame(height: 50)

                HStack(spacing: 16) {
                    Button("Cancel") {
                        showingTimePicker = false
                    }
                    .buttonStyle(.bordered)

                    Button("Done") {
                        showingTimePicker = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 20)
            }
            .frame(width: 300, height: 300)
        }
    }
}
